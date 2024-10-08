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
        # set type [dict get $fi "type"]
        # set file [dict get $fi "file"]
        # set line [dict get $fi "line"]
        # set proc [dict get $fi "proc"]
        puts "Frame $i: $fi"
    }
}
