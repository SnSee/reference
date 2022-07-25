
# vim

## 文件跳转

```text
gf打开光标所在位置的文件
ctrl + ^ 回到上一个文件
ctrl + o 回到上一个位置，反之 ctrl + i (只适用于使用了vim跳转命令的情况)
:ls/buffers 查看打开的文件
:b1 跳转到buffers列出的编号为1的文件
:e fileName 打开文件
:e 刷新当前文件
```

## 代码跳转

```text
使用 ctags -R ./ 生成跳转关系文件 tags (主要支持C语言，其他语言可能不准)
在需要跳转的地方 ctrl + ] 即可跳转，ctrl + o 返回
如果需要使用不在当前路径的tags，在~/.vimrc 中加上 set tags+=需要的tags全路径
```

## 字符串

### 查询字符串出现次数

```text
一般是 %s/<pattern>//gn，在vscode下使用 / ? * 查看时下方状态栏会显示总数
```

### 字符串替换使用正则表达式

```text
linux vim 捕获时的括号需要转义 \( \), vscode下不需要转义
通过 \1 \2 等来访问捕获的内容
示例
    把所有"abc...xyz"字符串替换成"xyz...abc"
        :%s/abc\(.*\)xyz/xyz\1abc/g         替换后的部分写死
        :%s/\(abc\)\(.*\)\(xyz\)/\3\2\1/g   替换后的部分使用捕获的内容
```

## 粘贴

```text
:set paste 粘贴时使用原有格式
:set nopaste 恢复
```

## 编码

```text
按十六进制显示
    :%!xxd
    :%!xxd -r 恢复默认
```
