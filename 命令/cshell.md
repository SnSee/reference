
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
```

[重定向标准错误](https://qa.1r1g.com/sf/ask/2240761841/)

## 光标

```csh
# 绑定 ctrl + 右方向键 到移动光标到单词尾下个字符
bindkey "^[[1;5D" backward-word
# 绑定 ctrl + 左方向键 到移动光标到单词头
bindkey "^[[1;5C" forward-word
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

判断是否是空字符串

```csh
set str=""
if($str == "") then
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
