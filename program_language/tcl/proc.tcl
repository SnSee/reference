## 自定义函数

# 保留小数位数，类似python round
# num    : 要处理的浮点数
# ndigits: 保留几位小数
# return : 处理后的整数/浮点数
proc round {num {ndigits 0}} {
    set level [expr 10 ** $ndigits]
    return [expr double(round($num * $level)) / $level]
}


# 打印堆栈信息
proc print_frame {} {
    # set level [info level]
    set max_level [info frame]          # 当前 proc 的 level
    for {set i 0} {$i < $max_level} {incr i} {
        set fi [info frame $i]
        # set file [lindex $fi 5]
        # set line [lindex $fi 3]
        # set proc [lindex $fi 7]
        puts "Frame $i: $fi"
    }
}

# 设置断点，可输入 tcl 命令，q/exit 退出
proc breakpoint {msg} {
    puts "breakpoint: $msg"
    while {1} {
        puts -nonewline "tdb > "
        flush stdout
        gets stdin user_input
        if {$user_input eq "q" || $user_input eq "exit"} {
            break
        }
        catch {uplevel 1 $user_input} result
        puts -nonewline $result
    }
}
