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
set laststatus=0    "hide status line in the bottom
set ignorecase		"cerques no case sensitive
set smartcase		"case sensittive si el terme de cerca inclou alguna majuscula
set hlsearch		"Highlight the last searched pattern
set incsearch		"Show where the next pattern is as you type it
set number			"mostrar numero de linia
"set relativenumber	"linia actual=linia 1
set wildmode=longest,list,full  "defineix com es completen els noms d'arxiu
set wildmenu
if !has('nvim')
    set ttymouse=xterm2	"mouse integration under GNU Screen
else
    set mouse=""
endif

"colors (set color scheme, highlight current line, highlight columns 80 and 120)
if &term =~ "xterm" || &term =~ "256" || $DISPLAY != "" || $HAS_256_COLORS == "yes"
    set t_Co=256	" Force 256 colors
endif
colorscheme monokai
set cursorline
hi CursorLine cterm=NONE ctermbg=235 ctermfg=NONE
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
inoremap kj <Esc>
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

"remaps especifics pel mode terminal de neovim
if has('nvim')
    autocmd BufWinEnter,WinEnter term://* startinsert
    autocmd BufLeave term://* stopinsert
"    tnoremap <Esc> <C-\><C-n>  <-- interferes with readline's set -o vi
    tnoremap <C-w>h <C-\><C-n><C-w>h
    tnoremap <C-w>j <C-\><C-n><C-w>j
    tnoremap <C-w>k <C-\><C-n><C-w>k
    tnoremap <C-w>l <C-\><C-n><C-w>l
endif

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

"pretend we have a very simple screen plugin
"slimmed down from https://github.com/jalvesaq/vimcmdline
function! OpenTermZz(app)
    set switchbuf=useopen
    silent belowright new
    let g:opentermzz_job = termopen(a:app)
    let g:opentermzz_termbuf = bufname("%")
    exe "sbuffer " . bufname("%")
endfun

function! SendLineZz(line)
    if exists('g:opentermzz_job')
        call jobsend(g:opentermzz_job, a:line . "\n")
    else
        echo "terminal not open, open split first"
    endif
endfun

nmap <localleader>s :call OpenTermZz("bash")<CR>
nmap <Space> :call SendLineZz(getline("."))<CR>j
vmap <Space> :call SendLineZz(getline("."))<CR>j

"R bindings. Got from the nvim-R defaults (:map)
function! R_bindings()
    if !has('nvim')
        let vimrplugin_source = "~/.vim/r-plugin/screenR.vim"
    endif
    let vimrplugin_show_args = 1
    let R_nvimpager = "tab"
    vmap <Space> <Esc>:call SendSelectionToR("echo", "down")<CR>
    nmap <Space> :call SendLineToR("down")<CR>0
endfun

autocmd FileType r call R_bindings()

"set GUI specific options
if has('gui_running')
	set lines=35 columns=132
end

