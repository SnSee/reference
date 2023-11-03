## 自定义函数

# 保留小数位数，类似python round
# num    : 要处理的浮点数
# ndigits: 保留几位小数
# return : 处理后的整数/浮点数
proc round {num {ndigits 0}} {
    set level [expr 10 ** $ndigits]
    return [expr double(round($num * $level)) / $level]
}