# Linux

## 1. 光标

```text
ctrl + a: 跳到行首
ctrl + e: 跳到行尾
ctrl + u: 删除到行首
ctrl + k: 删除到行尾
ctrl + 方向键: 光标按单词移动
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
```

## 5. 版本

```text
查看发行版信息
    cat /etc/os-release
    cent-os: cat /etc/centos-release
```

## 6. 编程

```text
查看程序运行时动态库搜索路径: readelf -d app_name | head - 20
查看动态库中有那些符号: strings test.so，如果要查找是否含有特定字符串，配合grep使用
```

## 7. 文件

### 7.1. locate

```text
locate <file_name> (支持wildcard)
```

### 7.2. find

```text
# 按名称查找
find ./ -name "*.txt"
```

```text
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

```text
睡眠: sleep, usleep
数组
    定义数组: arr=("1" "2" "3" "4")
    所有元素: ${arr[@]}
    数组长度: ${#arr[@]}
    访问数组: ${arr[index]}
    追加数据: arr[${arr[@]}]=element
let
    自加: let ++index
进度条
    printf "....\r" (最后的\r会把输出位置定位到本行行首)

重定向标准错误到标准输出
command > file 2>&1
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

解析命令行参数

[getopts](https://blog.csdn.net/solinger/article/details/89887155)

```bash
$#      # 获取命令行参数 个数(不包括脚本名)
$*      # 获取所有命令行 参数(不包括脚本名)
$@      # 获取所有命令行 参数(不包括脚本名)
$1      # 获取 第一个命令行参数(空格分隔)
```

[$@和$*区别](https://blog.csdn.net/f2157120/article/details/105649551)

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

## 9. 时间

```text
显示当前时间: date
显示程序耗时: time ./a.out
```

## 10. 环境变量

```bash
# 当前shell类型
$SHELL

# 可执行文件查找路径
$PATH

# 临时动态库查找路径
$LD_LIBRARY_PATH
```

## 11. 三剑客

### 11.1. grep

grep递归搜索指定扩展名文件

```bash
grep -r "example" /path/to/directory/ --include="*.txt"
```

### 11.2. sed

#### 11.2.1. 参数

```text
-n: 不打印原文件内容
-i: 将修改应用到原文件
```

#### 11.2.2. 语法

```text
通过双引号或单引号内的内容定义行为
p: 打印
s: 替换
```

#### 11.2.3. 示例

```bash
# 提取第2行
sed -n "2p" test.txt
# 提取第[2,5]行
sed -n "2,5p" test.txt
```

### 11.3. awk

#### 11.3.1. 参数

#### 11.3.2. 语法

```text
通过定义在 '{ }' 中的内容定义行为
print: 打印
分隔符: 默认是空格
$1 分割后第一个部分, $2 分割后第二个部分
```

#### 11.3.3. 示例

```bash
# 打印每行第二个单词
awk '{print $2}' test.txt
```

## 软件

```bash
# 打开excel表格(xlsx)
xdg-open xxx.xlsx
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
# 30:黑
# 31:红
# 32:绿
# 33:黄
# 34:蓝色
# 35:紫色
# 36:深绿
# 37:白色
 
echo -e "\033[32m 绿色字 \033[0m"
 
```
