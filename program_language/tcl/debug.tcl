### 只支持 proc 断点
### 不支持嵌套断点，即为断点函数的子函数打断点
### step 调试还不完善，在子函数内无法使用 next，仍需使用 step
### 同一 proc 只能打一个断点
### 由于 trace 命令只能追踪已定义函数，因此要在 proc 定义后才能打断点，否则无效
### 由于 trace 回调函数不带命名空间，因此不支持不同命名空间的同名 proc
### 用法：b proc_name[:file_line_number]
###   如：b test:10; b my_namespace::test:10

namespace eval tdb {

# 所有全局变量
namespace eval glv {
    # 所有文件内容
    set file_lines [dict create]
    # 所有 proc 内容
    set proc_lines [dict create]

    # 所有断点信息
    # {proc_name: {             proc_name 不包括 namespace
    #     "namespace": ::,      proc 所属 namespace
    #     "line": 1,            断点行号，0 表示刚进入 proc
    #     "triggered": false,   当进入函数时，是否已经触发了断点(多次进入可多次触发)，仅行号为 0 时生效
    # }}
    set breakpoints [dict create]

    # 正在调试的 proc
    set debugging_proc ""

    # 行调试开关
    set next_line false
    # 行调试是否进入子函数开关
    set enter_sub_proc false

    # 运行到指定行调试
    set until_line_num 0
}

# 突出显示
# content_type: 文件 或 proc
proc highlight_frame {frame} {
    set frame_type [dict get $frame type]
    switch -exact [dict get $frame type] {
        source  { set entity [dict get $frame file] }
        proc    { set entity [dict get $frame proc] }
        eval    { set entity EVAL_TODO }
        default { set entity NONE }
    }
    puts "\033\[35m$frame_type: \033\[36m$entity\033\[0m"
}


# 显示当前堆栈代码
proc _show_line {cur_frame {size 5}} {
    # 去掉当前栈，所以需要 - 1
    set frame [info frame $cur_frame]
    highlight_frame $frame

    switch -exact [dict get $frame "type"] {
        source  { set lines [_get_file_lines [dict get $frame file]] }
        proc    { set lines [_get_proc_lines [dict get $frame proc]] }
        eval -
        default {
            puts $frame
            return
        }
    }

    set line_num [dict get $frame "line"]
    set start [expr max(0, $line_num - $size)]
    set end [expr min([llength $lines], $line_num + $size)]
    set num_width [string length $end]
    for {set i $start} {$i < $end} {incr i} {
        set mark " "
        set cur_line_num [expr $i + 1]
        if {$cur_line_num == $line_num} {
            set mark ">"
        }
        set line_mark [format "%*s" $num_width $cur_line_num]
        set print_line "$mark $line_mark: [lindex $lines $i]"
        if {$mark == ">"} {
            puts "\033\[32m$print_line\033\[0m"
        } else {
            puts $print_line
        }
    }
}

proc _get_file_lines {file} {
    if {![dict exists $glv::file_lines $file]} {
        set fp [open $file r]
        set lines {}
        while {[gets $fp line] != -1} {
            lappend lines $line
        }
        close $fp
        dict set glv::file_lines $file $lines
    }
    return [dict get $glv::file_lines $file]
}
proc _get_proc_lines {proc_name} {
    if {![dict exists $glv::proc_lines $proc_name]} {
        set proc_body [info body $proc_name]
        set lines [split $proc_body "\n"]
        lset lines 0 "proc $proc_name \{[info args $proc_name]\}:"
        dict set glv::proc_lines $proc_name $lines
    }
    return [dict get $glv::proc_lines $proc_name]
}

# 获取断点函数所在帧
proc _get_current_frame {{skip_eval false}} {
    set max_frame [info frame]
    set cur_frame [expr $max_frame - 1]
    # 跳过 debug 帧
    while {1} {
        set cf [info frame $cur_frame]
        switch -exact [dict get $cf "type"] {
            source {
                if {[string equal "debug.tcl" [file tail [dict get $cf "file"]]]} {
                    incr cur_frame -1
                } else {
                    break
                }
            }
            proc {
                if {[string match "::tdb::*" [dict get $cf "proc"]]} {
                    incr cur_frame -1
                } else {
                    break
                }
            }
            eval {
                if {$skip_eval || [string match "tdb::*" [dict get $cf "cmd"]]} {
                    incr cur_frame -1
                } else {
                    break
                }
            }
            default { break }
        }
    }
    return $cur_frame
}
proc _show_current_frame_detail {msg} {
    puts $msg
    set cf [info frame [_get_current_frame]]
    switch -exact [dict get $cf "type"] {
        source { puts "file: [dict get $cf file]" }
        proc { puts "proc: [dict get $cf proc]" }
        eval { puts "eval: [dict get $cf cmd]" }
    }
    puts "line: [dict get $cf line]"
}


# 设置断点，可输入 tcl 命令以及自定义调试命令
proc break_now {} {
    set ini_frame [_get_current_frame]
    set cur_frame $ini_frame
    _show_line $cur_frame

    while {1} {
        puts -nonewline "tdb > "
        flush stdout
        gets stdin user_input
        switch -regexp $user_input {
            # 退出
            ^q$ -
            ^exit$ { exit }

            ^c$ {
                # 取消行断点
                set glv::next_line false
                break
            }

            ^n$ -
            ^next$ {
                set glv::next_line true
                break
            }

            ^s$ -
            ^step$ {
                set glv::next_line true
                set glv::enter_sub_proc true
                break
            }

            {^t\s*\d+$} -
            {^until?\s*\d+$} {
                set glv::next_line false
                regexp {\d+} $user_input line_num
                set glv::until_line_num $line_num
                break
            }

            # 显示所有堆栈
            ^bt$ -
            ^backtrace$ {
                for {set i 1} {$i <= $cur_frame} {incr i} {
                    puts "$i: [info frame $i]"
                }
            }

            # 跳转到指定堆栈
            {^f\s*\d+$} {
                regexp {\d+} $user_input index
                set cur_frame $index
                _show_line $cur_frame
            }

            # 显示源代码
            {^\.\s*\d*$} {
                if {[regexp {\d+} $user_input size]} {
                    _show_line $cur_frame $size
                } else {
                    _show_line $cur_frame
                }
            }

            default {
                set level [expr $ini_frame - $cur_frame + 2]
                catch {uplevel $level $user_input} result
                if {![regexp {^puts} $user_input]} {
                    puts $result
                }
            }
        }
    }
}

proc _add_breakpoint {name_space proc_name line} {
    if {[dict exists $glv::breakpoints $proc_name]} {
        puts "Duplicated breakpoint for ${name_space}::$proc_name"
        exit
    }
    set full_name "$name_space$proc_name"
    dict set glv::breakpoints $proc_name [dict create "namespace" $name_space "line" $line "triggered" false]
    trace add execution $full_name enter tdb::_proc_b_enter_wrapper
    trace add execution $full_name leave tdb::_proc_b_leave_wrapper
    trace add execution $full_name enterstep tdb::_proc_b_enter_step_wrapper
    trace add execution $full_name leavestep tdb::_proc_b_leave_step_wrapper
}
proc _set_break_info {key value} {
    set b_info [dict get $glv::breakpoints $glv::debugging_proc]
    dict set b_info $key $value
    dict set glv::breakpoints $glv::debugging_proc $b_info
}
proc _get_break_info {key} {
    set b_info [dict get $glv::breakpoints $glv::debugging_proc]
    return [dict get $b_info $key]
}

proc _proc_b_enter_wrapper {cmd args} {
    set glv::debugging_proc [lindex [split $cmd] 0]
}
proc _proc_b_leave_wrapper {cmd args} {
    _set_break_info "triggered" false
    set glv::debugging_proc ""
}
proc _proc_b_enter_step_wrapper {cmd args} {
    set tar_line [_get_break_info "line"]
    set frame [info frame [_get_current_frame true]]
    set cur_line [dict get $frame "line"]

    if {[dict exists $frame proc]} {
        regexp {\w+$} [dict get $frame proc] match
        set cur_proc $match
    } else {
        set cur_proc ""
    }

    if {[string equal $cur_proc $glv::debugging_proc]} {
        # 断点函数内
        if {$tar_line == 0 && ![_get_break_info "triggered"]} {
            # 断点未设置行号且刚进入函数
            _set_break_info "triggered" true
            break_now
        } elseif {[string equal $tar_line $cur_line]} {
            # 当前行号和断点行号一致
            break_now
        } elseif {[string equal $glv::until_line_num $cur_line]} {
            # 当前行号和 until 行号一致
            set glv::until_line_num 0
            break_now
        } elseif {$glv::next_line} {
            # 行调试
            set glv::next_line false
            break_now
        }
    } else {
        # 非断点函数内
        if {$glv::next_line} {
            # 行调试
            if {$glv::enter_sub_proc} {
                # 进入子函数
                set glv::enter_sub_proc false
                set glv::next_line false
                break_now
            }
        }
    }
}
proc _proc_b_leave_step_wrapper {cmd args} {
}

proc _get_procs {name_space} {
    namespace eval $name_space { return [info procs] }
}

# 目前只支持对 proc 打断点，不支持文件断点
proc b {desc} {
    if {[regexp {^(\w+::)*(\w+)(:\d+)*} $desc match name_space proc_name line]} {
        set name_space "::[string trimleft $name_space :]"
        set line [string trim $line :]
        if {[string length $line] == 0} {
            set line 0
        }

        set valid_procs [_get_procs $name_space]

        if {[lsearch -exact $valid_procs $proc_name] >= 0} {
            _add_breakpoint $name_space $proc_name $line
        } else {
            _show_current_frame_detail "proc is undefined when try make breakpoint: $desc"
            exit
        }
    } else {
        puts "Invalid breakpoint pattern: $desc"
    }
}

namespace export b
# namespace tdb end
}

namespace import tdb::b
