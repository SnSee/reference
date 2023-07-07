# Linux

```bash
# 下载部分命令源码
git clone git://git.savannah.gnu.org/coreutils.git
```

## 1. 快捷键

光标

```text
ctrl + a: 跳到行首
ctrl + e: 跳到行尾
ctrl + u: 删除到行首
ctrl + k: 删除到行尾
ctrl + 方向键: 光标按单词移动
```

历史命令

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

## 2. 用户

```text
根据 uid 查询用户名: getent passwd uid
根据用户名查询 uid: id user_name
```

## 3. 文件

```bash
# 查看文件
inode: ls -i 或 stat file_name

# 查看文件个数
ll | wc -l
find ./ -name "*.cpp" | wc -l
```

### tar

```bash
# 基础用法
tar czvf test.tar.gz [--exclude ..] ./*

# 可选参数
--exclude 过滤指定文件或目录，可指定多次，只要打包时相对路径中包含指定内容即会过滤，可使用通配符
    --exclude build
    --exclude src/python/.idea
    --exclude test/*.txt
```

## 4. 进程

### 4.1. ps

```text
查看进程启动及运行时间: ps -eo pid,lstart,etime | grep 进程id
    pid: 进程id，可通过 `ps aux | grep app_name` 查找
    lstart: 启动时间
    etime: 运行时间
```

### 4.2. 脚本

```text
查看当前进程 id: echo $$
ls按时间排序:
    ls -lt  最新文件在前
    ls -lrt 相反
获取当前脚本绝对路径: $(dirname `readlink -f $0`)   # source时无效
```

### 4.3. top

[知乎](https://zhuanlan.zhihu.com/p/458010111)

```text
PID USER PR NI VIRT RES SHR S %CPU %MEM TIME+ COMMAND
PID : 进程号
USER: 用户名
PR  : 内核调度优先级
NI  : Nice值，影响PR
RES : 使用内存，包括swap内存和物理内存
VIRT: 使用物理内存
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
```

## 5. 版本

```text
查看发行版信息
    cat /etc/os-release
    cent-os: cat /etc/centos-release
```

## 6. 编程

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

## 7. 文件

### 7.1. locate

```text
locate <file_name> (支持wildcard)
```

### 7.2. find

```bash
# 按名称查找
find ./ -name "*.txt"
```

```bash
# 递归删除当前路径下所有名称及类型符合匹配条件的文件
find ./ -type {type} -name {name} | xargs rm -rf
find ./ -type {type} -name {name} -exec rm -rf {} \;
```

### 7.3. ncdu

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

## 8. shell编程(bash)

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
    return 1    # 返回(只能返回整数)
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

expr 数学运算(只能计算整数)

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
if [[ $s1 == $s2 ]] # 注意: 空格不能省略
if [[ $s1 != $s2 ]]
if [[ $s1 == ab* ]] # 可使用正则表达式
if [[ $s1 == ab"*" ]]   # *作为普通字符
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

## 9. 时间

```bash
# 显示当前时间
date

# 按固定格式显示时间
date +"%Y%m%d_%H%M"

# 显示程序耗时
time ./a.out
```

## 10. 环境变量

```bash
$SHELL                  # 当前shell类型
$PATH                   # 可执行文件查找路径
$HOME                   # 用户家目录
$USER                   # 用户名
$HOSTNAME               # 主机名($HOST)
$LD_LIBRARY_PATH        # 临时动态库查找路径
$PYTHONHOME             # python 家目录(默认lib及 site-package 路径)
$PYTHONPATH             # python 库搜索路径
```

## 11. 三剑客

### 11.1. grep

grep命令是一种文本搜索工具，可以用于在指定文件、标准输入或者其他命令的输出中查找匹配指定字符串模式的行。

命令行参数

```text
-i: 忽略大小写
-v: 显示不匹配行
-c: 仅显示匹配行数，不显示内容
-l: 只显示匹配文件名，不显示内容
-n: 显示行号
-r: 递归搜索
-w: 匹配整个单词, 而不是单词一部分
-e: 可多次指定匹配模式
-E: 使用正则表达式
-f: 从文件中获取匹配模式，文件中每行为一个模式
--exclude: 排除某些文件或目录
--include: 只匹配指定文件或目录
```

```bash
# 如果匹配模式中不包含特殊字符(空格，星号等)，可以不适用双引号括起来
grep test test.txt
grep "test1 test2" test.txt

# 匹配 不 包含test的行
grep -v test test.txt

# 指定多个匹配模式
grep -e Test -e test test.txt

# grep递归搜索指定扩展名文件
grep -r example /path/to/directory/ --include="*.txt"
# 开启了**功能(shopt -s globstar)
grep -r example /path/to/directory/**/*.txt
```

### 11.2. sed

如果要使用变量，使用eval调用sed

```bash
eval sed -i 's/${old}/${new}/g' test.txt
```

命令行参数

```text
-n: 不打印原文件内容
-i: 将修改应用到原文件
```

语法

```text
通过双引号或单引号内的内容定义行为
p: 打印
s: 替换
i: 当前行位置插入
a: 当前行下一行添加
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
```

### 11.3. awk

命令行参数

```bash
-F: 指定分隔符
```

语法

```text
通过定义在 '{ }' 中的内容定义行为
print: 打印
分隔符: 默认是空格
$1 分割后第一个部分(行首空格会自动忽略), $2 分割后第二个部分
```

特殊变量

```text
NR: 行号，从1开始
```

数学运算

```bash
# 求和
awk '{sum += $1; sum += $2} END {print sum}' test.txt
```

数组

```bash
# 打印出来的内容顺序随机
awk '{arr[i++]=$1} END {for (i in arr) print arr[i]}' test.txt

# 按行号打印
awk '{arr[NR]=$1} END {for(i=1;i<=length(arr);++i) print i, arr[i]}' test.txt
```

示例

```bash
# 打印每行第二个单词
awk '{print $2}' test.txt

# 按冒号分隔
awk -F ':' '{print $1}' test.txt

# 按冒号分割为多行
echo "data1:data2:data3" | awk -F ':' '{for(i=1; i<=NF; i++) print $i}'
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

```bash
# 安装指定版本软件
sudo apt-get install <package>=<version>

# 查看可用软件版本
sudo apt-cache madison <package>

# 使用 apt-show-versions 列出软件所有版本，并查看是否已经安装
sudo apt-get install apt-show-versions
apt-show-versions -a <package>
```

## 其他

[去除Window行尾标记^M](https://www.cnblogs.com/rsapaper/p/15697099.html)

ssh密钥登录

```bash
ssh-keygen     # 生成密钥，需要输入直接回车就行
# 添加公钥方法一
ssh-copy-id -i ~/.ssh/id_rsa.pub root@192.168.0.3
# 添加公钥方法二
cat ~/.ssh/id-rsa.pub   # 然后将复制内容添加到要登录主机的 ~/.ssh/authorized_keys

# 注意：要登陆的主机.ssh 及 authorized_keys只能自己有 读写 权限，家目录只能自己有 写 权限
```

等待/获取用户输入

```bash
read    # 需要输入回车确认，信息被保存在 $REPLAY 中

read -p "提示信息" message  # 输入内容会存储到 $message 中
echo $message
```

查看及切换版本

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

显示颜色

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

格式化输出

```bash
printf "%s world" hello
```

sort

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

```bash
# 对文件行进行排序并去重
sort test.txt | uniq

# 统计文件中单词个数(文件中每行只有一个单词)
sort text.txt | uniq -c

# 从第二个字段的第一个字符开始直到第二个字段的结尾
sort -t : -k 2.1 /tmp/sort.txt

# 从第二个字段的第二个字符开始直到第三个字符
sort -t : -k 2.2,2.3 /tmp/sort.txt 
```

alias

```bash
# 在bash alias中无法直接获取命令行参数，但可通过函数间接操作
# 如果命令行参数是目录则进入，否则进入文件所在目录
alias d='function _mycd(){ [ -d $1 ] && cd $1 || cd `dirname $1`; };_mycd'

# 但是在csh中可以获取
# 如果命令行参数是目录则进入，否则进入文件所在目录
alias d 'test -d \!* && cd \!* || cd `dirname \!*`'
```

cut

```bash
# 截取第 3 到 5 个字符（从1开始数，包含3，5）
echo "example" | cut -c 3-5                 # amp

# 移除前两个字符
echo "example" | cut -c 3-                  # ample

# 保留前两个字符
echo "example" | cut -c -2                  # ex

# 移除最后 3 个字符
echo 'example' | rev | cut -c 4- | rev      # exam
```

seq

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

tee

```bash
# tee 不仅会将输出写入文件，还会写入标准输出
# 可写入多个文件
ls | tee a.txt b.txt

# 以追加方式写入
ls | tee -a a.txt b.txt
```

wc

```bash
wc -l test.txt          # 统计文件行数
wc -w test.txt          # 统计文件单词数(空格分割)
wc -c test.txt          # 统计文件字符数(包含空白字符)
```

tr

```bash
# 将冒号替换为分号
echo 'a::b:c' | tr ':' ';'      # output: a;;b;c

# 将冒号替换为分号，并且压缩相邻的字符
echo 'a::b:c' | tr -s ':' ';'   # output：a;b;c

# 按冒号分割为多行
echo "data1:data2:data3" | tr ':' '\n'

# 删除指定字符
echo "a:b:c" | tr -d ":"
```

head/tail

```bash
# 只显示第一行
head -n 1 <file>

# 不显示第一行
tail -n +2 <file>

# 只显示最后一行
tail -n 1 <file>

# 不显示最后一行
head -n -1 <file>
```

diff

```bash
# 比较两个文件
diff a.txt b.txt

# 根据返回值查看两个文件是否有不同
echo $?     # 0 表示相同，1 表示不同

# 忽略只有空白字符不同的行
diff -w a.txt b.txt
```

readelf

> readelf 是一个用于分析 ELF 文件的命令行工具，可以查看各个节（section）的详细内容。

```bash
# 查看编译动态库时的gcc版本
# 查看 .comment 节
# 当 test.so 依赖于多个库且编译这些库由GCC版本不同时，可能会显示多个版本 GCC
readelf -p .comment test.so
```

为其他用户创建终端

> 在Linux/Unix类操作系统中，DISPLAY环境变量用于设置将图形显示到何处
> 如果需要在远程计算机上运行图形程序， 可以将DISPLAY环境变量设置为远程主机的IP地址或主机名, 例如将DISPLAY环境变量设置为192.168.1.100:0.0，然后使用 konsole 打开一个终端。

xdg-open

> xdg-open 是一个在 Linux 和其它 POSIX 兼容系统中使用的命令行工具，用于打开任意类型的文件或 URL。该命令会自动根据系统上安装的默认应用程序打开相应的文件或 URL，可以打开本地文件、远程文件以及通过网络协议（如 HTTP、FTP、mailto 等）指定的文件。xdg-open 命令实际上是一个桥接程序，它会尝试确定默认的应用程序，并将文件或 URL 传递给它们进行处理。

## tips

```bash
# ** 通常用于表示“任意多级目录”。它可以用于匹配当前目录及其子目录下的任意文件或者目录，而不需要关心它们的具体层级。
# 如下面的命令会列出当前目录及所有子目录中的 txt 文件
# 需要开启 ** 代表多级目录功能: shopt -s globstar
# 关闭：shopt -u globstar
# 查看是否开启：shopt globstar
ls **/*.txt
```

```bash
# 查看所有 SIGNAL 信号
man 7 signal
```

## QA

文件具有执行权限但是无法执行，报错: Permission denied

```text
通过mount命令查看挂载的文件系统
查看挂载的目录是否有noexec标志，如果有这个标志即使加了执行权限仍然不可执行
```
