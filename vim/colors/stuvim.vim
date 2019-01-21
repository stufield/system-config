" local syntax file - set colors on a per-machine basis:
" vim: tw=0 ts=4 sw=4
" Vim color file based on elflord.vim colorscheme
" Maintainer:	Stu Field
" Last Change:	2016 May 26

" ********************************************************************************
" The following are the preferred 16 colors for your terminal
"           Colors      Bright Colors
" Black     #4E4E4E     #7C7C7C
" Red       #FF6C60     #FFB6B0
" Green     #A8FF60     #CEFFAB
" Yellow    #FFFFB6     #FFFFCB
" Blue      #96CBFE     #B5DCFE
" Magenta   #FF73FD     #FF9CFE
" Cyan      #C6C5FE     #DFDFFE
" White     #EEEEEE     #FFFFFF
" Gray    
"
"
" " ********************************************************************************
set background=light
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "stuvim"

" Syntax highlighting
hi Normal                           ctermfg=gray         guifg=cyan     guibg=grey           
hi Comment        term=underline    ctermfg=cyan         guifg=#80a0ff
hi Constant       term=underline    ctermfg=darkred	     guifg=Red
hi String	      term=underline    ctermfg=darkmagenta	 guifg=Red
hi Statement      term=underline    ctermfg=darkyellow   guifg=#aa4444  gui=bold       
hi Operator	      term=bold         ctermfg=darkyellow   guifg=Red
hi Type           term=underline    ctermfg=darkgreen    guifg=#60ff60  gui=underline
hi Special        term=underline    ctermfg=lightblue    guifg=Red
hi Delimiter	  term=underline    ctermfg=lightblue
"hi Function       term=bold         ctermfg=green        guifg=White

hi Identifier     term=underline    cterm=bold           ctermfg=cyan   guifg=#40ffff
hi PreProc        term=underline    ctermfg=lightblue    guifg=#ff80ff
hi Repeat         term=underline    ctermfg=green        guifg=yellow
hi Ignore                           ctermfg=black        guifg=bg
hi Error          term=reverse      ctermbg=lightred     ctermfg=white  guibg=Red   guifg=White
hi Todo           term=standout     ctermbg=darkyellow   ctermfg=black  guifg=Blue  guibg=Yellow


"
"
"
" Common groups that link to default highlighting.
" You can specify other highlighting easily.

"hi link String	Constant
hi link Character	Constant
hi link Number	Constant
hi link Boolean	Constant
hi link Float		Number
hi link Conditional	Repeat
hi link Label		Statement
hi link Keyword	Statement
hi link Exception	Statement
hi link Include	PreProc
hi link Define	PreProc
hi link Macro		PreProc
hi link PreCondit	PreProc
hi link StorageClass	Type
hi link Structure	Type
hi link Typedef	Type
hi link Tag		Special
hi link SpecialChar	Special
"hi link Delimiter	Special
hi link SpecialComment Special
hi link Debug		Special
