set laststatus=2    "Always show statusline

set t_Co=256  "Use 256 colours (Use this setting only if your terminal supports 256 colours)

set vb t_vb=
set viminfo='100,f1

"This unsets the "last search pattern" register by hitting return
nnoremap <CR> :nohlsearch<CR><CR>

"set spell spelllang=en_us

set nocompatible
set autoindent
set nosmartindent
filetype indent on

set showmatch
set ruler
"set ts=20
"set number
set expandtab
set suffixesadd=.R
set tabstop=2
set softtabstop=2
set shiftwidth=2
set textwidth=70
set showcmd
set magic
set autowrite	" autowrite buffer when switching
set incsearch
filetype plugin indent on
set background=dark
set hlsearch
set guicursor=n-v-c:block-Cursor
set guicursor+=i-v-c:block-Cursor
"set guicursor+=i:ver100-iCursor
set guicursor+=n-v-c:blinkon0-Cursor
"set guicursor+=i:blinkwait20-iCursor
set backspace=indent,eol,start whichwrap+=<,>,[,]

autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

colorscheme stuvim

syntax on
syntax spell toplevel

:runtime! ftplugin/man.vim

autocmd FileType adat set nowrap
autocmd FileType adat set ts=75
autocmd FileType tex syntax spell toplevel
autocmd FileType ts syntax off


" -------------
" Shortcuts
" -------------
" single character insert
nmap <Space> i_<Esc>r

" wrap text ~ 80 char single line
nmap <F5> gq$


" Update the spell check binary file
function UpdateSpell()
   :mkspell! ~/.vim/spell/en.utf-8.add
endfunction

nmap <F6> :call UpdateSpell() <CR>


" Fix a line tab with a J + i + Return + Esc
function FixLine()
   call feedkeys("J")
   call feedkeys("i")
   call feedkeys("\<CR>")
   call feedkeys("\<ESC>")
endfunction

" map to Shift + downarrow
nmap <S-Down> :call FixLine() <CR>


" ------------------------
" R related code snippets
" ------------------------
" Replace equal sign (=) with <- symbol
" cursor must be BEFORE the (=) symbol
autocmd FileType r,rmd,quarto nnoremap <buffer> ; f=cl<lt>-<Esc>

