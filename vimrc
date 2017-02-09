"opcions per editar codi font (identacio automatica, syntax highlighting...)
set nocompatible
set autoindent
syntax on
filetype plugin on
filetype indent on

"control de tabulacio
set tabstop=4		"visualment, mostrar un tab com 4 espais
set softtabstop=4	"en mode insert, un tab equival a 4 espais
set shiftwidth=4	" >> o << equivalen a 4 espais
set expandtab		"tractar tab com espais
set smarttab		"make tab insert indents instead of tabs at the beginning of a line

"altres
set ignorecase		"cerques no case sensitive
set smartcase		"case sensittive si el terme de cerca inclou alguna majuscula
set hlsearch		"Highlight the last searched pattern
set incsearch		"Show where the next pattern is as you type it
set number			"mostrar numero de linia
"set relativenumber	"linia actual=linia 1
if !has('nvim')
    set ttymouse=xterm2	"mouse integration under GNU Screen
endif
set wildmode=longest,list,full  "defineix com es completen els noms d'arxiu
set wildmenu

"colors (set color scheme, highlight current line, highlight columns 80 and 120)
if &term =~ "xterm" || &term =~ "256" || $DISPLAY != "" || $HAS_256_COLORS == "yes"
    set t_Co=256	" Force 256 colors
endif
colorscheme monokai
set cursorline
hi CursorLine cterm=NONE ctermbg=234 ctermfg=NONE
hi ColorColumn ctermbg=234 guibg=#2c2d27
let &colorcolumn="80,".join(range(120,999),",")

"let maplocalleader ='º'	"tecla per executar comandes custom NOMES TECLAT SPANISH

"uns quants maps interessants
nnoremap gf <C-W>gf
nnoremap n nzz
vnoremap n nzz
nnoremap <C-u> <C-u>zz
vnoremap <C-u> <C-u>zz
nnoremap <C-d> <C-d>zz
vnoremap <C-d> <C-d>zz
nnoremap <C-F> <C-F>zz
vnoremap <C-F> <C-F>zz
nnoremap <C-B> <C-B>zz
vnoremap <C-B> <C-B>zz
inoremap kj <esc>
nnoremap j gj
vnoremap j gj
nnoremap k gk
vnoremap k gk
nmap <Down> j
vmap <Down> j
nmap <Up> k
vmap <Up> k
nmap <tab> :
vmap <tab> :

"latex
let g:tex_flavor='latex'
let g:Tex_MultipleCompileFormats='pdf'
let g:Tex_ViewRule_pdf='evince_dbus.py'
let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_CompileRule_pdf='pdflatex -synctex=1 -interaction=nonstopmode $*'
set grepprg=grep\ -nH\ $*

"folding
set foldmethod=indent   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
set foldlevel=1         "this is just what i use

"rplugin
let vimrplugin_source = "~/.vim/r-plugin/screenR.vim"
let vimrplugin_show_args = 1
vmap <Space> <Plug>REDSendSelection
nmap <Space> <Plug>RDSendLine

"screen plugin for clojure filetypes (ftdetect/clojure.vim sets the filetype)
"caveats: 'send a line' in normal mode has to get into insert mode first. It's
"a bug in lein repl and readline. In visual mode I couldn't work out how to
"fix it yet...
autocmd FileType clojure noremap <localleader>s :ScreenShell<CR>
autocmd FileType clojure noremap <localleader>q :ScreenQuit<CR>
autocmd FileType clojure noremap <localleader>d :call g:ScreenShellSend('i' . getline("."))
autocmd FileType clojure vnoremap <localleader>d :ScreenSend
autocmd FileType clojure vmap <Space> <localleader>d<CR>j
autocmd FileType clojure vmap <S-Space> <localleader>d<CR>
autocmd FileType clojure nmap <Space> <localleader>d<CR>j
autocmd FileType clojure nmap <S-Space> <localleader>d<CR>

"gvim
if has('gui_running')
	set lines=35 columns=132
end

