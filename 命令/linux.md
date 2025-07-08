# Linux

<!-- markdownlint-disable no-emphasis-as-heading table-pipe-style-->

```bash
# 下载部分命令源码
git clone git://git.savannah.gnu.org/coreutils.git
```

[Bash FAQ](http://mywiki.wooledge.org/BashFAQ/)
[命令在线查询](https://www.lzltool.com/LinuxCommand)

## session

启动 X server

```sh
# :100 表示 DISPLAY 值
sudo nohup startx -- :100 &
# 启动 X server 后执行，使所有用户都可以连接 server
xhost +

# 锁住虚拟终端，避免其他人使用
vlock

# 切换虚拟控制台
chvt <idx>
```

### X11

```sh
# 检查是否安装了 X11
which X
which Xorg
echo $DISPLAY
```

检查 X11 环境是否启用

```sh
xdpyinfo            # 不响应表示没启动
ps aux | grep X     # 检查是否有相应进程
ps aux | grep Xorg  # 检查是否有 X server
```

### tty

TTY 是 Linux 或 UNIX 的一个子系统，它通过 TTY 驱动程序在内核级别实现进程管理、行编辑和会话管理。

```sh
ps aux | grep X     # 查看 tty 编号
```

## 终端(terminal)

自定义终端提示信息

```sh
# 设置 PS1 的值即可
PS1='[\u@\h \W]$ '

\u: 当前用户名
\h: 短主机名
\H: 全主机名
\w: 当前工作目录(相对于主目录)
\W: 当前工作目录(只显示最后一级)
\[\033[32m\]: 颜色
```

### Tab 候选项/自动补全

```sh
bind -f ~/.inputrc
```

.inputrc 内容

```sh
set show-all-if-ambiguous on
set completion-ignore-case on
```

### 设置默认为 bash

```sh
sudo chsh -s /bin/bash username
```

### linux 桌面进入命令行模式

```sh
Ctrl + Alt + F<N>
```

### ubuntu 无图形界面启动

```sh
# 设置无图形界面启动
sudo systemctl set-default multi-user.target
# 恢复图形界面
sudo systemctl set-default graphical.target
# 查看图形界面是否被禁用
sudo systemctl get-default

# 启动后若想进入图形界面启动 gdm 服务
sudo systemctl start gdm3.service
```

### ANSI

[ANSI转义代码(ansi escape code)](https://zhuanlan.zhihu.com/p/570148970)
[ANSI_escape_code](https://handwiki.org/wiki/ANSI_escape_code)

```py
# 清空屏幕，不同于 clear 刷新屏幕，删除的内容不能通过滚动屏幕查看
# \033[{i};1H   将光标移动到第 i 行
# \033[2K       清空光标所在行
for i in range(100):
    print(f"\033[{i};1H\033[2K", end="", flush=True)
# 将光标移动到屏幕左上角
print("\033[H", end="", flush=True)
```

## 快捷键

终端

```sh
# 查看终端类型
echo $TERM                          # 如：xterm-256color
export TERM=xterm-256color          # 设置终端类型
```

### 光标

光标([csh可能需要自定义快捷键](./cshell.md#光标))
[bind命令](https://blog.csdn.net/cnds123321/article/details/124815867)

```bash
ctrl + a: 跳到行首
ctrl + e: 跳到行尾
ctrl + u: 删除到行首
ctrl + k: 删除到行尾
ctrl + w: 删除到单词尾
    bindkey "^W" delete-word
ctrl + delete: 删除到单词头
    bindkey "^H" backward-delete-word
    bind '\C-H:unix-word-rubout'
ctrl + d: 删除光标后一个字符
Alt  + d: 删除光标后一个单词
ctrl + 方向键: 光标按单词移动
```

### 设置快捷键

设置快捷键(可通过 [showkey](#showkey) 命令查看\<key\>的值)

```sh
# bash
# 在 wsl 上无效
bind -p                     # 查看已绑定快捷键
bind -P                     # 查看已绑定快捷键
bind -l                     # 查看支持的操作
# \C: ctrl, \e: alt/escape?
bind '"<key>":<option>'     # 绑定操作到快捷键

bind -f /etc/inputrc        # 绑定一些配置号的快捷键
```

### 历史命令

```text
# 通过输入关键字查找, 再按一次显示下一个匹配项
# 回车直接执行
# ctrl + g 退出（清空已有内容）
# ctrl + c 强制退出（新命令行）
# esc 退出（保留命令行内容但不执行）
Ctrl + r：逆向搜索命令历史

Ctrl + p：历史中的上一条命令(上方向键)
Ctrl + n：历史中的下一条命令(下方向键)

Alt + .：使用上一条命令的最后一个参数
```

### Ctrl-Z

暂停将一个前台命令

```sh
jobs            # 查看所有挂起的命令
fg $index       # 将指定编号的命令恢复到前台执行
bg $index       # 后台执行
```

## man

[在线 man 手册](https://www.systutorials.com/docs/linux/man)

```sh
man [options] command

-k      : 查找符合指定正则的 short description 和 manual page name，如 -k . 表示所有 man 手册
```

数字对应手册类型

|type | desc
|- |-
|1 | 可执行程序 和 shell 命令
|2 | 内核 函数，头文件，结构体等
|3 | 库 函数，头文件，结构体等
|4 | Special files (usually found in /dev)
|5 | File formats and conventions eg /etc/passwd
|6 | Games
|7 | Miscellaneous (including macro packages and conventions), e.g. man(7), groff(7)
|8 | System administration command (usually only for root)
|9 | Kernel routines [Non standard]

```bash
# 查看所有 SIGNAL 信号
man 7 signal
```

## 用户

```sh
# 根据 uid 查询用户名
getent passwd uid
# 根据用户名查询 uid
id user_name

# 将用户添加到用户组
sudo gpasswd -a <user_name> <group_name>
```

### sudo

```sh
# 以 root 用户启动 shell
sudo -s
```

## 文件

```bash
# 查看文件
inode: ls -i 或 stat file_name

# 查看文件个数
ll | wc -l
find ./ -name "*.cpp" | wc -l
```

时间戳([stat](#stat-文件元数据))

```sh
ls -l           # 查看最后修改时间
```

### tar

```bash
# 基础用法
# 注意: 要打包的目录放到命令行选项之后
tar czvf test.tar.gz [--exclude ..] ./*

# 可选参数
--exclude 过滤指定文件或目录，可指定多次，只要打包时相对路径中包含指定内容即会过滤，可使用通配符
    --exclude build
    --exclude src/python/.idea
    --exclude test/*.txt
```

## 系统

```sh
free -h                 # 查看内存大小
```

## 进程

查看cpu核数

```sh
nproc
lscpu | grep 'CPU(s)'
cat /proc/cpuinfo | grep "core id" | wc -l
```

### ps

```sh
# 查看指定进程状态
ps -l $pid

# 查看进程启动及运行时间
# pid       : 进程id，可通过 `ps aux | grep app_name` 查找
# lstart    : 启动时间
# etime     : 运行时间
ps -eo pid,lstart,etime | grep 进程id

# 查看指定父进程唤起的子进程(非递归)
ps --ppid $pid
pgrep -P $pid
# 递归查看
pstree -p $pid

# 显示全用户名
# man 手册 ^STANDARD FORMAT SPECIFIERS 查看可用列名
ps -o ruser=user20wei9 -e -o pid,ppid,%cpu,%mem,s,stime,tty,time,cmd
```

进程状态(man ps：搜索 STATE)

```sh
R: running or runnable
S: interruptible sleep (wait for an event to complete)
D: uninterruptible sleep (usually IO)
T: stopped by job control signal
t: stopped by debugger during the tracing
W: paging (not valid since the 2.6.xx kernel)
X: dead (should never be seen)
Z: defunct (zombie) process, terminated but not reaped by its parent
```

```sh
<: high-priority (not nice to other users)
N: low-priority (nice to other users)
L: has pages locked into memory (for real-time and custom IO)
s: is a session leader
l: is multi-thread (using CLONE_THREAD, line NPTL pthreads do)
+: is in the foreground process group
```

### 文件描述符

```sh
# 查看所有进程打开的文件描述符
ls -l /proc/$PID/fd
```

### 脚本

```text
查看当前进程 id: echo $$
ls按时间排序:
    ls -lt  最新文件在前
    ls -lrt 相反
获取当前脚本绝对路径: $(dirname `readlink -f $0`)   # source时无效
bash 中通过 $BASH_SOURCE 可获取被 source 脚本路径
```

### 任意命令返回非 0 值自动退出

```sh
# 执行命令前设置
set -e
```

### top

[知乎](https://zhuanlan.zhihu.com/p/458010111)

[进程状态](#ps)

```text
PID USER PR NI VIRT RES SHR S %CPU %MEM TIME+ COMMAND
PID : 进程号
USER: 用户名
PR  : 内核调度优先级
NI  : Nice值，影响PR
VIRT: 使用内存，包括swap内存和物理内存
RES : 使用物理内存
SHR : 当前进程和其他进程共享内存大小
%CPU: 使用CPU占比
%MEM: 使用内存占总内存比例
TIME: 该进程启动后使用CPU总耗时
COMMAND: 进程名或启动进程的命令
```

```text
在执行top后按下对应字母进行快捷操作
c: 切换进程名和完整的启动进程命令(top -c)
u: 输入用户名进行过滤(top -u <user>)
m: 切换汇总区内存显示方式为数字或进度条格式
t: 切换汇总区CPU显示方式为数字或进度条格式
M: 按使用内存大小情况排序
P: 按使用CPU占比排序
N: 按进程id从大到小排序
T: 按CPU使用时间排序
V: 展示父子进程关系
O: 基于表达式过滤
   COMMAND=xxx 只显示COMMAND包含xxx的结果
   !COMMAND=xxx 只显示COMMAND 不 包含xxx的结果
   %CPU>3.0 只显示CPU使用占比大于3%的结果
=: 清除过滤表达式
```

```bash
# 查看单一进程资源使用情况
top -p <PID>    # PID 可通过ps获取

# 显示全用户名
    X5<Enter>
# 显示全命令
    c
```

## 驱动

[设备文件编号含义](https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/Documentation/admin-guide/devices.txt)

```sh
# 查看当前系统设备文件编号
/proc/devices
```

## 服务

```sh
systemctl status gdm            # 查看服务状态
sudo systemctl stop gdm         # 停止服务
sudo systemctl start gdm        # 启用服务
```

## 版本

```text
查看发行版信息
    cat /etc/os-release
    cent-os: cat /etc/centos-release
```

## 编程

```bash
# 查看程序运行时动态库搜索路径
readelf -d app_or_so | head - 20
ldd app_or_so

# 查看动态库版本及依赖库版本信息
readelf -V app_or_so

# 查看动态库中有那些符号
# 如果要查找是否含有特定字符串，配合grep使用
strings test.so
```

### if

```sh
# 基础语法
if [ condition ]; then
elif [ another_condition ]; then
else
fi

# 字符串比较
if [ "$var" = "hello" ]; then
fi

# 数值比较
if [ $num -eq 10 ]; then
fi
if [ $num -ne 10 ]; then
fi

# 文件测试
if [ -f "filename.txt" ]; then
elif [ -d "dirname" ]; then
else
fi
```

### while

```sh
count=1
while [ $count -le 5 ]
do
    echo $count
    count=$((count + 1))
done
```

```sh
while true
do
    echo -n "enter q to exit"
    read input
    if [ "$input" = "q" ]; then
        break
    fi
    echo "entered: $input"
done
```

### for

```sh
arr=(1 2 3 4 5)

for i in "${arr[@]}"; do
  echo $i
done
```

## 文件

### locate

```text
locate <file_name> (支持wildcard)
```

### find

命令行选项

```sh
-name      : 指定文件名称，必须全部匹配，使用通配符需要双引号，如: -name "*.txt"
-iname     : 忽略大小写
-type      : 指定文件类型，常用: f-普通文件, d-文件夹
-mmin      : 最近指定分钟内修改过的文件
-atime     : 最近访问的文件，单位 *24 小时，+N 表示 [N+1, )，-N 表示 [0, N)，N 表示 [N,N+1)
-mtime     : 最近修改的文件(内容)
-ctime     : 最近修改的文件(元数据)
-amin      : 同 atime，单位是分钟
-mmin      : 同 mtime，单位是分钟
-cmin      : 同 ctime，单位是分钟
-exec      : 找到文件后执行命令({}是文件名，\; 或 + 表示结束)，如: -exec wc -l {} \; 
             其中 + 表示将多个找到的文件用空格连接作为命令输入
-execdir   : 在文件所在目录执行命令
-executable: 只查找具有执行权限的文件或目录
-L         : 跟随软链接，使用链接到的文件的属性，如 -type 时指定的文件类型。
             对于目录的软链接，会对目录进行递归查找。
-not -path : 忽略指定名称，需要全比配，可使用通配符
```

```bash
# 按名称查找
find ./ -name "*.txt"

# 按时间查找
find . -mtime -2        # 48 小时内修改的文件
find . -mtime 2         # 48-72 小时内修改的文件
find . -mtime +2        # 72 小时外修改的文件

# 查找可执行文件
find . -type f -executable

# 忽略指定目录
find . -not -path "./tmp*"
find . -name "*.txt" -prune -o -path "./tmp" -prune

# 忽略多个目录
find . -name "*.txt" -prune \
    -o -path "./tmp1" -prune \
    -o -path "./tmp2" -prune

# 对查找到的文件执行命令({}表示查找到的文件)
find . -name "*.txt" -exec cat {} \;
```

```bash
# 递归删除当前路径下所有名称及类型符合匹配条件的文件
find ./ -type {type} -name {name} | xargs rm -rf
find ./ -type {type} -name {name} -exec rm -rf {} \;

# 使用管道
find . name "*.txt" -exec sh -c 'basename {} | fgrep test' \;
# 对于 csh 可以使用 -cf 不 source ~/.cshrc 加快速度
```

### du

```sh
du -hs                  # 统计当前目录总占用(不显示子目录)
du -h -d 1              # 统计当前目录总占用(显示一级子目录)
du -h --max-depth 1     # 同 -d 1
```

### ncdu

[下载地址](https://dev.yorhel.nl/ncdu)

```text
查看文件夹磁盘占用大小
如果知道系统架构可以直接下载可执行文件(Static binaries)使用
```

```text
直接执行ncdu会扫描当前目录
ncdu xxx扫描指定目录
扫描结果出来后按 ? 查看帮助
jk上下选择目录，h回到上一级，l进入子目录
```

### lsof

List Open Files

```sh
lsof [options] <names>

<names>: 文件名，PID，用户名，IPv4，IPv6等
-i: 查看网络连接信息
-r: 每隔指定秒数刷新一次
+d: 非递归查看目录下文件被进程占用情况
+D: 递归查看目录下文件被进程占用情况
-c: 过滤以指定字符串开头的 COMMAND，可指定多次
-p: 根据 PID 过滤，如 -p 123,456
-u: 根据 USER/USER_ID 过滤，如 -u ycd,1234
```

lsof 各列含义

```yml
COMMAND : 进程名
PID     : 进程 id
TID     :
USER    : 用户名
FD      : 打开的文件描述符类型
    txt: 可执行文件
    cwd: 工作目录
    rtd: 根目录
    mem: 内存映射文件
    u  : 读写模式
    r  : 读模式
    w  : 写模式
    0  : 标准输入
    1  : 标准输出
    2  ：标准错误
    其他数字: 文件描述符?
TYPE    : 文件类型
    REG  : 普通文件
    DIR  : 目录
    CHR  : 字符设备
    BLK  : 块设备
    FIFO : 先进先出管道
    IPv4 : 网络套接字
    IPv6 : 网络套接字
    unix : Unix 套接字
DEVICE  : 设备号，major:minor
SIZE/OFF: 文件大小或偏移量
NODE    : inode
NAME    : 文件路径
    普通文件(REG): 如 /home/user/file.txt
    设备文件(CHR/BLK): 如 /dev/pts/1
    网络套接字(IPv4/IPv6): 如 localhost:6013，ssh 连接
```

```sh
# 查看文件被哪个进程占用/使用
lsof test.txt

# 查看网络连接信息
lsof -i
# 监听特定端口号，每 3 秒刷新一次
lsof -i:443 -r3
```

### 清空/创建空文件

```sh
cat /dev/null > text
```

### rehash

更新 shell 命令哈希表，即重新加载 PATH 中的可执行文件，在增删命令后执行

## shell编程(bash)

睡眠

```bash
sleep 5     # 睡眠 5 秒
sleep 0.5   # 睡眠 0.5 秒
usleep 5    # 睡眠 5 微秒
```

数组

```bash
arr=("1" "2" "3" "4")       # 定义数组
${arr[@]}                   # 获取所有元素
${#arr[@]}                  # 获取长度
${arr[index]}               # 访问索引
arr[${arr[@]}]=element      # 追加数据
```

进度条

```bash
printf "....\r"     # 最后的\r会把输出位置定位到本行行首

# 动画效果
frames="\\ | / -"
while true
do
    for frame in $frames
    do
        printf "\rLoading... $frame"
        sleep 0.25
    done
done
```

重定向标准错误到标准输出

```bash
command > file 2>&1
```

for

```bash
# 使用seq命令生成1到5这5个数字，并输出它们的平方的示例
for i in $(seq 1 5)
do
  square=$((i*i))
  echo "The square of $i is $square"
done
```

无限循环

```bash
while true; do
done
```

按行读取文件

```bash
while read line
do
    echo $line
done < test.txt
```

函数

```bash
# 括号里不能有参数
function test() {
    fir_arg=$1  # 获取参数
    #return 1   # 不能用 return ???
    echo 1    
    # 使用echo返回字符串:
    # echo $fir_arg
    # return
}

# 获取函数返回值
ret=`test fir sec`
```

let 数学运算(只能计算整数)

```bash
index=0
let ++index
let --index
let index+=1
let index+=1+2
let index=index+1
let index*=2
let index/=2        # 小数位会被舍弃
```

[expr 数学运算](#expr)

浮点数运算

```sh
# bc参数需要是文件，因此需要管道
echo "2.5 + 3.7" | bc

# 借助awk
echo "2.5 3.7" | awk '{print $1 + $2}'

# 借助python
python -c 'print(2.5 + 3.7)'
```

解析命令行参数

[getopts](https://blog.csdn.net/solinger/article/details/89887155)

```bash
$#      # 获取命令行参数 个数(不包括脚本名)
$*      # 获取所有命令行 参数(不包括脚本名)
$@      # 获取所有命令行 参数(不包括脚本名)
$1      # 获取 第一个命令行参数(空格分隔)
```

[$@和$*区别](https://blog.csdn.net/f2157120/article/details/105649551)

在shell脚本内向程序输入字符串

```bash
python << EOF
import os
print(os.getcwd())
EOF
```

```tcl
tclsh << EOF
puts "string from shell bu executed in tcl interpreter"
EOF
```

### 字符串操作

```bash
${#str}             # 获取字符串长度
${str:m:n}          # 截取[m,n]子串, 可没有n, 不能用负数
${str}normalstr     # 拼接字符串
${str/<re1>/<re2>}  # 将 第一个<re1>替换为<re2>
${str//<re1>/<re2>} # 将 所有<re1>替换为<re2>

# 正则表达式截取字符串(以下四种不匹配时都是保留原字符串, . * 需要转义 \. \*)
${str#<re>}         # 删除$str 前 半段match <re>的部分(不修改原字符串), 如果有多个匹配点，取靠 前 的
${str##<re>}        # 删除$str 前 半段match <re>的部分(不修改原字符串), 如果有多个匹配点，取靠 后 的
${str%<re>}         # 删除$str 后 半段match <re>的部分(不修改原字符串), 如果存在多个匹配点，取靠 后 的
${str%%<re>}        # 删除$str 后 半段match <re>的部分(不修改原字符串), 如果存在多个匹配点，取靠 前 的
# 注意：删除 前 半段时正则表达式要从 头 开始匹配，删除 后 半段时匹配要到 末尾

# 提取字符串
temp=`echo  "helloworld20180719" | tr -cd "[0-9]" `     # 提取数字
```

字符串判断

```bash
if [[ $s1 == $s2 ]]     # 注意: 空格不能省略
if [[ $s1 != $s2 ]]
if [[ $s1 == ab* ]]     # 可使用通配符
if [[ $s1 == ab"*" ]]   # *作为普通字符
if [[ $s1 =~ "abc" ]]   # 正则，相当于 search
```

富文本

```bash
bold=$(tput bold)           # 加粗
underline=$(tput smul)      # 下划线
italic=$(tput sitm)
info=$(tput setaf 2)        # 绿色
error=$(tput setaf 160)     # 红色
warn=$(tput setaf 214)      # 黄色
reset=$(tput sgr0)          # 恢复所有设置
echo "${info}INFO${reset}: This is an ${bold}info${reset} message"
echo "${error}ERROR${reset}: This is an ${underline}error${reset} message"
echo "${warn}WARN${reset}: This is a ${italic}warning${reset} message"
```

## 时间

```bash
# 显示当前时间
date

# 按固定格式显示时间
date +"%Y%m%d_%H%M"

# 显示程序耗时
time ./a.out
```

## 环境变量

```sh
export KEY=VALUE        # bash 设置环境变量
unset KEY               # 取消环境变量
```

```yml
SHELL                  : 当前shell类型
PATH                   : 可执行文件查找路径
HOME                   : 用户家目录
USER                   : 用户名
HOSTNAME               : 主机名($HOST)
LD_LIBRARY_PATH        : 临时动态库查找路径
PYTHONHOME             : python 家目录(默认lib及 site-package 路径)
PYTHONPATH             : python 库搜索路径
XDG_SESSION_TYPE       : 当前会话类型
    - x11
    - wayland
    - tty
```

## 三剑客

### grep

grep命令是一种文本搜索工具，可以用于在指定文件、标准输入或者其他命令的输出中查找匹配指定字符串模式的行。

* grep本身支持基础正则(BRE)，一些正则字符需要使用 \ 转义，如 ? + 等
* -E 选项支持扩展正则(ERE)，不需要转义符号
* egrep相当于grep -E
* fgrep相当于grep -F，速度比正则快

grep 命令 **默认为贪婪模式**，如果要使用非贪婪模式，使用 .*?

命令行参数

```text
-i: 忽略大小写
-v: 不匹配行
-h: 仅显示匹配行，不显示文件名
-H: 显示匹配行及文件名
-c: 仅显示匹配文件数量
-o: 仅显示匹配的部分，如果一行中有多个部分匹配，显示为多行
-l: 仅显示匹配文件
-L: 仅显示不匹配文件
-n: 显示行号
-r: 递归搜索，不搜索链接指向的文件
-R: 递归搜索，搜索链接指向的文件
-w: 匹配整个单词, 而不是单词一部分
-e: 可多次指定匹配模式
-E: 使用正则表达式
-F: 使用固定字符串(非正则，*? 等会当作普通字符)
-f: 从文件中获取匹配模式，文件中每行为一个模式
--exclude: 排除某些文件或目录
--include: 只匹配指定文件或目录
-A: 显示匹配行及其后n行，-A n
-B: 显示匹配行及其前n行，-B n
-C: 显示匹配行及其前后n行，-C n
```

单引号和双引号区别：双引号中 $ 会进行变量替换，单引号不会

```sh
# grep不到
a=1&&echo '123'|grep '$a'

# 能grep到
a=1&&echo '123'|grep "$a"
```

示例

```bash
# 如果匹配模式中不包含特殊字符(空格，星号等)，可以不适用双引号括起来
grep test test.txt
grep "test1 test2" test.txt

# 匹配 不 包含test的行
grep -v test test.txt

# 指定多个匹配模式
grep -e Test -e test test.txt
grep -e '\wa' -e 'a\w' test.txt

# grep递归搜索指定扩展名文件
grep -r example /path/to/directory/ --include="*.txt"
# 开启了**功能(shopt -s globstar)
grep -r example /path/to/directory/**/*.txt

# 统计字符串中某个字符/字符串的数量
echo '1-2-3-4' | fgrep -o '-' | wc -l       # 结果: 3

# 只打印捕获内容，还可参考 awk match 函数
echo 'abc 123 def 456' | egrep -o '[0-9]\+'
```

### sed

[在线查看](https://www.lzltool.com/LinuxCommand/sed)

* 如果要使用变量，使用双引号或者eval调用sed
* 如果变量中存在 /，需要将 / 转义为 \/ 后才能带入 sed

```bash
s="/a/b/c"
s=$(echo "$s" | sed 's/\//\\\//g')
echo "path" | sed "s/path/${s}/g"

eval sed -i 's/${old}/${new}/g' test.txt
# 或
cmd="sed -i 's/${old}/${new}/g' test.txt"
eval $cmd
```

命令行参数

```text
-n: 不打印原文件内容
-i: 将修改应用到原文件
```

语法

```sh
# i: 忽略大小写
sed '[range][option][i]' <file>

# range: 如果指定范围，只会对范围内的行进行操作
单行          ：5 表示第5行
连续多行      : 5,$ 表示5到最后一行
指定模式单行   : /pat/ 表示符合正则表达式pat的行，采用search的方式
指定模式多行   : /start/,/end/ 表示从符合start的行到符合end的行，包含start和end所在行，如果有多个start，end则从第一个start到最后一个end
行号和模式混用 ：5,/end/ 表示从第5行到符合end的行
              : /start/,10 表示从符合start的行到第10行

# option: 对行进行操作，可以指定只对符合正则表达式的行操作
# 如果range结束标记是正则，且指定了正则，需要 {option}, 如 '/start/,/end/{/pat/p}'
p: 打印, 'p' 或 '/pat/p'
d: 删除, 'd' 或 '/pat/d'
s: 替换, 's/pat/new/g', g表示替换一行中所有old，否则只替换第一个
i: 当前行位置插入新行, 'i' 或 '/pat/i'
a: 当前行下一行插入新行, 'a' 或 '/pat/a'
q: 退出

# 指定多种操作
'{option1;option2}'

# 示例
'5p'                        # 第5行
'5,$p'                      # 5到最后一行
'/start/,/end/p'            # [start,end](第一个start到最后一个end)
'/start/,/end/{p;/end/q}'   # [start,end](第一个start到第一个end)
'5,/end/p'                  # [5,end]
'5,/end/{/pat/p}'           # [5,end]符合pat的行
```

<a id='sed-regexp'></a>
正则表达式(非通用正则表达式)

**支持\w**
**不支持\d**

```text
不支持 +
^           : 行开始
$           : 行结束
.           : 任意非换行符的字符
*           : 0或多个字符
[]          : 匹配范围内任意字符
[^]         : 匹配不在范围内的任意字符
\|          : 或，如 's/\(aa\|bb\)/NEW/gi'
\(..\)      : 捕获子串，通过数字访问捕获内容，如's/\(aa\)bb/\1cc/'，aabb替换为aacc
&           : 捕获整个pattern字符串，相当于\0，如's/love/**&**/'，love替换为**love** 。
\<          : 单词开始
\>          : 单词结束
x\{m\}      : 重复字符m次
x\{m,\}     : 重复字符至少m次
x\{m,n\}    : 重复字符m-n次
```

示例

```bash
# 提取第2行
sed -n "2p" test.txt
# 提取第[2,5]行
sed -n "2,5p" test.txt

# 在文件第2行位置插入字符串
set -i '2iMessage to insert' test.txt

# 在文件最后一行追加字符串
set -i '$aMessage to insert' test.txt

# 移除最后4个字符
echo "Hello World!" | sed 's/.\{4\}$//'

# 删除匹配的单行
sed '/pattern/d' input.txt
# 替换匹配的单行
sed 's/pattern/new_str/g' input.txt
# 打印起始标记到结束标记间的内容(标记所在行也会打印)
sed -n '/start/,/end/p' input.txt
# 删除从第一行到指定结束标记间指定模式的内容

# 只打印匹配的内容(推荐使用 awk match函数)
# {1,} 会用非贪婪模式
echo 'number: 33' | sed -n 's/.*\([0-9]\{1,\}\)/\1/p'
```

### awk

```sh
awk [options] '[pattern]{action}' file

options: 命令行参数
pattern: 正则匹配模式，bool表达式等
action:  具体操作，如调用函数，一般是print，通过 ; 分隔多个函数

# [pattern]{action} 可重复多次，如对包含pat的行打印两次
awk '{print} /pat/{print}' file
```

#### 注意

```txt
print 变量时不能加 $，除了 $0 这种
```

#### 命令行参数

```bash
-F: 指定分隔符，
    可以是字符串，如 -F'=='
    可以是正则表达式，如 -F'[,;:]'，相当于 -F'(,|;|:)'
```

#### 语法

```text
通过定义在 '{ }' 中的内容定义行为
print: 打印
分隔符: 默认是空格
$0 表示原始数据，$1 分割后第一个部分(行首空格会自动忽略)，$2 分割后第二个部分
$NF最后一列(注意：如果各行列数不同，则输出列为当前行最后y)，$(NF-1)倒数第二列
```

#### 特殊变量/普通变量

```text
NR    : 行号，从1开始
NF    : 当前行列数
BEGIN : 在编辑第一行前执行操作
END   : 在编辑最后一行后执行操作
&&    : 与
||    : 或
!     : 非（可能需要转义 \!）
```

普通变量直接赋值

```sh
echo "1 2" | awk '{tmp=$1; print tmp}
```

#### 正则表达式

[正则表达式(未列出的参考sed)](#sed-regexp)

支持 \w 等用法，参考[正则表达式](../算法/mess.md#正则表达式)
不支持 \d

```sh
# | 等不需要转义
# 不支持捕获组，可以使用match替代
+   : 匹配前面的模式至少 1 次
?   : 匹配前面到模式 0 或 1 次
```

#### 函数

```sh
exit                        # 退出编辑
length(str)                 # 字符串长度
split(str, arr, splitter)   # 根据splitter拆分str，结果存储到数组arr中
index(str, pat)             # pat在str中位置，从1开始，没找到返回0
tolower(str)                # 转小写
toupper(str)                # 转大写

match(str, regexp, arr)     # search，结果存在arr中，支持捕获分组
echo 'Tom 10' | awk '{match($0,/([a-zA-Z]+) ([0-9]+)/,arr);printf("name: %s, age: %d\n",arr[1],arr[2])}'

substr(str, start, length)  # 截取子字符串, length可以不设置，表示到末尾
getline                     # 读取下一行(会移动文件指针)，并存储在$0中(当前行被取代)

# sub/gsub: 变量替换(sub只替换第一个，gsub全都替换)
# target默认为 $0
# 返回值：进行替换次数，因此可以通过gsub实现count功能
sub(regexp, replacement, target)
'{count=gsub("a", "")}'     # 统计一行中字符a的数量
** 注意 ** ：sub/gsub会修改原有字符串，如果不想修改原字符串可以使用变量
'{tmp=$0;gsub("pat","new")}'
```

```sh
# 只打印捕获内容
echo '### number: ### 123' | awk '{match($0,/.+(number):[^0-9]+([0-9]+)/,arr);printf("%s: %d\n", arr[1], arr[2]);}'

# 针对文件只打印捕获内容所在行
awk '{if(match($0,/.+(number):[^0-9]+([0-9]+)/,arr)){printf("%s: %d\n", arr[1], arr[2])}}' test.txt
```

#### 操作区间

```sh
awk 'NR>=5&&NR<=10 {print}' file                # 指定行区间 [5,10]
awk 'NR==5,NR==10 {print}' file                 # 指定行区间 [5,10]
awk '/pat/ {print}' file                        # 只编辑能search到pat的行
awk '!/pat/ {print}' file                       # 只编辑不能search到pat的行, csh需要转义!, 即 \!  
awk 'NR>1 && /pat/ {print}' file                # 同时指定行号和正则

# 指定正则表达式区间
awk '/begin/,/end/ {print}' file                # [begin,end]
awk 'NR==1,/end/ {print}' file                  # [1,end]
awk 'NR>0 {print} /end/{exit}' file             # [1,end]
awk '/begin/,/^$/ {print}' file                 # [begin, $]

# 同时指定区间和条件
awk '/begin/,/end/ {if(/pat/){print}}' file     # [begin,end]符合pat的行

# BEGIN, END
awk 'BEGIN {print "Start processing file"}
     NR<=5 {print $0}
     END {print "Finished processing file"}' file
```

#### awk 格式化输出

参考[c-printf](../program_language/c-cpp/cpp.md#printf-format)

```bash
# 使用printf
awk '{ printf("%-10s %-10s %-10s\n", $1, $2, $3) }' file.txt

# 拼接字符串
awk '{print $1"splitter"$2} file
```

#### 循环及条件语句

```sh
echo "1 2 3" | awk '{
    for(i=1; i<=NF; ++i) {
        if(i==1) {
            printf("=%s\n", $i);
        } else if(i==2) {
            printf("*%s\n", $i);
        } else {
            print $i;
        }
    }
}'
```

#### awk 数学运算

```bash
# 变量无需声明，默认值为 0
# 求和
awk '{sum += $1; sum += $2} END {print sum}' test.txt
```

数组(相当于python无序字典)

```bash
# 无需声明，value 默认值为 0
awk 'arr[$0]+=1 {} END {for(key in arr){print arr[key],key}}' file

# 打印出来的内容顺序随机
awk '{arr[i++]=$1} END {for (i in arr) print arr[i]}' test.txt

# 按行号打印
awk '{arr[NR]=$1} END {for(i=1;i<=length(arr);++i) print i, arr[i]}' test.txt
```

#### 示例

```bash
# 打印每行第二个单词
awk '{print $2}' test.txt

# 按冒号分隔
awk -F ':' '{print $1}' test.txt

# 按冒号分割为多行
echo "data1:data2:data3" | awk -F ':' '{for(i=1; i<=NF; i++) print $i}'

# 移除扩展名
echo "a.b.c" | awk -F. '{for(i=1;i<NF;++i){printf("%s", $i);if(i<NF-1){printf(".");}} printf("\n");}'

# 从start_pattern到end_pattern的多行数据替换为new_str
awk '/start_pattern/,/end_pattern/ {sub(/.*/, "hello");print}' test.txt

# 统计指定扩展名文件总行数
find . -name "*.txt" -exec wc -l {} +
find . -name "*.txt" -exec wc -l {} \; | awk '{sum+=$1}END{print sum}'
```

<a id='awk-tips'></a>
tips

```sh
# 当$1不在a中时，a[$1]=0，进行自加后为 1，由于是后置++，!取反的是进行++操作之前的对象 0，因此为真
# 当$1在a中时，a[$1]至少为1，取反后为假
# 只有当表达式为真，即$1不存在a中时才会触发默认打印行为
# 最终 a 中key为第一个单词，value为该单词出现次数
awk '!a[$1]++' file         # 只根据第一个单词去重
# 如果使用前置++则为
awk '++a[$1]==1' file         # 只根据第一个单词去重
```

## 软件

```bash
# 打开excel表格(xlsx)
xdg-open xxx.xlsx
gio open xxx.xlsx
soffice xxx.xlsx
libreoffice xxx.xlsx

# 打开图片
eog xxx.png
display xxx.png
```

文件搜索

[FSearch](https://mp.weixin.qq.com/s/UsWCI62f06pxhFRxcSxZqQ)

### apt/apt-get

apt 和 apt-get 对应关系

```text
apt 命令            取代的命令                命令的功能
apt install         apt-get install         安装软件包
apt remove          apt-get remove          移除软件包
apt purge           apt-get purge           移除软件包及配置文件
apt update          apt-get update          刷新存储库索引
apt upgrade         apt-get upgrade         升级所有可升级的软件包
apt autoremove      apt-get autoremove      动删除不需要的包
apt full-upgrade    apt-get dist-upgrade    在升级软件包时自动处理依赖关系
apt search          apt-cache search        搜索应用程序
apt show            apt-cache show          显示装细节
```

```sh
# 查看依赖关系
apt-cache rdepends libglvnd0
apt-cache showpkg libglvnd0
```

```bash
# 安装指定版本软件
sudo apt-get install <package>=<version>

# 查看可用软件版本
sudo apt-cache madison <package>

# 使用 apt-show-versions 列出软件所有版本，并查看是否已经安装
sudo apt-get install apt-show-versions
apt-show-versions -a <package>
```

```sh
# 一种安装 apt 包到指定目录的方式
apt download <package>                      # 下载 .deb 包
sudo dpkg --instdir=/install/dir tmp.deb    # 安装到指定目录
```

### dpkg

debian 系统的包管理器

```sh
dpkg [option...] action
    --instdir <directory>       : 指定安装目录，默认 /
    -s <package-name>           : 是否已安装
    -L <package-name>           : 安装了哪些文件
```

### pkg-config

* 查看已安装的库信息，库名为元文件 *.pc 去掉 .pc，元文件一般在下列位置
* 可以将 .pc 所在路径添加到 PKG_CONFIG_PATH 变量中

```txt
/usr/lib/pkgconfig
/usr/share/pkgcon‐fig
/usr/local/lib/pkgconfig
/usr/local/share/pkgconfig
```

```sh
--list-all                      :查看所有已安装库
--cflags --libs <lib_name>      :查看编译时如何使用库
--modversion <lib_name>         :只显示版本号
```

### ssh

```sh
sudo apt install openssh-server     # 安装 SSH 服务
sudo systemctl status ssh           # 查看服务状态
sudo systemctl start ssh            # 启动服务
sudo systemctl enable ssh           # 设置开机自启
```

#### ssh密钥登录

```bash
ssh-keygen     # 生成密钥，需要输入直接回车就行
# 添加公钥方法一
ssh-copy-id -i ~/.ssh/id_rsa.pub root@192.168.0.3
# 添加公钥方法二
cat ~/.ssh/id-rsa.pub   # 然后将复制内容添加到要登录主机的 ~/.ssh/authorized_keys

# 注意：要登陆的主机.ssh 及 authorized_keys只能自己有 读写 权限，家目录只能自己有 写 权限
```

## 其他

[去除Window行尾标记^M](https://www.cnblogs.com/rsapaper/p/15697099.html)

### 等待/获取用户输入

```bash
read    # 需要输入回车确认，信息被保存在 $REPLAY 中

read -p "提示信息" message  # 输入内容会存储到 $message 中
echo $message
```

### 查看及切换版本

```bash
# 以gcc为例
# 查看版本
ls /usr/bin/gcc*
# 为各个版本设定优先级
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 100
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 70
# 切换版本
sudo update-alternatives --config gcc
```

### 显示颜色/color

<https://blog.csdn.net/weixin_49439456/article/details/123746038>

```bash
# 30: 黑
# 31: 红
# 32: 绿
# 33: 黄
# 34: 蓝
# 35: 紫
# 36: 天蓝
# 37: 白
 
echo -e "\033[32m 绿色字 \033[0m"
 
```

### 格式化输出

```bash
printf "%s world" hello
```

### 列表/list/数组/array

```sh
list=(1 2 3)                        # 创建列表
list+=(4)                           # 追加元素
echo ${#list[@]}                    # 查看长度
echo ${list[0]}                     # 单个元素
echo ${list[@]}                     # 所有元素
unset list[0]                       # 删除元素
for num in ${list[@]}; do           # 遍历
    echo $num
done
```

### expr

#### 数学运算

expr 数学运算(只能计算整数，操作符两边必须有空格)

```bash
expr 3 + 5              # 8
expr 10 - 6             # 4
expr 3 \* 5             # 15
expr 10 / 2             # 5
expr 10 % 3             # 1
expr 3 \< 5             # 1
expr 3 \> 5             # 0
expr "abc" \< "def"     # 1
```

#### 截取字符串

```sh
# 使用正则表达式匹配，需要放在 \(\) 内捕获
# 不支持 +
expr "Hello World" : "\(H.*\)\s"    # Hello
echo "Hello World" | xargs -I {} expr {} : "\(H.*\)\s"
```

### echo

```sh
# 转义反斜杠，如将 \n 转义为换行符
echo -e "abc\ndef"
```

### declare

声明变量及其类型

```sh
declare var                         # 声明变量
declare var = 10                    # 声明时初始化

declare -A dic=([a]=1 [b]=2)        # 声明关联数组/字典/dict(无序)
dic[a]=9                            # 修改元素
dic[c]=3                            # 新增元素
echo ${dic[a]}                      # 查看单个元素值
echo ${!dic[@]}                     # 查看所有 key
echo ${dic[@]}                      # 查看所有 value
for key in ${!dic[@]}; do           # 遍历
    echo "$key: ${dic[$key]}"
done

# 试图修改时会报错并保留原值
declare -r con="Constant value"     # 声明只读变量
```

### ls

```sh
-S : 按文件大小降序
-r : 倒序
```

### yes

在中断之前不停打印字符串

```sh
# 生成 1024 行 1
yes 1 | head -n 1024
```

### mkdir

```sh
mkdir a
mkdir -p a/b/c

-p: 递归创建目录，目录已存在不报错
```

### xargs

为不能通过管道获取参数的命令提供管道功能，如:

```sh
ls | xargs echo
```

命令行选项

```sh
默认命令为 echo
-d  : 指定分隔字符，默认空白字符（空格，\t，换行），将输入拆成多个参数
-n  : 如 -n3 表示每条命令最多包含3个参数
-I  : 指定一个替换符号代表标准输入，如 %，在后续命令中用 % 代表标准输入内容
-t  : 打印实际执行的命令（方便调试）
```

示例

```sh
seq 1 10 | xargs -n3            # 分成 4(10/3) 组输出，最后一组只有一个参数
ls | xargs -I % echo % % %      # 打印三次
```

### uniq

只根据第n个单词去重参考 [awk-tips](#awk-tips)

```sh
uniq file           # 去除文件中相邻的重复行
```

### sort

[参考](https://zhuanlan.zhihu.com/p/373104953)

```bash
-b 忽略每行前面开始出的空格字符。从第一个可见字符开始比较。
-d 排序时，处理英文字母、数字及空格字符外，忽略其他的字符。
-f 排序时，忽略字符大小写.
-i 排序时，除了040至176之间的ASCII字符外，忽略其他的字符。
-c 检查文件是否已经按照顺序排序。
-m 将几个排序好的文件进行合并。
-M 前面3个字母依照月份的缩写进行排序。
-n 依照数值的大小排序。
-o <输出文件> 将排序后的结果存入指定的文件。
-r 降序排列（默认是升序）。
-t <分隔字符> 指定排序时所用的栏位分隔字符。
-k field1[,field2] 按指定的列进行排序。
-u 排序后相同的行只显示一次（默认按整行进行比较）
--help 显示帮助。
--version 显示版本信息。

# 默认以第一列排序，可以使用-k指定
# 使用-n时非数字等同于0
```

**注意**

* 默认排序不会忽略行首尾空格，使用-k时也不会忽略单词前后空格, 看起来单词前空格会作为单词的一部分，最后一个单词尾的空格会作为单词的一部分
* 使用 -b 选项可以忽略段首/单词首空格
* 行尾/单词尾空格可以使用 sed 's/\s*$//' 移除

```bash
# 对文件行进行排序并去重
sort test.txt | uniq

# 统计文件中单词个数/单词数量(文件中每行只有一个单词)
sort text.txt | uniq -c

# 从第二个字段的第一个字符开始直到第二个字段的结尾
sort -t : -k 2.1 /tmp/sort.txt

# 从第二个字段的第二个字符开始直到第三个字符
sort -t : -k 2.2,2.3 /tmp/sort.txt 

# 多级排序
# 第1级按第2列排序，第2级按第1列排序
sort -b -k 2 -k 1 test.txt

# test.py
# from itertools import product
# for p in product([1,2,3], repeat=3): 
#     print(' '.join([str(n) for n in p]))
python test.py | sort -k 1n -k 2nr -k3n
# 第1级按第1列数字升序
# 第2级按第2列数字降序
# 第3级按第3列数字升序
```

### alias

```bash
# 在bash alias中无法直接获取命令行参数，但可通过函数间接操作
# 如果命令行参数是目录则进入，否则进入文件所在目录
alias d='function _mycd(){ [ -d $1 ] && cd $1 || cd `dirname $1`; ls; };_mycd'

# 但是在csh中可以获取
# 如果命令行参数是目录则进入，否则进入文件所在目录
alias d 'test -d \!* && cd \!* || cd `dirname \!*`; ls'
```

### cut

```bash
cut [OPTIONS] FILE

# 截取第 3 到 5 个字符（从1开始数，包含3，5）
echo "example" | cut -c 3-5                 # amp

# 移除前两个字符
echo "example" | cut -c 3-                  # ample

# 保留前两个字符
echo "example" | cut -c -2                  # ex

# 移除最后 3 个字符
echo 'example' | rev | cut -c 4- | rev      # exam

# 使用空格作为分隔符拆分字符串并提取第2,4个part
# 分隔符仍会显示
echo '1 2 3 4' | cut -d ' ' -f 2,4
# 提取第2到4个part
echo '1 2 3 4' | cut -d ' ' -f 2-4
# 提取2-最后part
echo '1 2 3 4' | cut -d ' ' -f 2-
```

### seq

```bash
# 生成序列
seq [OPTION]... LAST
seq [OPTION]... FIRST LAST
seq [OPTION]... FIRST INCREMENT LAST

seq 5                   # 1 2 3 4 5
seq 0 5                 # 0 1 2 3 4 5
seq 0 2 5               # 0 2 4

seq -f "b%ge" 2         # b1e b2e
seq -f "b%2ge" 2        # 'b 1e', 'b 2e'
seq -f "b%02ge" 2       # 'b01e', 'b02e'

# -s 指定分隔符，默认 \n
seq -s '*' 5            # 1*2*3*4*5
```

### tee

```bash
# tee 不仅会将输出写入文件，还会写入标准输出
# 可写入多个文件
ls | tee a.txt b.txt

# 以追加方式写入
ls | tee -a a.txt b.txt
# 同时写入标准错误
ls 2>&1 | tee a.txt
```

### wc

```bash
wc -l test.txt          # 统计文件行数
wc -w test.txt          # 统计文件单词数(空格分割)
wc -c test.txt          # 统计文件字节数
wc -m test.txt          # 统计文件字符数(包含空白字符)

# 查看字符串长度
echo -n ssssssss | wc -c
```

### tr

```bash
# 将冒号替换为分号
echo 'a::b:c' | tr : ;          # output: a;;b;c

# 将冒号替换为分号，并且压缩相邻的字符
echo 'a::b:c' | tr -s : ;       # output：a;b;c

# 按冒号分割为多行
echo "data1:data2:data3" | tr : '\n'

# 删除指定字符
echo "a:b:c" | tr -d :
```

### head/tail

```bash
# 只显示第一行
head -n 1 <file>

# tail
# 不显示第一行
tail -n +2 <file>

# 只显示最后一行
tail -n 1 <file>

# 不显示最后一行
head -n -1 <file>

# 只显示第三行
head -n 3 <file> | tail -n 1
```

### reaklink

```sh
# 相对路径转换为绝对路径
readlink -f ./test.txt
获取当前脚本绝对路径: $(dirname `readlink -f $0`)   # source时无效
```

### crontab

```sh
# 定时执行文件中的任务
# 也可以通过 -e 打开命令列表直接添加
crontab <cron-expr-file>

# 查看当前用户任务列表
crontab -l
# 查看指定用户任务列表
crontab -u <user-name> -l

# 取消任务
crontab -e          # 删除要取消的任务后保存退出
```

```sh
# cron-expr: cron表达式
# week 0 表示周日，其他数字均从1开始
# * 表示不限制时间
<minute> <hour> <month> <date> <week> <file-to-execute>

# 每周六零时执行脚本
0 0 * * 6 /path/to/test.sh
```

### diff

|option | desc
|-  |-
|-w | 忽略所有空白字符
|-B | 忽略空行

```bash
# 比较两个文件
diff a.txt b.txt

# 根据返回值查看两个文件是否有不同
echo $?     # 0 表示相同，1 表示不同

# 忽略只有空白字符不同的行
diff -w a.txt b.txt
```

diff结果查看

```sh
diff结果如果有多出不一样会显示多次以下介绍内容

# 如果只有一行不一样，显示格式如下
# n1, n2分别表示在file1, file2中的行号
<n1>c<n2>
< line in file1
---
> line in file2

# 如果有多行不一样，显示格式如下
<n11,n12>c<n21,n22>
< line1 in file1
< line2 in file1
---
> line1 in file2
> line2 in file2

# 如果没有对应的行，显示格式如下
# 如file2中没有对应行
<n11,n12>d<n2>
< line1 in file1
< line2 in file1
```

### rsync

```sh
# 删除大文件夹
# 文件夹后的 / 不能去掉
mkdir empty && rsync --delete -d ./empty/ ./dir_to_delete/ && rm -r empty

# 复制目录时跳过指定子目录
rsync -av --exclude 'skipped_sub_dir/' source_dir target_dir
```

### 分析二进制文件

查看动态库是否是 debug 模式

```sh
file test.so        # 有 with debug_info 表示是 debug 模式
```

#### gdb

* 查看全局变量时只要加载了符号表，直接 print 即可

#### readelf

readelf 是一个用于分析 ELF 文件的命令行工具，可以查看各个节（section）的详细内容。

```bash
# 查看程序运行时动态库搜索路径
readelf -d app_or_so | head - 20
ldd app_or_so

# 查看动态库版本及依赖库版本信息
readelf -V app_or_so

# 查看编译动态库时的gcc版本
# 查看 .comment 节
# 当 test.so 依赖于多个库且编译这些库由GCC版本不同时，可能会显示多个版本 GCC
readelf -p .comment test.so
```

```sh
readelf -s a.out                # 查看符号表
# 第一列是 symbol 编号
# value 可能是内存地址
Num:    Value          Size Type    Bind   Vis      Ndx Name
 24: 0000000000004010     4 OBJECT  GLOBAL DEFAULT   25 abc
```

#### nm

nm 可以列出二进制可执行文件，动态库，静态库中的符号信息，包括符号的类型，符号名称，比如函数名，全局变量等

```sh
nm [options, ...] file
    -a      : 列出所有符号
    -D      : 只列出动态链接符号，只适用于动态库
```

符号类型表示含义:

* 大写一般表示全局可见，小写表示仅局部可见，如 static function

[字段含义](../program_language/c-cpp/cpp.md#内存布局)

|symbol |desc
|- |-
|B/b |BSS data section
|D/d |initialized data section
|N   |debugging symbol
|p   |stack unwind section
|R/r |readonly data section
|T/t |text(code) section (当函数为 t 时无法在外部调用该函数)
|U   |undefined symbol

#### objdump

```sh
objdump -h          # 查看是否有 debug 相关字段，如 .debug_info
```

通过符号表查看全局/静态变量默认值:

1. 查看符号表获取变量内存地址
2. 查看指定 section 对应内存地址中内容

```sh
objdump -t a.out        # 查看符号表，如函数，变量等
# SYMBOL TABLE 如下
# 第一列表示 symbol's value，对于变量是内存地址
# symbol 是 global(g) 还是 local(l)
# symbol 类型，O 表示对象/变量，F 表示函数
# symbol 所在内存区域
# symbol alignment 或 size
# symbol 名称
0000000000004010    g     O .data  0000000000000004    i_val
0000000000001149    g     F .text  000000000000002b    main

# 根据不同 section(内存区域) 查看变量默认值
objdump -s -j .data a.out
# 输出的第一列就是内存地址，后面是对应地址中实际的内容
# 地址 0x4010 对应的内容是 0x63000000，在小端法下是 99
 4000 00000000 00000000 08400000 00000000  .........@......
 4010 63000000                             c...
```

### xclip

[安装](../环境/linux.md#xclip)

### xsel

[安装](../环境/linux.md#xsel)

[检查 X11 环境](#x11)

xsel 默认针对的是 **X selection**(一般通过光标选中复制，按下鼠标中键进行粘贴)
通过 --clipboard 选项使用系统粘贴板(右键复制/粘贴)

```sh
# 移除换行符并复制到粘贴板，搭配管道使用，如 pwd | c
alias c 'tr -d "\n" | xsel -b'
```

```sh
echo 'test' | xsel -i   # 复制标准输出内容到缓冲区
xsel < file             # 将内容复制到缓冲区
xsel > file             # 将缓冲去内容保存到文件

xsel -a < file          # 追加到缓冲区

xsel -s < file          # 使用第二缓冲区
xsel -b < file          # 使用系统粘贴板
xsel --keep
```

### curl/wget

```sh
# 发送 http GET 请求
curl https://www.example.com
# 发送 http POST 请求
curl -X POST -d @data.json https://www.example.com

# 下载文件
wget https://www.example.com/file.zip
# 递归下载整个网站
wget --mirror --no-parent https://www.example.com
```

### watch 监测命令输出

每隔一定时间（默认2秒）自动执行命令并显示输出

```sh
watch ls -l
# -n <seconds>: 指定执行间隔
# -d: 显示两次输出差异(效果不好)
# -t: 不显示最上方一行的标题信息
# -b: 命令返回非零值发出蜂鸣
# -g: 两次输出不一致时自动退出

# 退出时执行命令
watch -g "ls -l" && echo "exit"
```

### dos2unix

将 CRLF 换行符文件转换为 LF

```sh
dos2unix file.txt
```

### rename 批量重命名

```sh
# 原理相当于对所有 files 名称使用 s/expression/replacement/
# 只有第一个匹配的 expression 会被替换
rename [options] expression replacement files
```

```sh
# 修改扩展名/后缀
# 将扩展名为 .ht 的文件改为 .html
rename .ht .html *.ht

# 对齐编号
# a1.txt ... a11.txt ... a111.txt -> a001.txt ... a011.txt ... a111.txt
rename a a00 a?.txt       # 有一个数字的加两个 0
rename a a0 a??.txt       # 有两个数字的加一个 0
```

### nslookup 查看域名ip

查看域名对应的ip地址

```sh
nslookup www.test.com
dig www.test.com
```

### iptables

不同链(chain)数据包流向

* INPUT: 进入本地
* OUTPUT: 发往服务器
* FORWARD: 系统内转发?

对数据包处理方式（man iptables-extensions查看更多）

* ACCEPT: 允许通过
* DROP: 丢弃

命令行选项

||||
| -- | :--          | :--
| -I | --insert     | 指定在哪条链插入规则(INPUT/OUTPUT)
| -D | --delete     | 从哪条链删除规则
| -s | --source     | 数据包从哪个地址过来
| -d | --destination| 数据包要到哪个地址
| -j | --jump       | 如何操作数据包(ACCEPT/DROP)

禁止访问特定网站(需要sudo权限)

```sh
# 屏蔽网站，会自动解析域名对应的ipv4地址，也可直接指定ip
# 实际屏蔽的是ip地址
iptables -I OUTPUT -d "www.test.com" -j DROP

# 查看iptables
iptables -L

# 恢复访问
# 如果使用域名恢复不了，可以改为ip地址
iptables -D OUTPUT -d "www.test.com" -j DROP
```

### DISPLAY 为其他用户创建终端

```sh
# 在目标用户主机开启显示权限
xhost +source_user@source_host      # 支持指定用户访问 X 服务器
xhost +                             # 支持所有用户
```

格式 hostname:display-number.scree-number

```text
hostname       : 主机ip地址
display-number : 显示端口号
screen-number  : 屏幕号
```

在Linux/Unix类操作系统中，DISPLAY环境变量用于设置将图形显示到何处，如果需要在远程计算机上运行图形程序， 可以将DISPLAY环境变量设置为远程主机的IP地址或主机名, 例如将DISPLAY环境变量设置为192.168.1.100:0.0，然后使用 konsole 打开一个终端。

### xdg-open(gio open)

xdg-open 是一个在 Linux 和其它 POSIX 兼容系统中使用的命令行工具，用于打开任意类型的文件或 URL。该命令会自动根据系统上安装的默认应用程序打开相应的文件或 URL，可以打开本地文件、远程文件以及通过网络协议（如 HTTP、FTP、mailto 等）指定的文件。xdg-open 命令实际上是一个桥接程序，它会尝试确定默认的应用程序，并将文件或 URL 传递给它们进行处理。

### 关闭终端提示音

```sh
# 以下命令都试一下
setterm -blength 0
xset b off
set bell-style none
set matchbeep = never
set nobeep=1
```

<a id="showkey"></a>

### showkey

```sh
# 查看键盘按键转换为ascii字符是什么
# 输入任意单个/组合按键，会显示对应的ascii字符，按 Ctrl-D 退出
showkey -a
```

### stat 文件元数据

[stat](https://blog.csdn.net/qq_42759112/article/details/126249990)

```sh
stat <file>

# 各项含义：
Size    : 文件实际字节数
Blocks  : 文件实际占用多少个 512 字节块
IO Block: 
Access  : 最后一次访问时间
Modify  : 最后一次修改文件内容时间
Change  : 最后一次修改文件元数据(权限等)时间
Birth   : 创建时间(有的文件系统没有，显示为 -), 复制出的文件Birth为复制时的时间而不是源文件时间
```

### df

```sh
# 查看硬盘使用情况
df -h

# 查看指定目录挂载的硬盘使用情况
df .

-h: 易读方式显示大小(T, G, M等单位，默认为 K)
```

### mount 查看文件系统

```sh
# 先根据 df -h . 查看挂载目录，如 /home 挂载在某个卷上
mount | fgrep /home         # 方式一
findmnt -no FSTYPE /home    # 方式二

nfs: Network File System，网络共享文件系统
```

```sh
# 重新挂载磁盘
mount -o remount,rw,relatime /path/to/mount
```

### who

查看所有登录用户，一个终端为一个登录

```sh
who
# 用户名    终端设备名    登录时间 (ip + DISPLAY)
user1       tty7        2023-10-11 09:51 (:0)                       # 本地登录
user2       pts/1       2023-10-11 09:51 (192.168.1.100:238.0)      # ssh登录并使用虚拟终端 pts/1
user3       pts/2       2023-10-11 09:51 (172.168.1.100)            # ssh登录并使用虚拟终端 pts/1，非图形界面
# pts 是指伪终端（pseudo terminal），通过SSH登录时系统会为用户分配一个pts(在文件系统中以 /dev/pts/X 的形式存在， X 是一个数字，代表伪终端设备的编号).

# 查看当前终端的pts值
tty         # /dev/pts/2
```

### apropos

根据命令中部分字符显示所有可能的命令

```sh
# 显示所有名称包含wh的命令
apropos wh

# 使用正则表达式查找
apropos . | egrep 'wh.*'
```

### uname

```sh
# 查看系统架构
uname -m
# 或
arch

# 查看操作系统详情
uname -a
lsb_release -a
```

### make

```sh
make -j$(nproc)         # 编译时使用所有 CPU
```

### script

```sh
# 新开启一个 shell 并将 stdin/stdout 同时记录到 session.log
# 执行 exit 退出
script session.log

# 有的不支持 -I,-O,-B
-I <file>   : 记录 stdin 到指定文件
-O <file>   : 记录 stdout 到指定文件，可以用来记录终端输出
-B <file>   : 记录 stdin, stdout

-c <cmd>    : 执行指定命令后自动退出
```

### xxd

```sh
xxd file            # 以十六进制形式显示文件内容
    -p      : 精简显示，只显示十六进制字符
    -c<N>   : 每行显示 N 字节

xxd -g 4 -c 16 tmp/vram.dump | awk '{print $1,$2,$3,$4,$5}' | head
# 显示为如下格式
# 00000000: 070040d8 150008c4 00008c30 0300c098
```

### hexdump

以十六进制(默认)，十进制，八进制或 ascii 形式显示文件

```sh
hexdump [options] file
    -C              : 同时输出十六进制和 ascii，逐字节显示
    -e <format>     : 指定显示格式
    -v              : 禁止压缩内容相同的行
    -n <N>          : 只输出前 N 个字节

    # 不指定 -e 时默认 2 字节为一组
    format: '<itreation_cnt>/<byte_cnt> "<format>"'
        itreation_cnt: 表示 format 被应用次数，默认 1
        byte_cnt     : 表示一次迭代处理字节数，默认 1
        format       : printf 风格的输出格式

# 每 4 字节为一组，按系统字节序输出
hexdump -v -e '/4 "%08x\n"' file
# 每 4 字节为一组，按系统字节序输出，每行输出 4 组，即 16 字节
hexdump -v -e '"%08_ax: " 4/4 "%08x " "\n"' file

# 按 ipv4 格式显示
hexdump -e '1/4 "%u." 1/4 "%u." 1/4 "%u." 1/4 "%u\n"' ip.bin
```

## tips

```bash
# ** 通常用于表示“任意多级目录”。它可以用于匹配当前目录及其子目录下的任意文件或者目录，而不需要关心它们的具体层级。
# 如下面的命令会列出当前目录及所有子目录中的 txt 文件
# 需要开启 ** 代表多级目录功能: shopt -s globstar
# 关闭：shopt -u globstar
# 查看是否开启：shopt globstar
ls **/*.txt
```

## QA

### 文件具有执行权限但是无法执行，报错: Permission denied

```text
通过mount命令查看挂载的文件系统
查看挂载的目录是否有noexec标志，如果有这个标志即使加了执行权限仍然不可执行
```

### 鼠标中键无法粘贴选中内容

```sh
echo 'XTerm*selectToClipboard: true' > ~/.Xdefaults
```

## XCB 图形界面

[XCB 文档](https://xcb.freedesktop.org)

[XCB API](https://xcb.freedesktop.org/XcbApi)

### 窗口事件

结构体(xcb_generic_event_t) 定义在 xcb.h 中

### lightdm 切换为 gdm3

```sh
sudo apt install gdm3
sudo dpkg-reconfigure gdm3              # 切换
sudo systemctl stop lightdm
sudo systemctl disable lightdm
sudo systemctl start gdm3               # 启用服务
sudo systemctl enable gdm3
cat /etc/X11/default-display-manager    # 查看默认管理器
sudo reboot
```

### X11 终端无法使用 GUI

```sh
sudo xhost +
```

## 概念

### ABI

Application Binary Interface: 即应用程序二进制接口。ABI 是操作系统、硬件架构和编译器之间的一组规范，定义了应用程序如何与系统库、动态链接库和其他系统组件进行交互。

### ELF TLS

ELF TLS（Thread-Local Storage）是指在 ELF（Executable and Linkable Format）文件格式中实现的线程局部存储机制。它允许每个线程有自己的独立变量副本，从而避免多线程环境中数据竞争和共享问题。

```c
// 声明 TLS 变量 ?
// 运行时环境（如操作系统或线程库）会维护一个指向当前线程的TLS区块的指针
thread_local __attribute__((tls_model("initial-exec"))) int var;
```
