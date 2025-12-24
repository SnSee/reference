if has("gui_running")
    set guifont=Monospace\ 14
    set guicursor=n-v-c:block-blinkon650-blinkoff650
    set guicursor+=i:ver25-blinkon650-blinkoff650
    set guicursor+=r:hor20-blinkon650-blinkoff650
else
	set mouse-=a
endif

syntax on
set encoding=UTF-8
set fileencoding=UTF-8
set number
set autoindent
set smartindent
set tabstop=4
set expandtab
set shiftwidth=4
set softtabstop=4
" set cindent
set scrolloff=5
set backspace=2
"set cursorline		 	" highlight current row
"set cursorcolumn		" highlight current column

" no highlight matching parentheses
let loaded_matchparen=1

set showcmd

"set fdm=indent 		" fold according to shiftwidth
set foldmethod=marker
set foldmarker={,}		" fold according to {}
set foldlevelstart=99 	" no folding when open file

" have Vim jump to the last position when reopening a file
if has("autocmd")
	au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif


"set hlsearch			" highlight searched result
"set nolhsearch
set incsearch 			" show searching process

set wildmenu
set completeopt-=preview
set laststatus=2
set statusline=\ %<%F[%1*%M%*%n%R%H]%=\ %y\ %0(%{&fileformat}\ %{&fileencoding}\ %c:%l/%L%)\ [%p%%]


"""""""""""""""""""" SHORTCUT BEG """"""""""""""""""""
let mapleader="," 

" Alt Key Combination
if has("gui_running")
    cnoremap <M-j> <Esc>
    inoremap <M-j> <Esc>
    nnoremap <M-o> <C-o>
    nnoremap <M-i> <C-i>
    nnoremap <M-]> <C-]>
else
    " insert mode: press <ctrl-v>, then <Alt-key>
    cnoremap <Esc>j <Esc>
    inoremap <Esc>j <Esc>
    nnoremap <Esc>o <C-o>
    nnoremap <Esc>i <C-i>
    " Alt-] is not allowed
endif

" nohlsearch when open file, highlight when search
set nohlsearch
nnoremap n :set hlsearch<cr>n
nnoremap N :set hlsearch<cr>N
nnoremap / :set hlsearch<cr>/
nnoremap ? :set hlsearch<cr>?
nnoremap * :set hlsearch<cr>*

" paste system clipboard with xsel
nnoremap <C-P> :set paste<CR>:read !xsel --output --clipboard<CR>:set nopaste<CR>

nnoremap <C-v> v
nnoremap v <C-v>

" switch window
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" switch tab
nnoremap <leader>l :tabn<CR>
nnoremap <leader>h :tabp<CR>

" copy word to system clipboard
nnoremap <C-c> "+yiw
inoremap <C-c> <C-\><C-n>"+yiw
" insert/command/search: paste system clipboard
cnoremap <silent> <C-S-v> <C-R>+
inoremap <silent> <C-S-v> <Esc>:set paste<CR>i<C-r>+<Esc>:set nopaste<CR>gi

" Ctrl + Backspace: delete previous word
inoremap <C-BS> <C-W>
cnoremap <C-BS> <C-W>
"""""""""""""""""""" SHORTCUT END """"""""""""""""""""


"""""""""""""""""""" FUNCTION BEG """"""""""""""""""""
""" <leader>f: jump to file
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
"""""""""""""""""""" FUNCTION END """"""""""""""""""""


"""""""""""""""""""" PLUGIN BEG """"""""""""""""""""
call plug#begin('~/.vim/plugged')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree'
Plug 'joshdick/onedark.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
Plug 'preservim/nerdcommenter'
Plug 'tpope/vim-fugitive'
call plug#end()

" color theme(onedark, airline)
colorscheme onedark
let g:airline#extensions#tabline#enabled=1
let g:airline_theme='onedark'

" search file(fzf)
" nnoremap <silent> <C-p> :Files<CR>
" inoremap <silent> <C-p> <ESC>:Files<CR>

" search file(Leaderf)
nnoremap <silent> <C-p> :Leaderf file<CR>
inoremap <silent> <C-p> <ESC>:Leaderf file<CR>

" complete with tab(coc)
inoremap <silent><expr> <TAB> coc#pum#visible() ? coc#pum#confirm() : "\<Tab>"
" code navigation(coc)
if has("gui_running")
    nmap <silent> <M-]> <Plug>(coc-definition)
else
    nmap <silent> gd <Plug>(coc-definition)
endif
" nmap <silent> gr <Plug>(coc-references)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gt <Plug>(coc-type-definition)

" toogle nerdtree
nnoremap <silent> <leader>n :NERDTreeToggle<CR>

" toogle comment(nerdcommenter)
nnoremap <C-_> <Plug>NERDCommenterToggle
inoremap <C-_> <Esc><Plug>NERDCommenterTogglei
vnoremap <C-_> <Plug>NERDCommenterTogglegv
let g:NERDSpaceDelims=1
let g:NERDCommentEmptyLines=1
let g:NERDDefaultAlign='left'
"let g:NERDTrimTrailingWhitespace=1
let g:NERDCustomDelimiters = {
    \ 'c': { 'left': '//' },
    \ 'cpp': { 'left': '//' },
    \ }
"""""""""""""""""""" PLUGIN END """"""""""""""""""""


"""""""""""""""""""" COMMAND BEG """"""""""""""""""""
" show current file absolute path
command! Pwd echo expand('%:p')
"""""""""""""""""""" COMMAND END """"""""""""""""""""
