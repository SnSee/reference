" Alt 组合键 <M-key> 需要检查是否需要通过 Ctrl-V Alt-<key> 的方式设置

if has("gui_running")
	set guifont=Monospace\ 14	" gvim 设置字体
    colorscheme monokai
    set guicursor=n-v-c:block-blinkon650-blinkoff650
    set guicursor+=i:ver25-blinkon650-blinkoff650
    set guicursor+=r:hor20-blinkon650-blinkoff650
else
	set mouse-=a 				" vim下鼠标左键不进入visual模式,gvim下进入
endif

set encoding=UTF-8
set fileencoding=UTF-8
set number
set autoindent
set smartindent
" set cindent
set scrolloff=5             " 移动光标时上下至少有 5 行
set backspace=2

let loaded_matchparen = 1  "设置不高亮显示配对的括号

set showcmd

"set fdm=indent 			" 设置按 shiftwidth 缩进折叠
set foldmethod=marker
set foldmarker={,}		" 设置根据大括号折叠
set foldlevelstart=99 	" 设置打开文件时默认不折叠代码

" have Vim jump to the last position when reopening a file
if has("autocmd")
	au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

"colorscheme sublimemonokai
hi comment ctermfg=2	"设置注释颜色为绿色
syntax on
set tabstop=4
set expandtab
set shiftwidth=4
set softtabstop=4
"highlight CursorLine ctermbg=black guibg=black		" 设置背景色颜色
"set cursorline		 	"高亮显示当前行背景色
"set cursorcolumn		"高亮显示当前列背景色

"set hlsearch			"高亮显示搜索结果	set nolhsearch
set incsearch 			"显示查找匹配过程

" 快速按 Alt-j 进入normal模式
cnoremap <M-j> <Esc>
inoremap <M-j> <Esc>

" 当光标一段时间保持不动了，就禁用高亮
" autocmd cursorhold * set nohlsearch

" 当打开文件时仍高亮之前的搜索结果时使用下面的方式
" 默认关闭高亮，当输入查找命令时，再启用高亮
set nohlsearch
nnoremap n :set hlsearch<cr>n
nnoremap N :set hlsearch<cr>N
nnoremap / :set hlsearch<cr>/
nnoremap ? :set hlsearch<cr>?
nnoremap * :set hlsearch<cr>*

" vim 不支持系统粘贴板时借助 xsel 获取系统粘贴板并插入
nnoremap <C-P> :set paste<CR>:read !xsel --output --clipboard<CR>:set nopaste<CR>

" 互换visual快捷键
nnoremap <C-v> v
nnoremap v <C-v>

" shortcut begin

let mapleader = "," 

" 组合键改为Alt
" 如果不行，在insert模式下先按 Ctrl+V, 再按 Alt + key
nnoremap <M-o> <C-o>
nnoremap <M-i> <C-i>
" 不能设置 ]
" nnoremap <M-]> <C-]>

" 切换分屏
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" 切换tab页
nnoremap <leader>l :tabn<CR>
nnoremap <leader>h :tabp<CR>

" 窗口跳转
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" 运行当前文件
nnoremap <S-F10> :w<CR>:!./%<CR>
inoremap <S-F10> <C-\><C-n>:w<CR>:!./%<CR>

" 设置自动补全括号
inoremap { {<Enter>}<Esc>O
inoremap { {}<Esc>i
inoremap ( ()<Esc>i
inoremap [ []<Esc>i

inoremap } <c-r>=ClosePair('}')<CR>
inoremap ) <c-r>=ClosePair(')')<CR>
inoremap ] <c-r>=ClosePair(']')<CR>
" inoremap <c-r>=ClosePair

" 复制光标所在位置单词到系统粘贴板
nnoremap <C-c> "+yiw
inoremap <C-c> <C-\><C-n>"+yiw
" insert/command/search 使用系统粘贴板
" normal 使用 "+p 即可
cnoremap <C-S-v> <C-R>+
inoremap <C-S-v> <C-R>+
"cnoremap <C-v> <C-R>+
"inoremap <C-v> <C-R>+
"nnoremap * "+yiw*
"nnoremap # "+yiw#

" 设置 Ctrl + Backspace 键来删除前方的一个单词
inoremap <C-BS> <C-W>
cnoremap <C-BS> <C-W>

" shortcut end

" 设置快捷显示当前文件路径函数
command! Pwd echo expand('%:p')

" 设置输入右括号时移动到右括号右侧
function! ClosePair(char)
    if getline('.')[col('.') - 1] == a:char
        return "\<Right>"
    else
        return a:char
    endif
endfunction

" 设置换行时如果在大括号内进行缩进
imap <CR> <c-r>=ChangeLine('}')<CR>
function! ChangeLine(char)
    if getline('.')[col('.') - 1] == a:char
        return "\<CR>\<Esc>\O"
    else 
        return "\<CR>"
    endif
endfunction


set wildmenu
set completeopt-=preview

" 设置状态栏
set laststatus=2
set statusline=\ %<%F[%1*%M%*%n%R%H]%=\ %y\ %0(%{&fileformat}\ %{&fileencoding}\ %c:%l/%L%)\ [%p%%]

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FUNCTION START
""""""""""""""""""""""""""""""""""""""""""""""""""""""

""" 设置 ctrl + / 自动注释当前行，目前只支持 #,",// 三种注释符号
nnoremap <C-_> ^:call Auto_comment() <CR>j
inoremap <C-_> <ESC> <C-_>
function Auto_comment()
	" 取消注释当前行
	let b:line_num=line(".")
	let b:cur_line=getline(b:line_num)
	let b:fir_chr=strpart(b:cur_line, getcurpos()[2] - 1, 1)	"获取第一个非空字符
	if match('#', b:fir_chr) > -1 && match(&filetype, "h") != 0 && match(&filetype, "c") != 0
		" 正则匹配时不支持 (#|/) 这种写法
		call setline(b:line_num, substitute(b:cur_line, '[#"/]/* *', "", ""))
		return
    elseif match('"/', b:fir_chr) > -1
		call setline(b:line_num, substitute(b:cur_line, '[#"/]/* *', "", ""))
		return
	endif
	" 注释当前行
	if match(&filetype, "h") == 0 || match(&filetype, "c") == 0
		let b:comment_mark="//"
	elseif match(&filetype, "vim") == 0
		let b:comment_mark='"'
	else
		let b:comment_mark="#"
	endif
	let b:new_line=substitute(b:cur_line, b:fir_chr, printf("%s %s", b:comment_mark, b:fir_chr), "")
	call setline(b:line_num, b:new_line)
endfunction


""" <leader>f 跳转到光标处文件
nnoremap <leader>f :call Strict_gf()<CR>
function! Strict_gf()
    let cur_line = getline('.')
    let col_idx = col('.') - 1
    let f_pat = '[./a-zA-Z0-9_~-]\+'
    if match(cur_line[col_idx], f_pat)
        return
    endif

    let start = col_idx
    while match(cur_line[start - 1], f_pat) != -1
        let start = start - 1
    endwhile
    let end = matchend(cur_line, f_pat, col_idx)

    let file_name = strpart(cur_line, start, end - start)
    if match(file_name[0], '[/~]') == -1
        let file_dir = fnamemodify(expand('%:p'), ':h')
        let file_name = file_dir . '/' . file_name
    endif
    if filereadable(file_name)
        execute 'edit ' . file_name
    else
        echo "File not found: " . file_name
    endif
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FUNCTION END
""""""""""""""""""""""""""""""""""""""""""""""""""""""

augroup Format-Options
    autocmd!
    autocmd BufEnter * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

    " This can be done as well instead of the previous line, for setting formatoptions as you choose:
    autocmd BufEnter * setlocal formatoptions=crqn2l1j
augroup END

" 插件
"call plug#begin('~/.vim/plugged')
"
"Plug 'preservim/nerdtree'
"
"call plug#end()

" 打开关闭nerdtree
nnoremap <silent> <leader>n :NERDTreeToggle<CR>
