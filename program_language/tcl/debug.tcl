### 只支持 proc 断点
### 同一 proc 只能打一个断点
### 不支持嵌套断点，即为断点函数的子函数打断点
### 由于 trace 命令只能追踪已定义函数，因此要在 proc 定义后才能打断点，否则无效
### 由于 trace 回调函数不带命名空间，因此不支持不同命名空间的同名 proc
### 用法：b proc_name[:file_line_number]
###   如：b test:10; b my_namespace::test:10

### continue(c)     : 下一个断点
### next(n)         : 下一行(不进入子函数)
### step(s)         : 下一行(进入子函数)
### until(t)        : 直到指定行，t<num> 表示直到哪一行
### finish(f)       : 直到退出当前函数
### backtrace(bt)   : 显示所有堆栈
### frame(f)        : 跳到指定堆栈，f<num> 表示跳到哪一级
### puts(p)         : 打印所有局部变量，p <anything> 表示tcl puts 命令
### pa              : 打印 array，pa <arr_name>
### .               : 显示源代码，.<num> 表示显示上下多少行
### 普通变量         : 普通变量会自动调用 puts 打印

### TODO
### 断点编号，查看断点，动态增删断点，可以根据命令pattern打断点
### proc 内支持多个断点
### until 正好是无效行(注释，空行等)时改为最近的有效行
### 添加 watch 功能
### 显示源代码时高亮指定 pattern
### next 支持跳过多少行

namespace eval tdb {

# 不显示颜色；单个高亮颜色；双高亮配色
variable _NO_COLOR "\033\[0m"
variable _HL_COLOR "\033\[32m"
variable _PAIR_COLOR {\033\[35m \033\[36m}
proc no_color {} { variable _NO_COLOR; return $_NO_COLOR }
proc hl_color {{is_hl true}} {
    variable _HL_COLOR
    if {$is_hl} {
        return $_HL_COLOR
    }
    return [no_color]
}
proc format_color {color msg} { return "$color$msg[no_color]" }
proc puts_color {msg {is_hl true}} { puts [format_color [hl_color $is_hl] $msg] }
proc puts_color2 {key value {c0 ""} {c1 ""} {key_width 10}} {
    variable _PAIR_COLOR
    set key [format " %*s" $key_width $key]
    if {$c0 == ""} {
        set c0 [lindex $_PAIR_COLOR 0]
    }
    if {$c1 == ""} {
        set c1 [lindex $_PAIR_COLOR 1]
    }
    puts "    $c0$key[no_color]: $c1$value[no_color]"
}


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
    variable breakpoints [dict create]
    variable tmp_breakpoints [dict create]

    # 正在调试的 proc
    variable debugging_proc_list ""

    # 行调试开关
    set next_line false
    # 行调试是否进入子函数开关
    set enter_sub_proc false

    # 运行到指定行调试
    set until_line_num 0

    proc get_debugging_proc {} {
        variable debugging_proc_list
        return [lindex $debugging_proc_list end]
    }
    proc get_debugging_proc_list {} {
        variable debugging_proc_list
        return $debugging_proc_list
    }
    proc add_debugging_proc {name} {
        variable debugging_proc_list
        variable breakpoints
        variable tmp_breakpoints
        lappend debugging_proc_list $name
        if {![dict exists $breakpoints $name]} {
            dict set tmp_breakpoints $name [dict create "namespace" "" "line" 0 "triggered" false]
        }
    }
    proc remove_debugging_proc {name} {
        variable debugging_proc_list
        variable tmp_breakpoints
        if {[lindex $debugging_proc_list end] == $name} {
            set debugging_proc_list [lrange $debugging_proc_list 0 end-1]
            dict unset tmp_breakpoints $name
        }
    }
    proc remove_tail_debugging_proc {} {
        variable debugging_proc_list
        remove_debugging_proc [lindex $debugging_proc_list end]
    }
    proc remove_sub_debugging_proc {parent_name} {
        variable debugging_proc_list
        set parent_index [lsearch $debugging_proc_list $parent_name]
        if {$parent_index < 0} {
            return
        }
        set end_index [expr [llength $debugging_proc_list] - 1]
        for {set i $end_index} {$i > $parent_index} {incr i -1} {
            remove_debugging_proc [lindex $debugging_proc_list $i]
        }
    }

    proc _add_breakpoint {name_space proc_name line} {
        variable breakpoints
        if {[dict exists $breakpoints $proc_name]} {
            puts "Duplicated breakpoint for ${name_space}::$proc_name"
            exit
        }
        set full_name "$name_space$proc_name"
        dict set breakpoints $proc_name [dict create "namespace" $name_space "line" $line "triggered" false]
        trace add execution $full_name enter tdb::_proc_b_enter_wrapper
        trace add execution $full_name leave tdb::_proc_b_leave_wrapper
        trace add execution $full_name enterstep tdb::_proc_b_enter_step_wrapper
        trace add execution $full_name leavestep tdb::_proc_b_leave_step_wrapper
    }
    proc _set_break_info {key value} {
        variable breakpoints
        set debugging_proc [get_debugging_proc]
        if {[dict exists $breakpoints $debugging_proc]} {
            set b_info [dict get $breakpoints $debugging_proc]
            dict set b_info $key $value
            dict set breakpoints $debugging_proc $b_info
        }
    }
    proc _get_break_info {key} {
        variable breakpoints
        variable tmp_breakpoints
        set debugging_proc [get_debugging_proc]
        if {[dict exists $breakpoints $debugging_proc]} {
            set debug_info [dict get $breakpoints $debugging_proc]
        } elseif {[dict exists $tmp_breakpoints $debugging_proc]} {
            set debug_info [dict get $tmp_breakpoints $debugging_proc]
        } else {
            return ""
        }
        return [dict get $debug_info $key]
    }
}

# 突出显示
proc highlight_frame {frame} {
    set frame_type [dict get $frame type]
    switch -exact [dict get $frame type] {
        source  { set entity [dict get $frame file] }
        proc    { set entity [dict get $frame proc] }
        eval    { set entity [dict get $frame cmd] }
        default { set entity $frame }
    }
    puts_color2 $frame_type $entity
}


# 显示当前堆栈代码
proc _show_line {ini_frame cur_frame {size 10}} {
    set frame [info frame $cur_frame]

    set proc_bt ""
    set frame_step [expr $ini_frame - $cur_frame]
    set proc_list [glv::get_debugging_proc_list]
    set pl_size [llength $proc_list]
    for {set i 0} {$i < $pl_size} {incr i} {
        # 高亮当前堆栈
        set color [hl_color [expr $pl_size - $i - $frame_step == 1]]
        set proc_name [lindex $proc_list $i]
        set proc_bt "$proc_bt[format_color $color $proc_name] > "
    }

    puts [string repeat "*" 50]
    puts_color2 "step" $proc_bt
    highlight_frame $frame
    puts [string repeat "*" 50]

    switch -exact [dict get $frame "type"] {
        source  { set lines [_get_file_lines [dict get $frame file]] }
        proc    { set lines [_get_proc_lines [dict get $frame proc]] }
        eval    { 
            _show_line $ini_frame [expr $cur_frame - 1]
            return
        }
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
            puts_color $print_line
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
proc _get_proc_lines {proc_name {start -1} {end "end"}} {
    if {![dict exists $glv::proc_lines $proc_name]} {
        set proc_body [info body $proc_name]
        set lines [split $proc_body "\n"]
        lset lines 0 "proc $proc_name \{[info args $proc_name]\}"
        dict set glv::proc_lines $proc_name $lines
    }
    set ret_lines [dict get $glv::proc_lines $proc_name]
    if {$start < 0} {
        return $ret_lines
    } else {
        return [lrange $ret_lines $start $end]
    }
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
    _show_line $ini_frame $cur_frame

    while {1} {
        puts -nonewline "tdb > "
        flush stdout
        gets stdin user_input
        set cur_level [expr $ini_frame - $cur_frame + 2]
        switch -regexp $user_input {
            ^q$ -
            ^exit$ { exit }

            ^c$ {
                # 下一个断点
                set glv::next_line false
                break
            }

            ^n$ -
            ^next$ {
                # 下一行(不进入子函数)
                set glv::next_line true
                break
            }

            ^s$ -
            ^step$ {
                # 下一行(进入子函数)
                set glv::next_line true
                set glv::enter_sub_proc true
                break
            }

            {^t\s*\d+$} -
            {^until?\s*\d+$} {
                # 运行到指定行
                set glv::next_line false
                regexp {\d+} $user_input line_num
                set glv::until_line_num $line_num
                break
            }

            ^f$ -
            ^finish$ {
                # 一直运行到当前 proc 返回
                set glv::next_line true
                glv::remove_tail_debugging_proc
                break
            }

            ^bt$ -
            ^backtrace$ {
                # 显示所有堆栈
                for {set i 1} {$i <= $ini_frame} {incr i} {
                    # 高亮当前堆栈
                    puts_color "$i: [info frame $i]" [expr $i == $cur_frame]
                }
            }

            {^f\s*\d+$} {
                # 跳转到指定堆栈
                regexp {\d+} $user_input index
                if {$index < 1 || $index > $ini_frame} {
                    puts "Valid frame: \[1, $ini_frame\]"
                    continue
                }
                set cur_frame $index
                _show_line $ini_frame $cur_frame
            }
            
            ^u$ -
            ^up$ {
                # 跳转到上一级堆栈
                if {[expr $cur_frame - 1] > 0} {
                    incr cur_frame -1
                }
                _show_line $ini_frame $cur_frame
            }

            ^d$ -
            ^down$ {
                # 跳转到下一级堆栈
                if {[expr $cur_frame + 1] <= $ini_frame} {
                    incr cur_frame 1
                }
                _show_line $ini_frame $cur_frame
            }

            {^\.\s*\d*$} {
                # 显示源代码
                if {[regexp {\d+} $user_input size]} {
                    _show_line $ini_frame $cur_frame $size
                } else {
                    _show_line $ini_frame $cur_frame
                }
            }

            ^p$ -
            ^puts$ {
                # 打印所有局部变量
                catch {uplevel $cur_level "info locals"} local_var_names
                set name_width 0
                set local_var_names [lsort $local_var_names]
                foreach var_name $local_var_names {
                    if {[string length $var_name] > $name_width} {
                        set name_width [string length $var_name]
                    }
                }
                foreach var_name $local_var_names {
                    catch {uplevel $cur_level "set $var_name"} var_value
                    puts_color2 $var_name $var_value [hl_color] [no_color] $name_width
                }
            }

            {^pa\s+\$?\w+$} {
                # 打印 array
                regexp {^pa\s+\$?(\w+)$} $user_input match var
                try {
                    catch {uplevel $cur_level "array get $var"} pairs
                    set name_width 0
                    foreach {key value} $pairs {
                        if {[string length $key] > $name_width} {
                            set name_width [string length $key]
                        }
                    }
                    if {$name_width > 30} {
                        set name_width 30
                    }
                    foreach {key value} $pairs {
                        puts_color2 $key $value [hl_color] [no_color] $name_width
                    }
                } on error {code options} {
                    puts "$code"
                    # puts "options: $options"
                }
            }

            {^p\s+.+} -
            {^puts\s+.+} {
                # p 代替 puts
                regexp {^p(?:uts)?\s+(.+)$} $user_input match var
                try {
                    uplevel $cur_level "puts $var"
                } on error {code options} {
                    puts "$code"
                    # puts "options: $options"
                }
            }

            default {
                if {[llength $user_input] == 1} {
                    catch {uplevel $cur_level "info commands"} all_commands
                    if {[lsearch $all_commands $user_input] == -1} {
                        # 将输入作为变量打印其值
                        if {[regexp {^\$} $user_input]} {
                            uplevel $cur_level "puts $user_input"
                        } else {
                            catch {uplevel $cur_level "set $user_input"} value
                            puts $value
                        }
                        continue
                    }
                }
                # 将输入作为命令执行
                catch {uplevel $cur_level $user_input} result
                puts $result
            }
        }
    }
}


# 是否是通过 [] 等方式调用的内置函数
proc _is_builtin_command {frame} {
    switch -exact [dict get $frame "type"] {
        proc   {
            set line_num [dict get $frame "line"]
            incr line_num -1
            set full_line [_get_proc_lines [dict get $frame "proc"] $line_num $line_num]
            set full_line [string trim [string range $full_line 1 end-1]]
            set cmd_line [dict get $frame "cmd"]
            if {[string length $cmd_line] < [string length $full_line]} {
                return true
            }
        }
        source  { return false }
        eval    { return true  }
        default { return false }
    }
    return false
}

proc _proc_b_enter_wrapper {cmd args} {
    glv::add_debugging_proc [lindex [split $cmd] 0]
}
proc _proc_b_leave_wrapper {cmd args} {
    glv::_set_break_info "triggered" false
    glv::remove_debugging_proc [lindex [split $cmd] 0]
}
proc _proc_b_enter_step_wrapper {cmd args} {
    set frame [info frame [_get_current_frame]]

    if {[dict exists $frame proc]} {
        regexp {\w+$} [dict get $frame proc] match
        set cur_proc $match
    } else {
        set cur_proc ""
    }
    glv::remove_sub_debugging_proc $cur_proc

    if {[string equal $cur_proc [glv::get_debugging_proc]]} {
        # 跳过子函数
        if {[_is_builtin_command $frame]} {
            return
        }

        set tar_line [glv::_get_break_info "line"]
        set cur_line [dict get $frame "line"]
        # 断点函数内
        if {$tar_line == 0 && ![glv::_get_break_info "triggered"]} {
            # 断点未设置行号且刚进入函数
            glv::_set_break_info "triggered" true
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
        # 非断点函数内(自定义子proc)
        if {$glv::next_line} {
            # 行调试
            if {$glv::enter_sub_proc} {
                # 进入子函数
                set glv::enter_sub_proc false
                set glv::next_line false
                glv::add_debugging_proc $cur_proc
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
            glv::_add_breakpoint $name_space $proc_name $line
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
