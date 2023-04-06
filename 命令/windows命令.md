
# windows 命令

## 命令行参数

```docs
# 获取命令行参数
%0: bat脚本名
%1: 第一个参数
%2： 第二个参数
...

%~dp0: 获取脚本所在路径
```

## 注释

```bat
# 行首注释
REM 方式一，行首使用REM注释
:: 方式二，行首使用两个冒号注释

# 行间注释
% 要注释的内容 %

# 行尾注释
echo test &:: 注释内容
echo test & REM 注释内容
# 注意事项：echo时test后的空格也会打印出来

# 块注释
goto :label_name
注释1
注释2
...
:label_name
```

## 变量

```bat
# 创建变量
set var_name=test
# 访问变量
echo %var_name%
```

## 命令

```bat
pause       :: 按任意键继续
echo        :: 打印
echo off    :: 在此语句后所有运行的命令都不显示命令本身
@           :: 不显示本行命令本身
    @echo off   :: 本行及之后命令都不显示命令本身
call        :: 调用其他bat

takeown /f <文件路径>   :: 将文件所有者改为当前用户（需要管理员权限）
```

## 文件操作

```bat
:: 删除单个文件
del a.txt

:: 删除空目录
rd dir

:: 递归删除目录
rd /s/q dir
```

[winRAR参数介绍](http://t.zoukankan.com/shijiehaiyang-p-15749073.html)

```text
# 把 test文件夹 打包为 test.zip，忽略 test/.git
winRAR.exe a -x*\.git test.zip test
# 如果用bash调用，\需要转义，即: -x*\\.git
```

## 程序

结束任务管理器中结束不了的任务并强行删除

```dos
找到程序所在位置
修改程序名称，如加个 .a
命令行执行 Taskkill/im 程序名.exe /f
删除程序
删除动态库
```
