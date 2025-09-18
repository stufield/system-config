set rtp+=$HOME/.local/lib/python2.7/site-packages/powerline/bindings/vim/
" Always show statusline
set laststatus=2
" Use 256 colours (Use this setting only if your terminal supports 256 colours)
set t_Co=256
set vb t_vb=
set viminfo='100,f1
"This unsets the "last search pattern" register by hitting return
nnoremap <CR> :nohlsearch<CR><CR>
set nocompatible
set autoindent
"set spell spelllang=en_us
inoremap # X#
set showmatch
set ruler
"set ts=20
"set number
set expandtab
set suffixesadd=.R
"set noexpandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set showcmd
set magic
set autowrite	" autowrite buffer when switching
set incsearch
filetype plugin indent on
set background=dark
set smartindent
set hlsearch
set guicursor=n-v-c:block-Cursor
set guicursor+=i-v-c:block-Cursor
"set guicursor+=i:ver100-iCursor
set guicursor+=n-v-c:blinkon0-Cursor
"set guicursor+=i:blinkwait20-iCursor
set backspace=indent,eol,start whichwrap+=<,>,[,]
"imap <C-Z> <ESC>z.i

autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

colorscheme stuvim

syntax on
syntax spell toplevel

" cpp S
" au! Syntax cpp source vim_syntax/cpp.vim

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
" Replace equal sign (=) with <- symbol in R
function ReplaceEquals()
	s<=<\<-
endfunction

" nmap <F3> :call ReplaceEquals() <CR>


function Rdoc()
	let s:wd=expand("")
	let s:lineNo=line('.') - 1
	let plist=Getparams()
	call append(s:lineNo,"")
	call append(s:lineNo + 1,"#' Title ")
	call append(s:lineNo + 2,"#' ")
	call append(s:lineNo + 3,"#' Description")
	call append(s:lineNo + 4,"#' ")
	call append(s:lineNo + 5,"#' Details")
	call append(s:lineNo + 6,"#' ")
	let s:idx = 0
	while s:idx < len(plist)
		call append(s:lineNo + 7 + s:idx , "#' @param " . plist[s:idx] . " value")
		let s:idx = s:idx + 1
	endwhile
	call append(s:lineNo + 7 + s:idx,"#' @return return_value")
	call append(s:lineNo + 7 + s:idx + 1,"#' @note %% ~~ further notes ~~ ")
	call append(s:lineNo + 7 + s:idx + 2,"#' @author Stu Field ")
	call append(s:lineNo + 7 + s:idx + 3,"#' @seealso \\code{\\link[pkg]{func}} ")
	call append(s:lineNo + 7 + s:idx + 4,"#' @references %% ~put references to the literature/web site here~ ")
	call append(s:lineNo + 7 + s:idx + 5,"#' @examples ")
	call append(s:lineNo + 7 + s:idx + 6,"#' ")
	call append(s:lineNo + 7 + s:idx + 7,"#' x <- c(1,2,3) ")
	call append(s:lineNo + 7 + s:idx + 8,"#' plot(x) ")
	call append(s:lineNo + 7 + s:idx + 9,"#' ")
	call append(s:lineNo + 7 + s:idx + 10,"#' @import ")
	call append(s:lineNo + 7 + s:idx + 11,"#' @importFrom ")
	call append(s:lineNo + 7 + s:idx + 12,"#' @export ")
endfunction

" nmap <F9> :call Rdoc() <CR>

