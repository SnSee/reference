
# gdb

[官方文档](https://www.gnu.org/software/gdb/documentation)

[安装gdb](../../%E7%8E%AF%E5%A2%83/cpp.md#gdb)

[gdb源码](https://ftp.gnu.org/gnu/gdb)

```sh
# 查看命令帮助
help command_name
```

## 基本流程

```gdb
1.编译时添加编译选项: -g
2.使用gdb打开可执行程序: gdb test
3.设置命令行参数： set args arg1 arg2
4.设置断点： break test.cpp:21
5.开始调试： run, continue, step/next
6.查看函数栈信息： backtrace/where, print, info
7.退出： quit
```

## 命令行参数

```yml
-help/-h        : help
-args           : 被调试程序命令行参数
-cd             : 运行目录
-command/-x     : 命令文件，启动后执行
-ex             : 单条命令，可多次
-core           : core dump 文件
-pid            : Attach to running process PID
-directory      : 源文件目录
-nx             : Do not read any .gdbinit files
-nh             : Do not read ~/.gdbinit
-python/-P      : Following argument is Python script file
-quiet/-q       : No version number on startup
-tui            : 建议搭配 -quiet 
-tty            : 指定被调试程序的 IO 终端，默认为当前，通过 tty 命令可以查看
```

## 命令

|command |desc
|- |-
|shell      |执行 shell 命令
|pipe       |将输出发送给 shell 管道

### help

```sh
(gdb) h all                     # 查看所有命令
(gdb) h print                   # 查看指定命令
(gdb) h function                # 查看所有内置函数，abbr: fu
(gdb) h func _regex             # 查看指定内置函数
```

### pipe

```sh
# 使用管道进行过滤，较低版本 gdb 不支持
(gdb) pipe info breaks | grep func_name
```

## set options

```sh
set confirm off                         # 禁用确认
set confirm on                          # 恢复确认

set $i = "test"                         # 创建变量
set $i = 1
set $i = (char)1

set pagination off                      # 输出有多页时全部显示

set output-radix 16                     # 打印数字时默认使用 16 进制
```

## break

```sh
# 适用于打断点尚未加载库，使用该命令会在未来加载库时自动设置断点
set breakpoint pending on
```

```yml
add breakpoints: 添加断点
    file + line         : b file:line
    file + func         : b file:func
    member func         : b class::func
    overload func       : b <function(type[, ...])>
    offset              : b <+/-行数>, 当前行偏移行数
    func + offset       : b <function>:line, 指定函数 + 偏移行数
check break             : info breakpoints
temporary break         : tbreak, 断点触发一次后就会删除
cond break:
    b func if cond      : 打断点时就设定触发条件
    condition <num> cond: 给已经打过的断点设置触发条件
    condition <num>     : 删除断点触发条件

disable break:
    disable <num>       : 如果不加编号则禁用所有断点
enable break:
    enable <num>        : 如果不加编号则启用所有断点
    enable once <num>   : 只启用一次断点，触发后禁用
delete break:
    delete <num>        : 如果不加编号，删除所有断点
    clear               : 删除所有断点且无需确认
    clear <line>        : 删除指定行断点
    clear <func>        : 删除指定函数的断点
commands break:
    commands <num>      : 进入编辑界面，输入触发断点后要执行的命令，输入end结束编辑, 不指定断点编号时默认为最后一个断点
ignore break:
    ignore <num> <count>: 忽略指定次数
```

### rbreak 模糊断点

```sh
# 使用正则表达式为所有匹配的函数打断点
rb test_.*
```

### 条件断点

检查 gdbinit 中是否提前定义

```sh
# int
b test if num == 1
# char *
b test if strcmp(char *, "test") == 0
# std::string
b test if strcmp(str._M_dataplus._M_p, "test") == 0
# 正则表达式
b test if $_regex(char *, "regex_pattern")

# 多条件
b test if num == 1 || num == 2
b test if num >= 1 && num <= 2
```

```sh
# 注意为重载函数设置条件断点时需要确认形参名在所有函数中都存在
# 否则需要显式指定为具体的哪一个函数设置条件断点
void test(int val) {}
void test(float) {}
b test(int) if val == 1
```

### 重载函数断点

```sh
# 只为接收一个 int 参数的函数打断点
b test(int)

# 对于 string 等 typedef 出来的复杂类型
# 先使用 info 查看实际的函数参数，直接复制完整函数声明后打断点
# 然后使用 info 检查是否只有目标函数打上了断点
info functions test     # i func test
b $copied_name
info b
```

### 设置第 N 次触发断点才调试

```c
set $counter = 0
b func_name if ((++$counter) == 10)
```

### 根据函数地址打断点

```sh
# 如查看到函数 test 地址
(gdb) p test
$1 = {void (void)} 0x5555555551a9 <test()>
(gdb) b *0x5555555551a9
Breakpoint 2 at 0x5555555551a9: file a.c, line 3.
```

## 流程控制

```yml
run(r)              : 开始调试，在触发的第一个断点处暂停
start               : 开始调试，在main函数第一行暂停
continue(c)         : 运行至下一个触发的断点处暂停
step(s)             : 从断点位置一行一行运行，遇到函数进入，可加数值参数，表示运行行数
next(n)             : 从断点位置一行一行运行，遇到函数 不 进入，可加数值参数，表示运行行数
until <line>        : 运行直至指定行后暂停
finish              : 运行直至当前栈帧返回，并打印函数返回时的栈帧信息
kill(k)             : 终止当前调试
quit(q)             : 退出gdb
frame(f) <函数栈编号>: 跳转到指定编号的函数栈
up                  : 跳转到上一级堆栈
down(do)            : 跳转到下一级堆栈
watch:
    watch <变量名>  : 监视变量，当其值发生改变时暂停，查看及删除方法同break
    watch *<地址>   : watch *0xffff，监听指定内存地址，只监听 1 字节
    watch *<地址>   : watch *(int*)0xffff，监听 int 类型地址(4 字节)
    rwatch <变量名> : 变量被读取时暂停
    awatch <变量名> : 变量被读写时暂停
catch:
    catch <事件类型>        : 当捕捉到某事件时暂停
    catch assert [名称过滤] : 捕捉失败的断言
    catch throw            : 捕捉抛出异常事件
```

### call 调用代码

```sh
call function(args, ...)
```

### watch 监控变量 / 内存

```sh
watch *(int*)0x7fffa060         # 监听指定内存地址

watch -l <expression>           # 执行表达式并监控其指向的内存地址
```

## 信息显示

```gdb
print(p)
    print <变量或表达式>
    print <*指针>
    print <指针->属性>
    print ::<变量名>: 查看被局部变量覆盖的全局变量
    print <*数组名@长度>: 查看动态数组
    print/x <整型变量名>: 控制数字显示格式(p/x)
        x: 十六进制，o: 八进制，t: 二进制，d: 十进制
x/[nfu] <指针或地址>
    查看指定内存地址，如 x/4dw <数组名> 表示查看整型数组前四位
    n: 数字，表示查看内存单元个数，如查看数组时可输入数组长度
    f: 显示格式，s 表示字符串，x,o,t,d 含义同print
    u: 要查看的数据类型占内存单元字节数，默认为4，可取值: b(1), h(2), w(4), g(8)
list <行号/函数名>: 显示以行号/函数为中心的10行源码，按Enter滚动，如果不输入行号，默认显示以当前断点为中心的10行代码
show
    show args:查看命令行参数
    show values: 查看历史输出记录
display/[format] <表达式>: 追踪查看某个表达式的值
undisplay <编号>: 删除追踪显示，也可用 delete display <编号> 删除
```

### printf

```sh
# 对于很长的字符串，print 可能显示不全，使用 printf
printf "%s\n", str_var
```

### info(i)

```sh
info <subcmd> [regex_filter]    # 过滤输出，正则表达式采用 search 方式
help info <subcmd>              # 查看子命令详细文档

info args                       # 显示函数参数
info functions                  # 显示所有函数
info variables                  # 显示全局和静态变量
info locals                     # 显示局部变量
info break [break_number]       # 显示断点信息
info display                    # 显示自动显示表达式
info sources                    # 查看支持哪些文件源码
info sharedlibrary              # 查看动态库
info threads                    # 查看所有线程
```

### pretty-printer

STL 容器显示值而不是地址信息

```sh
# 打开 gdb 后查看是否支持，显示 global pretty-printers 即支持
info pretty-print

# 开启 pretty-print 后使用原生打印
p /r xxx
```

可能会遇到缺少 pretty-print 相关 python 包的情况，使用 everything 搜索 libstdcxx 或查找 /usr，并将其路径添加到 ~/.gdbinit 中

```python
# gdbinit 内容
set print pretty on
set print object on
set print static-members on
# set vtbl on
set print demangle on
# set demangle on
set print sevenbit-strings off

python
import sys
sys.path.insert(0, '/xxx/xxx/stl_pretty_printer/python')
from libstdcxx.v6.printers import register_libstdcxx_printers
register_libstdcxx_printers (None)
end
```

### ptype/whatis

```sh
whatis <变量或表达式>: 显示变量或表达式数据类型
ptype <变量或表达式>: 显示变量所有成员(不能是指针)
```

### 重定向

```sh
# 仅将程序自身输出重定向到 pts1
gdb a.out -tty /dev/pts/1           # 命令行设置
(gdb) tty /dev/pts/1                # 命令设置
```

## 日志

```sh
# 如果需要同时记录被调试程序的日志，可以借助 shell 的 script 命令
set logging file test.txt       # 默认 gdb.txt
set logging on
gdb_commands                    # 所有输出也会写入日志文件
set logging off

# 关闭分页显示，关闭后会持续输出日志，开启时显示不全的日志会分屏，需要手动翻页
set pagination off
# 等同于
set height 0
```

## 缩写

```gdb
backtrace(bt)
break(b)
frame(f)
info(i)
list(l)
print(p)
```

## 快捷键

```yml
leader-key: Ctrl + x
    a: 切换tui与普通模式
    1: 只显示源码
    2: 显示源码及汇编
    o: 切换焦点窗口
    s: SingleKey模式, 此模式下使用缩写调试命令不需要按回车
        c: continue
        s: step
        n: next
        u: up
        d: down
        p: print
```

### tui 模式快捷键

```yml
Ctrl-P: 上箭头
Ctrl-N: 上箭头
Ctrl-B: 左箭头
Ctrl-F: 右箭头
```

## tui 界面

代码错乱时 Ctrl-L 清屏

```yml
tui reg <寄存器类型>: 打开寄存器窗口，显示处理器的寄存器内容，当寄存器内容发生改变时高亮显示
    源代码窗口  : 显示源码及调试标记
    汇编窗口    : 显示当前源码的汇编代码
    命令窗口    : 和普通的gdb窗口一样
断点标记:
    B: 该断点至少触发了一次
    b: 该断点没触发过
    +: 断点被激活
    -: 断点被禁用
```

## 自动化测试

```gdb
通用设置在 ~/.gdbinit 中设置
启动时加载脚本: gdb -x script.gdb
在gdb内加载自动脚本: source script.gdb
指定调试程序: file <exe>
```

### 基本语法

基本语法和命令行模式相同

```sh
# 注释
# 创建及修改变量
set $var_name = var_value
```

### 格式化输出

```sh
# 变量替换方式同c语言的printf
printf "format-string", ...
```

[c-printf](./cpp.md#printf-format)

### if

```sh
if <condition>
    # do something
else
    # do something
end
```

### for

没有 for，使用 while

### while

```sh
while <conditioin>
    # do something
end

set $_i = 0
while $_i < 10
    set ++$_i
    set $_i += 2
end
```

### 自定义命令

```sh
define <func_name>
    # do something
    # 使用参数
    print $arg0
end
```

### commands 命令

在触发断点后执行命令

```sh
break test_func
commands
    info args
    ...
end
```

## multi-thread(多线程)

```sh
(gdb) i threads                     # 查看有哪些线程
(gdb) thread 2                      # 切换到指定线程
(gdb) set scheduler-locking on      # 锁定其他线程，只有当前线程会继续运行
```

## 插件/脚本

### voltron

[github](https://github.com/snare/voltron)

### gdb-dashboard

[github](https://github.com/cyrus-and/gdb-dashboard)

* tab 可以自动补全

```sh
h dashboard

dashboard -style prompt "(gdb)"         # 切换回默认命令行提示

dashboard -layout                       # 查看可以显示哪些窗口
dashboard -layout source variables      # 只显示源码和变量
dashboard registers                     # 切换是否显示指定窗口

dashboard -output /dev/pts/1            # 所有输出重定向到 pts1
dashboard -output                       # 解除重定向
dashboard assembly -output /dev/pts/1   # 只重定向汇编

dashboard source -style height 0        # 设置窗口高度，0 表示最大高度
dashboard source scroll -2              # 源码向上滚动两行
dashboard source scroll                 # 源码 reset 到当前断点位置
```

### pwngdb

[github](https://github.com/scwuaptx/Pwngdb)

## 注意事项

* 调试时关闭优化(-O0)，否则可能有些信息查询不到
* set <变量名>=<变量值> 加等号是使用的调试语言(c++)的语法，当变量名与gdb内置名称冲突时，使用 set var <变量名>=<变量值> 进行修改
* set 设置通过 help set 能查到的变量时不要加赋值运算符(=)
* 使用文本图形界面时，如果显示信息错乱，Ctrl-L 清屏即可

## tips

### 查看函数所属动态库

如果能触发需要查看的函数断点

```gdb
info registers          # 获取 rip 寄存器中值(地址)
info symbol <rip>       # 查看对应 symbol
```

如果能获得函数地址

```gdb
info sharedlibrary      # 查看动态库内存地址范围
```

## 内置函数

```sh
(gdb) h func                        # 查看有哪些内置函数
(gdb) h func _streq                 # 查看内置函数
(gdb) p $_streq(char*, char*)       # 调用内置函数
```

|function |usage |desc
|- |- |-
|_as_string         |$_as_string(VALUE)                         |将变量转为为字符串
|_streq             |$_streq(A, B)                              |比较字符串，RET: 1/0
|_strlen            |$_strlen(A)                                |字符串长度
|_memeq             |$_memeq(A, B, LEN)                         |二进制比较
|_regex             |$_regex(STRING, REGEX)                     |正则表达式比较，RET: 1/0
|_caller_is         |$_caller_is(NAME [, FRAME_NUMBER])         |检查指定栈号函数名称，默认上一级栈号
|_caller_matches    |$_caller_matches(REGEX [, FRAME_NUMBER])   |正则方式检查
|_any_caller_is     |$_any_caller_is(NAME [, BACK_FRAMES])      |检查上 N 级函数栈是否包含指定函数，默认 N=1
|_any_caller_matches|$_any_caller_matches(REGEX [, BACK_FRAMES])|正则方式检查

### _memeq

```sh
# 判断 addr 内存地址是否连续 8 字节都是 0
$_memeq(addr, "\0\0\0\0\0\0\0\0", 8)
```

## vscode

```vim
继承到vscode：查看reference/vscode下的launch和task
在调试控制台使用原生gdb命令：-exec <cmd>
```

## python

[Python-API](https://sourceware.org/gdb/current/onlinedocs/gdb.html/Python-API.html)

查看 [gdb.py](gdb.py)

```sh
gdb> source gdb.py
```

### 执行 python 代码

```sh
# 在 python 和 end 中间执行 python 代码
python
    print("test")
end
```

### 自定义 gdb 命令

更多命令参考 gdb.py

```py
import gdb

class PyPrint(gdb.Command):
    def __init__(self):
        super().__init__("py_print", gdb.COMMAND_USER)

    def invoke(self, args: str, from_tty):
        for name in args.split():
            print(f"{name}: {gdb.parse_and_eval(name)}")

PyPrint()
```

```sh
gdb> source py_print.py
gdb> py_print value1 value2
```

### 自定义 gdb 函数

```py
import gdb

class PyIsTrue(gdb.Function):
    def __init__(self):
        super().__init__("is_true")

    # 参数个数可以改变，实际调用时保持一致
    def invoke(self, value: gdb.Value, *args):
        val = str(value).replace('"', '').strip()
        return val not in ['0', 'false', 'False']

PyIsTrue()
```

```sh
(gdb) p $is_true(1)
(gdb) p $is_true(0)
```

## 调试 python

[教程](https://devguide.python.org/development-tools/gdb/index.html)
