
# Tcl

[安装](../../%E7%8E%AF%E5%A2%83/linux.md#tcl)

[官网](https://core.tcl-lang.org/index.html)

[w3school 文档](https://www.w3cschool.cn/doc_tcl_tk/)

[wiki](https://wiki.tcl-lang.org/welcome)

[ZetCode教程](https://static.kancloud.cn/apachecn/zetcode-zh/1950620)

* tcl 中所有数据结构的本质都是字符串，具体是什么数据类型取决于如何解析

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

### 脚本搜索路径

```tcl
# 将当前目录添加到自动搜索路径(只适用于 load 和 package require)
lappend auto_path [file dirname [file normalize [info script]]]

# 添加自定义目录到脚本搜索路径
lappend auto_path "/path/to/custom/directory"
```

### 命令行参数

```tcl
# tclsh tmp.tcl 1 2
set argc [llength $argv]
set v1 [lindex $argv 0]     # 第一个参数
set v2 [lindex $argv 1]
set v3 [lindex $argv 2]     # 超出列表长度时值为空
```

### namespace

命令空间

```tcl
set v_global "global var"

# 在命令空间内执行
namespace eval my_name {
    # namespace 中注释必须单独一行，不能行后注释
    # 命令空间内通过 set 定义的变量无法在 proc 中引用
    # 使用 variable 定义 namespace 变量
    set abc 123
    puts $abc
    proc func_not_export {} {
        puts "func NOT export in my_name"

        # 可以引用在 namespace 外定义的全局变量
        global v_global
        puts "v_global: $v_global"

        global abc      # 无效
        #puts $abc       # 报错：未定义
        upvar ::my_name::abc abc    # 引用 namespace 中定义变量
    }

    proc func_export {} {
        puts "func export in my_name"
    }
    # export 后的命令可被 import
    namespace export func_export
}

# 调用命令空间内函数
# 方式一
puts "------- 1 ---------"
::my_name::func_not_export
::my_name::func_export
puts ""

# 方式二
puts "------- 2 ---------"
namespace eval my_name {
    func_not_export
    func_export
}
puts ""

# 方式三
puts "------- 3 ---------"
namespace import my_name::func_not_export
namespace import my_name::func_export
# func_not_export       # 报错: 未定义
func_export
puts ""

# 方式四
puts "------- 4 ---------"
namespace path ::my_name
func_not_export
func_export
puts ""

# 在其他 namespace 中调用
namespace eval my_name2 {
    puts "******* my_name2 *******"
    namespace path ::my_name
    func_export
    func_not_export
}
```

### 变量

#### 类型及类型转换

```tcl
true, false     # 布尔值，bool
1               # 整型
1.23            # 浮点型
"123"           # 字符串
```

```tcl
# int -> float
set d [expr double(1)]

# float -> int
set i [expr int(1.2)]
```

#### variable

创建只在命名空间内通用的变量

```tcl
namespace eval namespace1 {
    variable v_namespace 123
    puts "init v_namespace: $v_namespace"
    proc np1_func1 {} {
        variable v_namespace
        # output: 123
        puts "np1_func1 v_namespace: $v_namespace"
        set v_namespace 456
    }
    proc np1_func2 {} {
        variable v_namespace
        # output: 456
        puts "np1_func2 v_namespace: $v_namespace"
    }

    np1_func1
    np1_func2
}

puts "out of namespace: $v_namespace"       # 报错：未定义
```

### 容器

#### 列表(list)

```tcl
set my_list {}              # 创建空列表
set my_list {1 2 3}         # 创建列表
set my_list [list 1 2 3]    # 创建列表

llength $my_list                            # 长度
lindex $my_list 1                           # 访问列表，通过索引获取元素
lset my_list 1 5                            # 修改元素值 my_list[1] = 5
lappend my_list 4                           # 追加元素(修改当前list)
lappend $my_list 4                          # 追加元素(不修改当前list)
set my_list [linsert $my_list 1 5]          # 插入元素，可插入多个值

if {$e in $my_list} {}                      # 判断元素是否存在
if {[lsearch $myList $element] != -1} {}    # 判断元素是否存在
if {!($e in $my_list)} {}                   # 判断元素不存在
if {[lsearch $myList $element] == -1} {}    # 判断元素不存在

# 合并/拼接列表
set new_list [concat $my_list $my_list]

# 切片
set slice [lrange $my_list 2 5]             # 包括 5
set slice [lrange $my_list 2 end]           # 包括最后一位
```

排序

```tcl
# 使用 lsort 命令，原列表不变
set my_list {1 3 8 2 4 10 8.8}
set sorted_list [lsort $my_list]                # 按ascii顺序
set sorted_list [lsort -integer $my_list]       # 按整数大小(不支持列表中有非整数)
set sorted_list [lsort -real $my_list]          # 按实数大小
set sorted_list [lsort -decreasing $my_list]    # 降序

# 返回true表示交换位置
# 按数值升序排序
proc cmp {v1 v2} {
    return [expr $v1 > $v2]
}
set sorted_list [lsort -command cmp $my_list]   # 自定义排序函数
```

#### 字典映射(map)

```tcl
set myDict [dict create]            # 创建
set myDict [dict create k v]        # 创建并初始化
dict set myDict key1 value1         # 添加元素
dict set myDict key2 value2

set value [dict get $myDict key1]   # 访问

if {[dict exists $myDict key1]} {   # 存在性检查
    puts "has key1"
}

dict for {key value} $myDict {      # 遍历
    puts "$key: $value"
}

set keys [dict keys $myDict]
set values [dict values $myDict]

dict unset myDict key1              # 删除元素
```

#### array

|子命令 |功能
|- |-
|set    | 创建
|get    | 获取键值对
|names  | 获取所有keys

```tcl
# 创建
array set myArray {
    key1 value1
    key2 value2
    key3 value3
}

# 修改
set myArray(key1) NEW_VALUE
# 添加
set myArray(key4) value4

# 遍历
# 方式一
foreach {key value} [array get myArray] {
    puts "Key: $key, Value: $value"
}

# 方式二
foreach key [array names myArray] {
    set value $myArray($key)
    puts "Key: $key, Value: $value"
}
```

### 时间

#### clock

```tcl
# 1970秒数
clock seconds
# 默认格式
clock format [clock seconds]    # Wed Jul 10 09:28:33 CST 2024
# 指定格式
clock format [clock seconds] -format "%Y/%m/%d %H:%M:%S"
```

### 文件

#### 路径

##### pwd 当前路径

```tcl
pwd
```

##### file

```tcl
# 查看文件是否存在
set file_path "/path/to/*/file.txt"
puts [file exists $file_path]
# 创建目录
file mkdir "dir_name"
# 删除文件
file delete test.txt
```

```tcl
set tf "/tmp/test.txt"
set dirname     [file dirname $tf]              # /tmp
set basename    [file tail $tf]                 # test.txt
set extension   [file extension "/tmp/a.b.txt"] # txt
set rootname    [file rootname "/tmp/a.b.txt"]  # /tmp/a.b

# 拼接路径
set file_path   [file join "/tmp" "a" "b"]  # /tmp/a.b
```

#### glob 搜索

```tcl
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

#### 读取文件(写入文件)/读写

```tcl
# 读取文件
set fp [open "example.txt" r]
# 全部读取
set content [read $fp]
# 按行读取
while {[gets $fp line] != -1} {
    puts $line
}

close $fp
puts $content

# 写入文件
set file [open "file.txt" "w"]
puts $file "Hello, World!"
close $file
```

### 花括号

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

### 布尔运算(bool)

表示真假

```tcl
set true 1
set false 0
```

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

#### 取反

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

### 控制语句

#### source

执行指定文件中的命令

```tcl
source test.tcl
```

#### exit

在任意位置退出程序

```tcl
exit
```

#### 调用shell命令

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

#### if

```tcl
if {条件} {
    # 条件成立时执行的代码块
} elseif {条件2} {
    # 条件2成立时执行的代码块
} else {
    # 所有条件都不成立时执行的代码块
}
```

#### for

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

#### while

```tcl
while {条件} {
    # 循环体代码块
}
```

#### foreach

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

#### switch

|option |desc
|- |-
|-exact     |相等才匹配(默认方式)
|-glob      |支持通配符
|-regexp    |支持正则表达式
|-nocase    |忽略大小写

```tcl
set str "abc"
switch $str {
    # - 相当于 c 中不 break
    abc -
    def {
        puts "is"
        puts "abc or def"
    }
    default { puts "is default" }
}
```

### 数学运算

[expr 算数运算符及内置函数](https://www.cnblogs.com/Icer-newer/p/17056032.html)

```tcl
# 自增/自加
set cnt 0
incr cnt
puts $cnt
# 自减
incr cnt -1

# 数值比较
# 支持符号: <  <=  >  >=  ==  !=
expr 1 < 2      # 1
expr 1 > 2      # 0
# if 条件中可以直接比较
if {1 < 2} {puts "True"}

# 浮点数比较
proc is_close {num1 num2} {
    set epsilon 1e-6
    set diff [expr {abs($num1 - $num2)}]
    return [expr $diff < $epsilon]
}
```

幂运算/指数运算

```tcl
expr 3 ** 3
```

求最大值,求最小值

```tcl
expr max(1, 2, 3, 4.2, 5)       # 5
expr min(1, 2, 3, 4.2, 5)       # 1
```

### try语法

```tcl
# 抛出异常
error "error message"

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

### puts

```tcl
puts -nonewline "test"          # 不换行输出
```

### format 格式化字符串

```tcl
format "%.2f" 1.34567           # 1.35

format "---%*s---" $width $out_str      # 设置字符串宽度，默认右对齐
format "---%-*s---" $width $out_str     # 设置为左对齐
# 同时设置多个字符串
format "---%*s---%*s---" $width1 $out_str1 $width2 $out_str2
```

### string命令

```tcl
string trim $test               # 移除首尾空白字符
string trim $test :             # 移除首尾指定字符
string trimleft $test           # 移除行首空白字符
string trimright $test          # 移除行尾空白字符
string length $test             # 长度

string repeat 'X' $size         # 重复字符
```

#### split 拆分字符串

```tcl
# 语法
# splitChars 中所有字符都会当作分隔符，默认为空格
split string ?splitChars?
```

```tcl
set var "1-2-3-4"
foreach sp [split $var '-'] {
    puts $sp
}
```

#### map 字符串替换

```tcl
string map {old new} string
```

#### range 字符串截取

```tcl
string range "012345" 1 4    # 包括 4
```

#### index 单个字符

```tcl
# 负数表示从后往前
string index "012345" -1
```

#### equal 字符串比较

```tcl
if {[string equal $str1 $str2]} {
    puts "The two strings are the same."
}
if {![string equal $str1 $str2]} {
    puts "The two strings are different."
}
```

#### compare

比较两个字符串并返回其字符顺序的差异

```tcl
if {[string compare $str1 $str2] > 0} {
    puts "$str1 comes after $str2 in the dictionary."
}
```

#### match

使用 **通配符** 模式匹配来测试一个字符串是否与另一个字符串匹配

```tcl
if {[string match "*hello*" $str]} {
    puts "The string contains the word 'hello'."
}
```

#### first

在一个字符串中查找另一个字符串，并返回第一次出现的位置。
可以用来判断字符串中是否包含某个子串

```tcl
set pos [string first "world" $str]
if {$pos >= 0} {
    puts "The string 'world' is found at position $pos."
}
```

#### 判断字符串是否为空字符串

```tcl
set s ''
if {[string length $s] == 0} {}
```

需要注意的是，在使用string compare命令时，如果返回值为0，则表示两个字符串相同；如果返回值小于0，则表示第一个字符串在字典中排在第二个字符串之前；如果返回值大于0，则表示第一个字符串在字典中排在第二个字符串之后。

此外，还可以使用其他命令，如string length（获取字符串长度）、string tolower（将字符串转换为小写）和string toupper（将字符串转换为大写）等。这些命令可以帮助您处理字符串并执行各种操作。

### upvar

在当前作用域引用其他作用域内的变量，并且可以修改，类似于c++引用传递

```tcl
upvar ?level? ref_var cur_var

level   : #0 指全局变量作用域，#1 指上一级作用域，以此类推，默认：1
ref_var : level 作用域内的变量名
cur_var : 当前作用域变量名
```

```tcl
proc level2 {var} {
    upvar #1 v_level1 ref_level1
    upvar #0 v_global ref_global
    set ref_level1 11
    set ref_global 99
}

proc level1 {var} {
    set v_level1 1
    puts "level1 BE: $v_level1 == 1"
    level2 $v_level1
    puts "level1 AF: $v_level1 == 11"
}

set v_global 9
puts "global BE: $v_global == 9"
level1 $v_global
puts "global AF: $v_global == 99"
```

### proc 定义函数

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

默认参数/可选参数

```tcl
proc func {x {y 10}} {
   puts "x = $x, y = $y"
}
func 5          # x = 5, y = 10
func 5 20       # x = 5, y = 20
```

### 正则表达式

等同于 python re.search

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

### 排序

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

## 模拟对象

### 模拟成员变量

```tcl
namespace eval MyClass {
    variable instances [dict create]
    proc new {inst_name} {
        variable instances
        dict set instances $inst_name [dict create name "" age -1]
    }
    proc set {inst_name key value} {
        variable instances
        ::set inst_dict [dict get $instances $inst_name]
        dict set inst_dict $key $value
        dict set instances $inst_name $inst_dict
    }
    proc get {inst_name key} {
        variable instances
        return [dict get [dict get $instances $inst_name] $key]
    }
    proc show {inst_name} {
        puts "name: [get $inst_name name]"
        puts "age : [get $inst_name age]"
    }
}

::MyClass::new pet1
::MyClass::set pet1 name Tom
::MyClass::set pet1 age 18
::MyClass::new pet2
::MyClass::set pet2 name Jerry
::MyClass::set pet2 age 16

::MyClass::show pet1
::MyClass::show pet2
```

### 模拟静态变量

```tcl
namespace eval MyClass {
    variable total_size 0
    proc add_size {size} {
        variable total_size
        incr total_size $size
    }
    proc get_size {} {
        variable total_size
        return $total_size
    }
}

puts "size: [MyClass::get_size]"
MyClass::add_size 1
MyClass::add_size 2
puts "size: [MyClass::get_size]"
```

### 模拟成员变量2

所有类的对象保存在一起
不支持对象嵌套，即类成员变量不能是类

```tcl
# 存储所有对象
set __instances__ [dict create]
proc new {class_name inst_name} {
    global __instances__
    if {![namespace exists $class_name]} {
        puts "No class: $class_name"
        exit
    }
    dict set __instances__ $inst_name [dict create __CLASS__ $class_name __ATTR__ [dict create]]
}

proc _get_object_info {inst_name} {
    global __instances__
    if {![dict exists $__instances__ $inst_name]} {
        puts "No instance: $inst_name"
        exit
    }
    return [dict get $__instances__ $inst_name]
}
proc _check_attr_existence {obj_info attr_name} {
    set class_name [dict get $obj_info __CLASS__]
    if {![info exists ::${class_name}::$attr_name]} {
        puts "class $class_name has no attribute: $attr_name"
        exit
    }
}
# path: 形如 instance_name.attribute
proc set_attr {path value} {
    global __instances__
    regexp {(\w+)\.(\w+)} $path match inst_name attr_name
    set obj_info [_get_object_info $inst_name]
    _check_attr_existence $obj_info $attr_name
    set attr_dict [dict get $obj_info __ATTR__]
    dict set attr_dict $attr_name $value
    dict set obj_info __ATTR__ $attr_dict
    dict set __instances__ $inst_name $obj_info
}
proc get_attr {path} {
    regexp {(\w+)\.(\w+)} $path match inst_name attr_name
    set obj_info [_get_object_info $inst_name]
    _check_attr_existence $obj_info $attr_name
    set attr_dict [dict get $obj_info __ATTR__]
    if {[dict exists $attr_dict $attr_name]} {
        return [dict get $attr_dict $attr_name]
    }
    set class_name [dict get $obj_info __CLASS__]
    return [set ::${class_name}::$attr_name]
}


# 声明 class 及成员
namespace eval MyClass {
    set name "UNSET"
    set age "UNSET"
}
new MyClass pet1
set_attr pet1.name Tom
set_attr pet1.age 20
new MyClass pet2
set_attr pet2.name Jerry
set_attr pet2.age 18

puts "name: [get_attr pet1.name]"
puts "age : [get_attr pet1.age]"
puts "name: [get_attr pet2.name]"
puts "age : [get_attr pet2.age]"
```

## packages

### TCLLIBPATH

设置 tcl package 搜索路径

```sh
export TCLLIBPATH="/path/to/your/packages"
```

```tcl
lappend auto_path "/path/to/your/packages"
```

### json

导出 json 字符串

```tcl
package require json

set dic [dict create]
dict set dic name "Tom"
dict set dic age 18
set json_str [json::dict2json $dic]
puts $json_str
```

解析 json 字符串

```tcl
package require json

# 第一个花括号是 tcl 中纯字符串标识
# 第二个花括号才是json的花括号
set json_str {{"name": "Tom", "age": 18}}
set dic [json::json2dict $json_str]
foreach key [dict keys $dic] val [dict values $dic] {
    puts "$key: $val"
}
```

## 调试

[参考 breakpoint](./proc.tcl)

### info

#### locals

```tcl
# 查看局部变量
info locals
```

#### frame

[打印堆栈信息: print_frame](./proc.tcl)

假设一共有 n 级堆栈

|frame index |desc
|- |-
|0   |当前命令，即 n 级
|1   |最顶层命令
|2   |第二顶层命令
|... |中间命令
|n-1 |上一级命令
|n   |当前命令

### uplevel

```tcl
# 在上 n 级执行命令，n 默认为 1
uplevel n {command}
```

### trace

#### 追踪变量读写

```tcl
trace add variable <name> <option> <callback>

<name>     : 变量名
<option>   : 见表格
<callback> : 回调函数，有三个参数：
             name1: 变量名
             name2: 普通变量为空字符串，array为索引
             option: 参数中的 option

# 取消追踪
trace remove <type> <name> [trace_type] <callback>
```

|option |desc
|- |-
|array |通过 array 访问/修改变量时调用
|read  |读时调用
|write |写时调用
|unset |移除变量时调用

示例

```tcl
# 普通变量
proc scalar_cb {name index opt} {
    puts "cb: $opt $name $index"
}
set var_name 1
trace add variable var_name {read write unset} scalar_cb
puts "read var_name: $var_name"
set var_name 2
unset var_name

# 数组
proc array_cb {name index opt} {
    puts "array cb: $opt $name\[$index]"
}
array set my_arr {k1 v1 k2 v2}
trace add variable my_arr {array read write} array_cb
puts "read arr: $my_arr(k1)"
set my_arr(k1) v11
set my_arr(k3) v3
```

#### 追踪函数调用

```tcl
trace add execution <cmd> <option> <callback>

<cmd>: 要追踪的命令
<option>: 见表格
<callback>: 回调函数，有两个参数：
            cmd: 完整的 command 命令，如果有参数包括参数
            option: 参数中的 option
```

|option |desc
|- |-
|enter     |刚进入 cmd 时调用 callback
|leave     |即将退出时调用
|enterstep |cmd 内执行每条子命令前调用，如果子命令是自定义 proc 则会进入
|leavestep |cmd 内执行每条子命令后调用

示例

```tcl
proc enter_callback {cmd opt} {
    puts "$opt $cmd"
}
# leave的参数必须叫 args，否则报错，原因未知
proc leave_callback {cmd args} {
    puts "$args $cmd"
}

proc my_cmd {index} {
    puts "in my_cmd: $index"
}

trace add execution my_cmd enter enter_callback
trace add execution my_cmd leave leave_callback
my_cmd 1
```

#### trace 搭配 breakpoint 命令

```tcl
```

## 发行版

### tclpro

调试需要 license

[下载](https://sourceforge.net/projects/tclpro/files/TclPro-1.4.1/1.4.1)

### ActiveState

不能调试

[下载](https://www.activestate.com/products/tcl)
