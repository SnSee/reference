
# Tcl

[安装](../../%E7%8E%AF%E5%A2%83/linux.md#tcl)

[官网](https://core.tcl-lang.org/index.html)

[wiki](https://wiki.tcl-lang.org/welcome)

## 命令

[disassemble](https://wiki.tcl-lang.org/page/disassemble)

调试disassemble

```text
gdb 命令
    break Tcl_DisassembleObjCmd
tcl 命令
    tcl::unsupported::disassemble script script
```

```tcl
puts $text: 输出变量
lsearch ?option? list pattern: 查找列表是否包含指定pattern的元素，如果包含返回第一个匹配元素的索引，否则返回-1
```

脚本搜索路径

```tcl
# 将当前目录添加到脚本搜索路径
lappend auto_path [file dirname [info script]]

# 添加自定义目录到脚本搜索路径
lappend auto_path "/path/to/custom/directory"
```

字符串

```tcl
# 字符串替换
string map {old new} string
```

列表(list)

```tcl
set my_list {}              # 创建空列表
set my_list {1 2 3}         # 创建列表
set my_list [list 1 2 3]    # 创建列表

lappend my_list 4           # 插入元素(修改当前list)
lappend $my_list 4          # 插入元素(不修改当前list)

if {$e in $my_list} {}                      # 判断元素是否存在
if {[lsearch $myList $element] != -1} {}    # 判断元素是否存在
if {!($e in $my_list)} {}                   # 判断元素不存在
if {[lsearch $myList $element] == -1} {}    # 判断元素不存在
```

字典映射(map)

```tcl
set myDict [dict create]            # 创建
dict set myDict key1 value1         # 添加元素
dict set myDict key2 value2

set value [dict get $myDict key1]   # 访问

if {[dict exists $myDict key1]} {
    puts "has key1"
}

dict for {key value} $myDict {      # 遍历
    puts "$key: $value"
}

set keys [dict keys $myDict]
set values [dict values $myDict]

dict unset myDict key1              # 删除元素
```

文件

```tcl
# 查看文件是否存在
set file_path "/path/to/*/file.txt"
if {[file exists $file_path]} {
    puts "The file exists"
} else {
    puts "The file does not exist"
}


# 使用glob命令查找所有匹配文件
set file_pattern "/path/to/*/file.txt"

# -nocomplain 表示没匹配到文件时不抛出异常而是返回空列表
set file_list [glob -nocomplain $file_pattern]

if {[llength $file_list] > 0} {
    puts "The file exists"
    foreach file $file_list {
        puts "get file $file"
    }
} else {
    puts "The file does not exist"
}
```

调用shell命令

```tcl
# shell命令不能用双引号包括，如: "ls -l"
exec ls -l
exec sh -c "ls -l"

# 获取标准输出及返回码
set cmd "ls"
# set cmd "invalid_cmd"
catch {exec $cmd} output code_info
set return_code [lindex $code_info 1]
puts "output     : $output"
puts "return info: $code_info"
puts "return code: $return_code"
```

引用环境变量

```tcl
$env(PATH)

# 设置环境变量
set env(PATH) "/test:$env(PATH)"

# 判断环境变量是否存在
if {[info exists ::env(PATH)]} {
    puts "has"
} else {
    puts "no"
}
```

花括号

```tcl
# 如果字符串中包含特殊字符，如空格等，需要使用花括号
set alpha {a b c d}
puts $alpha             # 输出：a b c d

# 花括号中的变量不会替换为变量值
set name Tom
puts $name              # 输出: Tom
puts {$name}            # 输出: $name

# 如果既要使用花括号又要使用变量
puts [subst {$name}]    # 输出：Tom
```

[lsearch options](https://blog.csdn.net/asty9000/article/details/89693505)

> 布尔运算

在Tcl中，布尔运算符用于比较两个表达式的值，以生成布尔结果（真或假）。

以下是一些常用的布尔运算符：

* ==或eq：检查两个表达式的值是否相等。
* !=或ne：检查两个表达式的值是否不相等。
* <或>或<=或>=：比较两个数字表达式的大小。字符串也可以进行比较，但结果可能不如预期。
* &&或and：逻辑与运算符，如果两个表达式都为真，则结果为真。
* ||或or：逻辑或运算符，如果至少有一个表达式为真，则结果为真。
* !或not：逻辑非运算符，将一个表达式的布尔值取反。
以下是一些示例，演示如何使用布尔运算符：

```tcl
set x 5
set y 10
if {$x == $y} {
    puts "x equals y"
}

if {$x < $y} {
    puts "x is less than y"
}

set name "john"
if {$name eq "john" && $age > 18} {
    puts "John is an adult"
}

set isAdmin 0
if {!$isAdmin} {
    puts "You are not an admin"
}
需要注意的是，在Tcl中，由于其动态类型系统，某些情况下会发生类型转换。例如，在使用<或>比较字符串时，Tcl会将字符串转换为数字进行比较。因此，对于字符串比较，应该使用eq和ne比较运算符。
```

> if语法

```tcl
if {条件} {
    # 条件成立时执行的代码块
} elseif {条件2} {
    # 条件2成立时执行的代码块
} else {
    # 所有条件都不成立时执行的代码块
}
```

> 取反

在Tcl中，可以使用!或not关键字对if语句进行取反。具体方法如下：

```tcl
if {!$condition} { }
if {not $condition} { }
```

需要注意的是，!和not都只适用于逻辑运算符，例如&&(与)和||(或)。
如果要对其他类型的表达式进行取反，可以使用!=或ne比较运算符进行判断，例如：

```tcl
if {$x != 1} { }
if {![string equal $name "john"]} { }
```

> for语法

```tcl
for {初始化} {条件} {自增/自减} {
    # 循环体代码块
}

set my_list {1 2 3 4 5 6 7 8 9 10}
for {set i 0} {$i < [llength $my_list]} {incr i 2} {
    set e1 [lindex $my_list $i]
    set e2 [lindex $my_list [expr {$i + 1}]]
    puts "$e1, $e2"
}
```

> while语法

```tcl
while {条件} {
    # 循环体代码块
}
```

> foreach语法

```tcl
foreach 变量 集合 {
    # 循环体代码块
}

# 示例
set myList {apple banana cherry}
foreach item $myList {
    puts $item
}
```

> 数学运算

```tcl
# 自增/自加
set cnt 0
incr cnt
puts $cnt
# 自减
incr cnt -1

# 浮点数比较
proc is_close {num1 num2} {
    set epsilon 1e-6
    set diff [expr {abs($num1 - $num2)}]
    if { $diff < $epsilon } {
        return 1
    } else {
        return 0
    }
}
```

> try语法

```tcl
try {
    return [expr 1/$num]
} on error {code options} {
    puts $code
    puts $options
} on return {res options} {
    puts $res
    puts $options
} finally {
    puts "finally"
}

catch {<command>} output error_info
puts "output     : $output"
puts "return info: $code_info"
puts "return code: $return_code"
```

> string命令

string equal命令：检查两个字符串是否完全相等。

```tcl
if {[string equal $str1 $str2]} {
    puts "The two strings are the same."
}
```

string compare命令：比较两个字符串并返回其字符顺序的差异。

```tcl
if {[string compare $str1 $str2] > 0} {
    puts "$str1 comes after $str2 in the dictionary."
}
```

string match命令：使用通配符模式匹配来测试一个字符串是否与另一个字符串匹配。

```tcl
if {[string match "*hello*" $str]} {
    puts "The string contains the word 'hello'."
}
```

string first命令：在一个字符串中查找另一个字符串，并返回第一次出现的位置。

```tcl
set pos [string first "world" $str]
if {$pos >= 0} {
    puts "The string 'world' is found at position $pos."
}
```

判断字符串是否为空字符串

```tcl
set s ''
if {[string length $s] == 0} {}
```

需要注意的是，在使用string compare命令时，如果返回值为0，则表示两个字符串相同；如果返回值小于0，则表示第一个字符串在字典中排在第二个字符串之前；如果返回值大于0，则表示第一个字符串在字典中排在第二个字符串之后。

此外，还可以使用其他命令，如string length（获取字符串长度）、string tolower（将字符串转换为小写）和string toupper（将字符串转换为大写）等。这些命令可以帮助您处理字符串并执行各种操作。

> proc

```tcl
proc my_proc {arg1 arg2} {
  # 在此处进行需要执行的操作，这里我们简单地将两个参数相加
  set sum [expr {$arg1 + $arg2}]
  # 使用 return 命令返回计算结果
  return $sum
}

set result [my_proc 3 4]
```

```tcl
proc my_proc {arg1 arg2} {
  # 使用 global 命令声明变量为全局变量
  # 只能引用全局变量，不能定义
  global my_global_var
  
  # 在此处进行需要执行的操作，这里我们简单地将两个参数相加并存储到全局变量中
  set my_global_var [expr {$arg1 + $arg2}]
}

proc my_proc {arg1 arg2} {
  # 在此处进行需要执行的操作，这里我们简单地将两个参数相加并存储到全局变量中
  # 只能引用全局变量，不能定义
  set ::my_global_var [expr {$arg1 + $arg2}]
}
```

> 读取文件(写入文件)/读写

```tcl
# 读取文件
set fp [open "example.txt" r]
set content [read $fp]
close $fp
puts $content

# 写入文件
set file [open "file.txt" "w"]
puts $file "Hello, World!"
close $file
```

> 正则表达式

```tcl
set test_pat {^([a-z]+)(\d+)_(\d+)(\w+)$}
set test_str "abc123_456def"
if {[regexp $test_pat $test_str match word1 num1 num2 word2]} {
    puts $word1
    puts $word2
    puts $num1
    puts $num2
}
```

> 排序

```tcl
# 按字母的ASCII码 升序排序
set list {b c a}
puts [lsort -ascii $list]       # 输出：a b c

# 按整数值 降序排序
set list {3 1 2}
puts [lsort -integer -decreasing $list]     # 输出：3 2 1

# 自定义排序函数
proc compareByLength {a b} {
    if {[string length $a] < [string length $b]} {
        return -1
    } elseif {[string length $a] > [string length $b]} {
        return 1
    } else {
        return 0
    }
}

set list {abc aa b}
puts [lsort -command compareByLength $list]     # 输出：b aa abc
```
