
# vim

[vim官网](https://www.vim.org/)

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

查看vim版本及配置信息

```vim
:version
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

## 模式

```vim
普通模式(Normal): 可使用快捷键，如 hjkl 等
插入模式(Insert): 输入文本
可视模式(Visual): v/Ctrl+v 进入，选中多行或多行多列字符
命令行模式(Command-line): 按 : 后输入命令
```

## 快捷键

```vim
" 按下该键后再按其他按键触发组合快捷键（不用同时按）
let mapleader = "," 

" 命令互换
nnoremap <C-C> <C-V>
nnoremap <C-V> <C-C>

" 设置 Alt 组合键
nnoremap <M-o> <C-o>
" 如果不行，在insert模式下先按 Ctrl+V, 再按 Alt + key
" 显示效果如下
nnoremap ^[] <C-]>
nnoremap ^[o <C-o>
" 不能设置 ]
" nnoremap ^[i <C-]>

" 切换分屏
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" 切换tab页
nnoremap <leader>l :tabn<CR>
nnoremap <leader>h :tabp<CR>
```

## 分屏（多窗口）

打开为两个窗口

```sh
# 横向分屏
vim -o a.txt b.txt

# 竖向分屏
vim -O a.txt b.txt
```

窗口跳转: 先按下 ctrl + w, 然后按 hjkl

窗口尺寸调节

```text
# n 是数字，默认为 1，表明增减行列数
ctrl+w [n]+: 增大高度
ctrl+w [n]-: 减小高度
ctrl+w [n]>: 增大宽度
ctrl+w [n]<: 减小宽度
ctrl+w =   : 子窗口均分主窗口
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
:delmark A B    删除A和B标签
:delmark A-Z    删除所有标签
```

比较文件

```bash
# ]c 跳转到下个不同的地方
# [c 跳转到上个不同的地方

# :set diffopt+=iwhiteall 忽略只有空白字符不同的行
# 通过 : h diffopt 查看更多比较选项
vim -d test1.txt test2.txt

# 如果已经打开一个文件
# :vert diffsplit test2.txt

# 如果连个文件已经打开为两个窗口
# 分别在每个文件中 :diffthis
```

## 代码跳转

```text
使用 ctags -R ./ 生成跳转关系文件 tags (主要支持C语言，其他语言可能不准)
在需要跳转的地方 ctrl + ] 即可跳转，ctrl + o 返回
如果需要使用不在当前路径的tags，在~/.vimrc 中加上 set tags+=需要的tags全路径
```

## 折叠

查看vim自带帮助文档 :h Folding

```vim
" 可用折叠模式: manual, indent, expr, syntax, diff, marker
set foldmethod=indent           " 设置折叠模式
set foldlevelstart=99           " 设置打开文件时默认不折叠

" 根据 {} 折叠
set foldmethod=marker
set foldmarker={,}

" indent: 根据缩进折叠，每级缩进所需空格数由shiftwidth决定
" syntax: 根据语法进行折叠，如c/c++，但能识别的语法较少
" expr: 自定义折叠规则
"     变量解释
"         vim 在扫描每一行时，都会将行号存储至 v:lnum 变量
"         getline(v:lnum)便可获得该行内容
"     set foldexpr=getline(v:lnum)[0]==\"\\t\"   "按tab折叠
"     set foldexpr=MyFoldLevel(v:lnum)           "调用自定义的折叠函数
"     :set foldexpr=getline(v:lnum)=~'^\\s*$'&&getline(v:lnum+1)=~'\\S'?'<1':1    "按空行折叠
" 在括号处创建到匹配括号的折叠: zf%(需要marker模式)
```

折叠快捷键

```vim
zM 递归 折叠 整个文件
zR 递归 展开 整个文件
zC 递归 折叠 当前所在最近的作用域，只能向上递归父节点
zO 递归 展开 当前所在最近的作用域

zc 非递归 折叠当前所在最近的作用域
zo 非递归 折叠当前所在最近的作用域

zMzv 近似实现递归折叠子节点，但是由于使用了zM，其他所有节点都会被折叠
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

```vim
:set paste 粘贴时使用原有格式
:set nopaste 恢复
```

在多行后粘贴同样行数数据

```text
1.使用 VISUAL 模式选中要复制的多行数据，按 y 复制
2.使用 VISUAL 模式在要粘贴的位置选中同样行数，按 p 粘贴
```

## 编码

```text
按十六进制显示
    :%!xxd
    :%!xxd -r 恢复默认

查看/隐藏不可见字符
    :set list
    :set nolist
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
" 查看所有寄存器
:reg
" 查看a寄存器
:reg a
```

```vim
最后一次复制的值会被存储到0寄存器中，通过"0p可以引用，删除操作不影响该寄存器
最新的复制和删除操作的值都会存储到1寄存器, 1寄存器中的值会存储的2寄存器中，以此类推，最多到9寄存器
```

## 重复操作

宏

```vim
1.宏会记录用户所有按键操作
2.录制宏: q + a-z(非q) 将宏绑定到快捷键，如 qa, 在 Normal-mode 下按 q 结束录制
3.重复宏: @ + a-z, 如 @a 将会执行宏录制的所有按键操作, 使用 <n>@a 将会重复 n 次
```

.

```vim
重复上次修改操作:
1.从Normal到Insert再回到Normal算一次修改
2.使用d/p修改
```

## tips

```vim
# 删除所有匹配行
:g/regex_pat/d
```

## 插件

[插件查找网站](https://vimawesome.com/)

[vim-plug](https://github.com/junegunn/vim-plug)

```sh
# 在线安装插件根据vim-plug教程即可
# 离线安装插件(使用vim-plug)
1. mkdir ~/.vim/autoload
2. 将教程中的 plug.vim 放到 autoload 中
3. mkdir ~/.vim/plugged
4. 在github上下载nerdtree zip包，解压到 plugged，改名和 .vimrc 中名称一致
5. 将如下的插件配置添加到 ~/.vimrc, 需要安装的插件通过 Plug 添加
6. 重新啊打开vim执行 :PlugInstall 安装
```

```vim
call plug#begin('~/.vim/plugged')

" 目录树
Plug 'preservim/nerdtree'

" 显示最近打开的文件/目录
Plug 'mhinz/vim-startify'

" 自动补全
Plug 'valloric/youcompleteme'
Plug 'ervandew/supertab'

call plug#end()
```

> [nerdtree](https://github.com/preservim/nerdtree)

```vim
" 打开/关闭nerdtree
" 打开目录时会自动进入nerdtree
nnoremap <silent> <leader>n :NERDTreeToggle<CR>
```

```text
" 查看/退出帮助文档
?

# 目录操作
o: 打开/关闭光标处目录
O: 打开目录（递归）
x: 关闭光标处所在目录
X: 关闭光标处目录所有子目录(递归), 只打开一级子目录

# 文件操作
i: 打开文件(split出窗口)
o: 打开文件(多文件方式，会覆盖当前窗口)
t: 打开文件(tab页方式并切换到新打开的tab)
T: 打开文件(tab页方式但不切换)
```

> [startify](https://github.com/mhinz/vim-startify)

```sh
# 直接vim即可
# 打开后直接输入文件对应数字，或在数字位置按enter打开文件
vim
```

> [youcompleteme](https://github.com/ycm-core/YouCompleteMe)

需要编译

```sh
# 下载安装包
git clone https://github.com/ycm-core/YouCompleteMe
# 更新子模块
git submodule update --init --recursive
# 打包上传到无网环境后解压
# 编译
```
