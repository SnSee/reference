
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

## 断点

```gdb
添加断点
    break <文件名>:<行号>
    break <文件名>:<函数名>
    break <类名>::<函数名>
    break <function(type[, ...])>: 指定函数重载版本
    break <+/-行数>： 在当前行向上/向下偏移指定行数
查看所有断点
    info breakpoints(简写 info br)
临时断点
    tbreak, 断点触发一次后就会删除
条件断点
    break <断点> if <条件>: 打断点时就设定触发条件
    condition <断点编号> <条件>: 给已经打过的断点设置触发条件
    condition <断点编号>: 删除断点触发条件
禁用断点
    disable <断点编号>，如果不加编号则禁用所有断点
启用断点
    enable <断点编号>, 如果不加编号则启用所有断点
    enable once <断点编号>: 只启用一次断点，触发后禁用
删除断点
    delete <断点编号>, 如果不加编号，删除所有断点
    clear: 删除所有断点且无需确认
    clear <行号>: 删除指定行断点
    clear <函数名>: 删除指定函数的断点
断点触发后执行命令
    commands <断点编号>: 进入编辑界面，输入触发断点后要执行的命令，输入end结束编辑
    不指定断点编号时默认为最后一个断点
忽略断点
    ignore <断点编号> <次数>
```

### 设置第 N 次触发断点才调试

```c
set $counter = 0
b func_name if ((++$counter) == 10)
```

## 流程控制

```gdb
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
watch
    watch <变量名>  : 监视变量，当其值发生改变时暂停，查看及删除方法同break
    rwatch <变量名> : 变量被读取时暂停
    awatch <变量名> : 变量被读写时暂停
catch
    catch <事件类型>        : 当捕捉到某事件时暂停
    catch assert [名称过滤] : 捕捉失败的断言
    catch throw            : 捕捉抛出异常事件
```

### break

```sh
# 适用于打断点尚未加载库，使用该命令会在未来加载库时自动设置断点
set breakpoint pending on
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
    print/x <整型变量名>: 控制数字显示格式
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
info variables                  # 显示全局和静态变量
info locals                     # 显示局部变量
info break [break_number]       # 显示断点信息
info display                    # 显示自动显示表达式
info sources                    # 查看支持哪些文件源码
info sharedlibrary              # 查看动态库
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
set vtbl on
set print demangle on
set demangle on
set print sevenbit-strings off

python
import sys
sys.path.insert(0, '/xxx/xxx/stl_pretty_printer/python')
from libstdcxx.v6.printers import register_libstdcxx_printers
register_libstdcxx_printers (None)
end
```

## 日志

```gdb
# 开启日志，会在当前目录生成 gdb.txt
set logging on
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

```gdb
leader-key: Ctrl + x
    切换tui与普通模式: a
    是否显示汇编
        1: 只显示源码
        2: 显示源码及汇编
    SingleKey模式: s, 此模式下使用缩写调试命令不需要按回车
```

### tui 模式快捷键

```yml
Ctrl-P: 上箭头
Ctrl-N: 上箭头
Ctrl-B: 左箭头
Ctrl-F: 右箭头
```

## tui 界面

```gdb
tui reg <寄存器类型>: 打开寄存器窗口，显示处理器的寄存器内容，当寄存器内容发生改变时高亮显示
源代码窗口: 显示源码及调试标记
汇编窗口: 显示当前源码的汇编代码
命令窗口: 和普通的gdb窗口一样
断点标记
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
基本语法(和命令行模式相同)
    # 注释
    创建及修改变量: set $var_name = var_value
    定义函数
        define <func_name>
            # do something
        end
    条件语句
        if <condition>
            # do something
        else
            # do something
        end
    循环语句
        while <conditioin>
            # do something
        end
格式化输出(变量替换方式同c语言的printf): printf "format-string", ...
```

参考[c-printf](../program_language/c-cpp/c-cpp.md#printf-format)

### commands 命令

在触发断点后执行命令

```sh
break test_func
commands
    info args
    ...
end
```

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

## set 变量

```gdb
创建变量：
    set $i = "test"
    set $i = 1
    set $i = (char)1
whatis <变量或表达式>: 显示变量或表达式数据类型
ptype <变量或表达式>: 显示变量所有成员(不能是指针)
```

## 内置函数

库函数都可以试一试

|function |usage |desc
|- |- |-
|strcmp     |strcmp(char *, char *)     |比较字符串
|$_regex    |$_regex(char *, "regex_pattern") |正则表达式比较，匹配返回 1，否则 0

## vscode

```vim
继承到vscode：查看reference/vscode下的launch和task
在调试控制台使用原生gdb命令：-exec <cmd>
```

## 调试 python

[教程](https://devguide.python.org/development-tools/gdb/index.html)
