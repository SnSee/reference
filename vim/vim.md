
# vim

查看帮助文档: vim内 :h <关键字>

## 发行版

在vimrc中查看是否是gvim

```vim
if has('gui_running')
  " 在这里放置只对gvim有效的配置
else
  " 在这里放置只对终端版本的vim有效的配置
endif
```

## 外观

自定义主题

```text
将主题配色文件(xxx.vim)放到~/.vim/colors下即可引用

# 查看vim/gvim支持哪些公共主题
# 在vim/gvim窗口下打开目录
:e $VIMRUNTIME/colors/
```

```vim
" 显示颜色
syntax on

" 查看当前主题
colorscheme
" 设置主题
colorscheme default
```

## 文件跳转

```text
gf打开光标所在位置的文件
ctrl + ^ 回到上一个文件
ctrl + o 回到上一个位置，反之 ctrl + i (只适用于使用了vim跳转命令的情况)
:ls/buffers 查看打开的文件
:b1 跳转到buffers列出的编号为1的文件
:e fileName 打开文件
:e 刷新当前文件

m A             创建名为A的标签(mark)
' A             跳转到A标签
:delmarks A B   删除A和B标签
:delmarks!      删除所有标签
```

## 代码跳转

```text
使用 ctags -R ./ 生成跳转关系文件 tags (主要支持C语言，其他语言可能不准)
在需要跳转的地方 ctrl + ] 即可跳转，ctrl + o 返回
如果需要使用不在当前路径的tags，在~/.vimrc 中加上 set tags+=需要的tags全路径
```

## 折叠

查看vim自带帮助文档 :h Folding

```text
设置折叠模式 :set fdm=indent
设置打开文件时默认不折叠代码 :set foldlevelstart=99
可用折叠模式: manual, indent, expr, syntax, diff, marker
indent: 根据缩进折叠，每级缩进所需空格数由shiftwidth决定
syntax: 根据语法进行折叠，如c/c++，但能识别的语法较少
expr: 自定义折叠规则
    变量解释
        vim 在扫描每一行时，都会将行号存储至 v:lnum 变量
        getline(v:lnum)便可获得该行内容
    :set foldexpr=getline(v:lnum)[0]==\"\\t\"   "按tab折叠
    :set foldexpr=MyFoldLevel(v:lnum)           "调用自定义的折叠函数
    :set foldexpr=getline(v:lnum)=~'^\\s*$'&&getline(v:lnum+1)=~'\\S'?'<1':1    "按空行折叠
在括号处创建到匹配括号的折叠: zf%(需要marker模式)
```

折叠快捷键

```vim
zM 递归 折叠 整个文件
zR 递归 展开 整个文件
zC 递归 折叠 当前所在最近的作用域
zO 递归 展开 当前所在最近的作用域

zc 非递归 折叠当前所在最近的作用域
zo 非递归 折叠当前所在最近的作用域
```

[更多折叠快捷键](https://www.cnblogs.com/heartchord/p/4797996.html?ivk_sa=1024320u)

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

## 条件判断

```vim
if cond1
elseif cond2
else
endif
```

```vim
" 判断是否是gvim
if has("gui_running")
```

## 寄存器

```vim
最后一次复制的值会被存储到0寄存器中，通过"0p可以引用，删除操作不影响该寄存器
最新的复制和删除操作的值都会存储到1寄存器, 1寄存器中的值会存储的2寄存器中，以此类推，最多到9寄存器
```
