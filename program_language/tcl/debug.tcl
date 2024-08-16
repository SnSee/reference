# 所有文件内容
set file_lines [dict create]

# 显示当前堆栈代码
proc _show_line {cur_frame} {
    # 去掉当前栈，所以需要 - 1
    set frame [info frame [expr $cur_frame - 1]]
    set type [dict get $frame "type"]
    set file [dict get $frame "file"]
    set line_num [dict get $frame "line"]
    set proc [dict get $frame "proc"]

    global file_lines
    if {![dict exists $file_lines $file]} {
        set fp [open $file r]
        set lines {}
        while {[gets $fp line] != -1} {
            lappend lines $line
        }
        close $fp
        dict set file_lines $file $lines
    }

    set lines [dict get $file_lines $file]
    set start [expr max(0, $line_num - 3)]
    set end [expr min([llength $lines], $line_num + 3)]
    for {set i $start} {$i < $end} {incr i} {
        set mark " "
        if {$i == $line_num} {
            set mark ">"
        }
        puts "$mark [lindex $lines $i]"
    }
}

# 设置断点，可输入 tcl 命令，q/exit 退出
proc breakpoint {{msg "none"}} {
    puts "breakpoint: $msg"
    set max_frame [info frame]
    set cur_frame [expr $max_frame - 1]
    while {1} {
        puts -nonewline "tdb > "
        flush stdout
        gets stdin user_input
        switch -regexp $user_input {
            # 退出
            ^q$ -
            ^exit$ { break }

            # 显示所有堆栈
            ^bt$ -
            ^backtrace$ {
                for {set i 1} {$i <= $cur_frame} {incr i} {
                    puts "$i: [info frame $i]"
                }
            }

            # 跳转到指定堆栈
            {^f \d+$} {
                regexp {f (\d+)} $user_input match index
                set cur_frame $index
                _show_line $cur_frame
            }

            # 显示源代码
            ^\.$ { _show_line $cur_frame }

            default {
                set level [expr $max_frame - $cur_frame]
                catch {uplevel $level $user_input} result
                puts $result
            }
        }
    }
}
