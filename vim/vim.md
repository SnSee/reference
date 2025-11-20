
# vim

[vim官网](https://www.vim.org/)

查看帮助文档: vim内 :h <关键字>

[关键字配置项简介](http://runxinzhi.com/fengchi-p-6902965.html)

![vim键盘图](./pics/vim-cheat-sheet-sch1.gif)

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

## 升级

```sh
# 添加 PPA 仓库安装最新 Vim
sudo add-apt-repository ppa:jonathonf/vim
sudo apt update
sudo apt install vim

# 或者安装 vim-gtk3（功能更完整）
sudo apt install vim-gtk3
```

## 外观

### 主题

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
" 设置主题，可用 tab 补全
colorscheme default
```

[sublimemonokai](./colors/sublimemonokai.vim)
[monokai](https://github.com/ku1ik/vim-monokai/blob/master/colors/monokai.vim)

### 高亮

```vim
" 查看当前颜色配置
:hi
:hightligth
" 设置搜索高亮配色
:highlight Search gui=NONE guibg=yellow guifg=black
```

### 光标

```vim
" 设置 nvc 模式下块状光标，i 模式下竖线光标
" 光标闪烁，亮灭各 650 毫秒，等待 600 毫秒后开始闪烁
set guicursor=n-v-c:block-blinkon650-blinkoff650-blinkwait600
set guicursor+=i:ver25-blinkon650-blinkoff650
set guicursor+=r:hor20-blinkon650-blinkoff650
```

## 模式

```vim
普通模式(Normal): 可使用快捷键，如 hjkl 等
插入模式(Insert): 输入文本
可视模式(Visual): v/Ctrl+v 进入，选中多行或多行多列字符
命令行模式(Command-line): 按 : 后输入命令
```

## 快捷键

通过 [showkey](../命令/linux.md#showkey) 命令查看组合键实际对应的 ascii 字符串

|模式 |描述
|- |- |
|i |insert
|n |normal
|v |visual
|c | command / search

```text
Ctrl不能和Shift组合时没有Shift也能触发快捷键？如 <C-S-V> 按 Ctrl + v 一样触发
insert模式退出到normal模式: <C-\><C-n>
```

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
" nnoremap ^[] <C-]>

" 切换分屏
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" 切换tab页
nnoremap <leader>l :tabn<CR>
nnoremap <leader>h :tabp<CR>

" insert/command/search 使用系统粘贴板
" normal 使用 "+p 即可
cnoremap <C-S-V> <C-R>+
inoremap <C-S-V> <C-R>+
cnoremap <C-v> <C-R>+
inoremap <C-V> <C-R>+

" 复制光标所在位置单词到系统粘贴板
nnoremap <C-C> "+yiw
inoremap <C-C> <C-\><C-n>"+yiw

" 设置 Ctrl + Backspace 键来删除前方的一个单词
inoremap <C-BS> <C-W>
cnoremap <C-BS> <C-W>

" 运行当前文件
nnoremap <S-F10> :w<CR>:!./%<CR>
inoremap <S-F10> <C-\><C-n>:w<CR>:!./%<CR>
```

### z

```sh
zt          # 将当前行置于屏幕顶部，受 scrolloff 影响
zb          # 将当前行置于屏幕底部
```

## vim 编程

### 内置函数

```sh
help function-list        # 查看内置函数
```

|func |通常用法 |desc
|- |- |-
|line         |line('.')                    |光标所在行号，从 1 开始
|col          |col('.')                     |光标所在列号，从 1 开始
|getline      |getline('.')                 |当前行内容
|setline      |setline(10, 'ABC')           |修改第10行
|match        |match('testing', 'ing')      |返回的索引从 0 开始
|match        |matchend('testing', 'ing')   |返回最后一个匹配位置的索引
|matchstr     |matchstr('testing', 'ing')   |返回匹配的字符串而不是索引
|strpart      |strpart('12345', 1, 3)       |截取 3 个字符(索引从 0 开始)

### if

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

### for

```sh
# 命令模式下为每行行首插入数字
for i in range(0, 9)
  exe '.s/^/'.i       # 前一个 . 指当前行，后一个是字符串连接符
  normal! j
endfor
```

### normal

```sh
# 执行 normal 模式的命令，对于被 noremap 的指令，执行 mapping 后的
:normal j
# 不受 mapping 影响
:normal! j
```

### getreg

```sh
# insert 模式下 Ctrl-R 然后按 = 可以计算寄存器内容后粘贴
# 如: 对上次输入的数字自增后输出，可搭配宏使用
=getreg('.') + 1
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

## tab页

```vim
:tabe test.txt          " 打开tab页
:tabc                   " 关闭当前tab页

" 切换tab页
nnoremap <leader>l :tabn<CR>
nnoremap <leader>h :tabp<CR>
```

## 查找/搜索

[pattern转义](#转义magicnomagic)

```vim
/{pattern}    向后查找
?{pattern}    向前查找
*             向后查找光标处单词，等同于 /\<{word}\>
g*            向后查找光标处单词，等同于 /{word}
#             向前查找光标处单词，等同于 ?\<{word}\>
g#            向前查找光标处单词，等同于 ?{word}
n             查找后按 n 查找下一个
N             查找后按 N 查找上一个
```

### 查看历史记录

```vim
; jk浏览即可
:history /
```

### regex

```vim
/\v(pre_pat)@<=match_pat        " 正向先行断言(pre_pat 满足才能匹配上)
/\v(pre_pat)@<!match_pat        " 负向先行断言(pre_pat 不满足才能匹配上)
```

### 高亮

```vim
:set hlsearch         " 高亮显示搜索结果, nolhsearch
:set incsearch        " 显示查找匹配过程, noincsearch
:nohl                 " 取消当前高亮
```

## 跳转

### 文件跳转

```text
gf打开光标所在位置的文件
ctrl + ^ 回到上一个文件
<N>ctrl + ^ 跳转到编号为N的文件
ctrl + o 回到上一个位置，反之 ctrl + i (只适用于使用了vim跳转命令的情况)
:ls/buffers 查看打开的文件
:b1 跳转到buffers列出的编号为1的文件
:e fileName 打开文件
:e 刷新当前文件

# 大写字母可以在文件间跳转，小写字母只能文件内跳转
m A             创建名为A的标签(mark)
' A             跳转到A标签行首
` A             跳转到a标签创建标签位置
:delmark A B    删除A和B标签
:delmark A-Z    删除所有标签
```

### 文件内跳转

```vim
f<C>     向后查找字符，找到后跳转，按 ; 跳转到下一下，按 , 跳转到前一个
F<C>     作用同 f，方向相反
t<C>     向后查找，到指定字符 前 一个字符
T<C>     向后查找，到指定字符 后 一个字符
gg       文件头
G        文件尾
0        行头
^        非空白字符的行头
$        行尾
w        下个单词头
b        上个单词头
e        当前单词尾
W        下个空格后非空格头
B        上个空格前非空格头
E        下个空格前非空格尾
}        下个空行
{        上个空行
)        如果在空行，跳到下个非空首行；如果在非空行，跳到下个空行
(        如果在空行，跳到上个非空首行；如果在非空行，跳到上个空行
%        在括号位置跳转到对应括号
:<line>  跳转到指定行号
<line>gg 跳转到指定行号
<line>G  跳转到指定行号
ctrl+f   向下翻页
ctrl+b   向上翻页
ctrl+u   向上滚动半页(光标位置不变)
ctrl+d   向下滚动半页(光标位置不变)
ctrl+y   向上滚动一行(光标所在行不变)
ctrl+e   向下滚动一行(光标所在行不变)
H        跳转到屏幕内靠上方的行
L        跳转到屏幕内靠下方的行
M        跳转到屏幕最中间的行
```

**复制(y)和删除(d)等操作可以和跳转符号连用**

```sh
dG        删除当前行及之后所有行
d$        删除至行尾
df<C>     向后删除至指定字符
dF<C>     向前删除至指定字符
d<line>G  删除当前行至指定行，包括这两行
```

### 代码跳转

```text
使用 ctags -R ./ 生成跳转关系文件 tags (主要支持C语言，其他语言可能不准)
在需要跳转的地方 ctrl + ] 即可跳转，ctrl + o 返回
如果需要使用不在当前路径的tags，在~/.vimrc 中加上 set tags+=需要的tags全路径
```

## 比较文件

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

## 折叠

查看vim自带帮助文档 :h Folding

```vim
" 可用折叠模式: manual, indent, expr, syntax, diff, marker
set foldmethod=indent           " 设置折叠模式
set foldlevelstart=99           " 设置打开文件时默认不折叠

" 根据 {} 折叠
set foldmethod=marker
set foldmarker={,}

" 手动设置折叠范围
set fdm=manual
:<start_line>,<end_line>fold

" indent: 根据缩进折叠，每级缩进所需空格数由shiftwidth决定
" syntax: 根据语法进行折叠，如c/c++，但能识别的语法较少
" expr: 自定义折叠规则
"     变量解释
"         vim 在扫描每一行时，都会将行号存储至 v:lnum 变量
"         getline(v:lnum)便可获得该行内容
"     set foldexpr=getline(v:lnum)[0]==\"\\t\"   "按tab折叠
"     set foldexpr=MyFoldLevel(v:lnum)           "调用自定义的折叠函数
"     :set foldexpr=getline(v:lnum)=~'^\\s*$'&&getline(v:lnum+1)=~'\\S'?'<1':1    "按空行折叠
" 在括号处创建到匹配括号的折叠: zf%(需要marker/manual模式)
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

" zf/fo 在marker模式下会修改文件，因此不推荐使用，manual模式可以使用
" 为visual行创建折叠
{visual}zf 
" 为指定行创建折叠
:1,2fo
```

[更多折叠快捷键](https://www.cnblogs.com/heartchord/p/4797996.html?ivk_sa=1024320u)
[vscode按j自动打开折叠问题](../vscode/vscode.md#vim-foldopen)

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

## 复制/粘贴

```vim
:set paste 粘贴时使用原有格式
:set nopaste 恢复
```

复制多行

```vim
5yy       复制 5 行，不指定则为 1 行
:1,5y+    复制 1-5 行到 + 寄存器，不指定则使用默认寄存器
```

在多行后粘贴同样行数数据

```text
1.使用 VISUAL 模式选中要复制的多行数据，按 y 复制
2.使用 VISUAL 模式在要粘贴的位置选中同样行数，按 p 粘贴
```

系统粘贴板

```text
"+y  : visual模式下复制选中内容到系统粘贴板
"+yw : normal模式下复制单词到系统粘贴板
"+p  : normal模式下从系统粘贴板粘贴
```

## 转义(magic/nomagic)

:h magic 查看

[知乎](https://zhuanlan.zhihu.com/p/143260180)

特殊字符使用 \ 转义为普通字符
普通字符使用 \ 转义为特殊字符

|匹配前缀 | 特殊字符 | 普通字符|
| -  | -      | -
| \m | ^$.*[] | others
| \M | ^$     | others
| \v | others | a-zA-Z0-9_
| \V | \      | others

**\V** 中 **结束标记** 也是特殊字符，如 s 命令的 /

```vim
# 将 () 当做特殊字符
/\v(1|2)                    " 搜索
:%s/\v(1|2)/3/g             " 替换
```

## 编码

设置编码格式

```vim
set encoding=UTF-8
set fileencoding=UTF-8
```

```text
按十六进制显示
    :%!xxd
    :%!xxd -r 恢复默认

查看/隐藏不可见字符
    :set list
    :set nolist
```

## shell终端交互

### 读取 shell 命令输出内容并插入到下一行

```vim
" vim 不支持系统粘贴板时借助 xsel 获取系统粘贴板并插入
nnoremap <C-P> :set paste<CR>:read !xsel --output --clipboard<CR>:set nopaste<CR>
```

## visual mode

```sh
# 将选中的内容写入文件/写出到文件
# 选中后直接进入命令模式，输入 w 命令即可
:'<,'>w output
```

## 寄存器

```vim
" 查看所有寄存器
:reg
" 查看a寄存器
:reg a
```

下面的示例用 x 表示寄存器名称

|模式 |操作 |描述
|- |- | -
|normal |qx<宏内容>q | 创建宏
|normal |@x         | 应用宏
|normal |"xyy       | 复制当前行到寄存器
|normal |"xp        | 从寄存器中粘贴
|insert | ctrl+R x  | 从寄存器粘贴

寄存器分类(:h registers)

|寄存器名称 |寄存器作用
|-  | -
|"  | 默认寄存器，记录最后一次删除/复制内容
|0  | 默认寄存器，记录最后一次复制内容
|1  | 默认寄存器，记录最后一次删除内容(有换行符)
|2-9| 每新增删除内容，删除内容在寄存器间移动，如 1->2, 2->3
|-  | 默认寄存器，记录最后一次删除内容(无换行符)
|+  | 系统粘贴板
|*  | visual 模式粘贴板，记录选中内容
|a-z| 自定义寄存器，如果用 A-Z 表示追加内容到寄存器而不是替换
|.  | readonly，记录最后一次插入内容(从进入 insert 模式到退出输入内容)
|%  | readonly，记录当前文件名
|:  | readonly，记录最后一次执行命令
|=  | 表达式寄存器
|#  | 记录 ctrl-^ 跳转文件名
|/  | 记录通过 /?* 等方式搜索内容
|_  | 黑洞寄存器，不记录任何内容

最后一次复制的值会被存储到 **0寄存器** 中，通过 **"0p** 可以引用，删除操作不影响该寄存器
最新的复制和删除操作的值都会存储到1寄存器, 1寄存器中的值会存储的2寄存器中，以此类推，最多到9寄存器

## 重复操作

### 宏

```vim
1.宏会记录用户所有按键操作
2.录制宏: q + a-z(非q) 将宏绑定到快捷键，如 qa, 在 Normal-mode 下按 q 结束录制
3.重复宏: @ + a-z, 如 @a 将会执行宏录制的所有按键操作, 使用 <n>@a 将会重复 n 次
```

### 点(.)

```vim
重复上次修改操作:
1.从Normal到Insert再回到Normal算一次修改
2.使用d/p修改
3.缩进
```

### @

```vim
" 重复执行上一条命令
@:
```

## 兼容性设置

cpo(cpoptions)

letter 及对应含义通过 **:h cpo** 查看

```vim
# 添加设定
set cpo+=<letter>
# 减少设定
set cpo-=<letter>
```

## 命令

### ! 执行 shell 命令

```vim
" 将文件内容作为 command 命令的输入，然后将文件内容替换为其输出
" % 指整个文件，也可指定范围
:%!command

" 将 2-5 行作为 command 的输入，然后将 2-5 行替换为其输出
:2,5!command
```

### set

```sh
set scrolloff=0           # 设置光标到屏幕上下边缘最小行数
set wrap                  # 自动换行
set nowrap                # 不自动换行
```

### his/history

```vim
history <类型>
```

|类型 | desc
|- |-
|c :  | 命令
|s / ?| 搜索记录

### g/global

#### normal 模式

```vim
gg        跳转到第一行
G         跳转到最后一行
<line>G   跳转到指定行
gf        跳转到光标处文件
g*        等同于不带 \<\> 的 *
g#        等同于不带 \<\> 的 #
ga        打印光标处字符 ascii 码（十进制，十六进制，八进制）
g<        查看上一条命令的输出
```

#### command 模式

对匹配的行进行操作，默认为打印(:p)

```text
:[range]g/{pattern}/[cmd]  对范围内所有匹配行执行命令
:[range]g!/{pattern}/[cmd] 对范围内所有 不 匹配行执行命令
```

```vim
" 删除所有匹配行
:g/regex_pat/d

" 删除空行
:g/^\s*$/d

" 移动所有匹配行到指定行的下一行
" 由于后匹配到的行后移动，所有会和原有相对顺序相反
:g/{pattern}/m <line>
```

## tips

```vim
" 压缩连续空行
:%s/^\s*$//g                " 先删除只有空白字符的行中的空白字符
:%s/\v^\n{2,}/\r/g          " 只保留第一个空的换行符，替换时需要使用 \r 而不是 \n

" 显示/打印当前文件绝对路径
:echo expand('%:p')
" 定义快捷命令
:command! Pwd echo expand('%:p')
```

### 插入文件

```vim
" 在光标处插入文件内容
:r file.txt

" 在光标处插入命令输出
:r! command
```

## 插件

[插件查找网站](https://vimawesome.com/)

[vim-plug](https://github.com/junegunn/vim-plug)

```sh
# 安装 vim-plug 插件管理器
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

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

### nerdtree

[github](https://github.com/preservim/nerdtree)

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

### startify

[github](https://github.com/mhinz/vim-startify)

```sh
# 直接vim即可
# 打开后直接输入文件对应数字，或在数字位置按enter打开文件
vim
```

### youcompleteme

[github](https://github.com/ycm-core/YouCompleteMe)

需要编译

```sh
# 下载安装包
git clone https://github.com/ycm-core/YouCompleteMe
# 更新子模块
git submodule update --init --recursive
# 打包上传到无网环境后解压
# 编译
```

### coc

```vim
Plug 'neoclide/coc.nvim', {'branch': 'release'}

:CocInfo                        " 安装后查看是否有异常
:CocConfig                      " 打开配置文件
:CocInstall coc-clangd          " 安装 C/C++/Objective-C 扩展
:CocInstall coc-explorer        " 文件浏览器
```

C/C++ 配置
[language-server](https://github.com/neoclide/coc.nvim/wiki/Language-servers)

```json
"languageserver": {
  "clangd": {
    "command": "clangd",
    "rootPatterns": ["compile_flags.txt", "compile_commands.json"],
    "filetypes": ["c", "cc", "cpp", "c++", "objc", "objcpp"]
  }
}
```

vimrc 配置

```vim
" 使用 tab 确认补全
inoremap <silent><expr> <TAB> coc#pum#visible() ? coc#pum#confirm() : "\<Tab>"
```

### fzf

快速查找文件

```vim
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" 重定向查找快捷键
nnoremap <silent> <C-p> :Files<CR>
inoremap <silent> <C-p> <ESC>:Files<CR>
```

## vscode

[vscode-vim](../vscode/vscode.md)
