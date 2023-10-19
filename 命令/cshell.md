
<!-- markdownlint-disable -->
# csh

<https://blog.csdn.net/gsjthxy/article/details/88363489>

```csh
# 创建变量
set name=value

# 创建别名
alias <别名> <原命令>

# 设置环境变量
setenv NAME value
setenv PATH "${PATH}:/usr/local/bin/python"

# 查看环境变量是否存在
$?VAR_NAME
# setenv | grep VAR_NAME
```

[重定向标准错误](https://qa.1r1g.com/sf/ask/2240761841/)

设置退出时自动执行命令(需要使用exit退出, 直接关闭tab页不行)

```sh
# 直接写入需要执行的命令即可
vim ~/.logout
```

## 光标

```csh
# 绑定 ctrl + 右方向键 到移动光标到单词尾下个字符
bindkey "^[[1;5D" backward-word
# 绑定 ctrl + 左方向键 到移动光标到单词头
bindkey "^[[1;5C" forward-word

# ctrl + w 删除至单词尾
bindkey "^W" delete-word
# ctrl + backspace 删除至单词头
bindkey "^H" backward-delete-word

# ctrl + u 删除到行首
bindkey "^U" backward-kill-line
```

## 语法

### if

```csh
if(xxx) then
else if(xxx) then
else
endif

if(xxx || xxx) then
endif

if(xxx && xxx) then
endif
```

```csh
# 判断文件是否存在
if( ! -e filename ) then
endif
```

```csh
# 数字比较
if ($num < 100) then
  @ num++
endif

# 判断字符串是否相同
if ($str1 == $str2) then
endif

# 模糊比较
if ($str1 =~ "*.txt") then
endif
```

### while

```csh
while(xxx)
  continue
  break
end
```

### foreach

```csh
foreach var (wordlist)
  continue
  break
end
```

### 数学运算

```csh
set num = 0
@ num++     # @后必须有空格
```

## 示例

判断是否是空字符串/字符串为空

```csh
set str=""
if("$str" == "") then
    echo "empty"
endif
```

```csh
set str=`which command`
set found=`test -n "$str" && echo 1 || 0`
if($found) then
    echo "empty"
else
    echo "not empty"
endif
```

字符串替换

```csh
# 借助sed
set str="foo is foo"
set str=`echo $str | sed 's/foo/bar/g'`
echo $str
```

## 命令

> time

csh的time是shell内置命令。

```sh
time sleep 2
# 输出：0.001u 0.003s 0:02.01 0.4%      0+0k 0+0io 0pf+0w
```

| 输出  | 含义 |
| --    | -- |
|0.001u | 用户模式cpu时间, u表示user，单位：秒
|0.003s | 内核模式cpu时间, s表示system，单位：秒
|0:02.01| 总运行时间
|0.4%   | 该命令cpu使用率占比
|0+0k   | 分配内存，数字分别表示个数和总大小，k表示单位为KB
|0+0io  | 输入输出，数字分别表示次数及数据量(KB)
|0pf+0w | 页面错误(page faults)和交换活动(swaps)数量<br>page faults: 是指程序访问的页不在内存中，需要从磁盘上获取

page faults: 是指程序访问的页不在内存中，需要从磁盘上获取
