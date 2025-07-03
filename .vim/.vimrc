set nocompatible " not vi compatible

"------------------
" Syntax and indent
"------------------
syntax on " turn on syntax highlighting
set showmatch " show matching braces when text indicator is over them
filetype plugin indent on " enable file type detection
set autoindent
set background=dark
set cursorline
colorscheme gruvbox
set encoding=utf-8
set fileformat=unix
set maxmempattern=5000
set termguicolors
set foldmethod=syntax     " 使用语法关键字折叠
set foldlevel=99          " 默认展开所有
"---------------------
"" Basic editing config
"---------------------
set rnu
set shortmess+=I " disable startup message
set number " number lines
set lbr " line break
set laststatus=2
set backspace=indent,eol,start " allow backspacing over everything
set hidden " allow auto-hiding of edited buffers
" use 4 spaces instead of tabs during formatting
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
" smart case-sensitive searcd
set ignorecase
set smartcase
set incsearch " incremental search (as string is being typed)
set hls " highlight search
" tab completion for files/bufferss
"set wildmode=longest,list
set wildmenu
set wildmode=full
set nofoldenable " disable folding by default
set history=200 " history command length
"set mouse+=a " enable mouse mode (scrolling, selection, etc)
"if &term =~ '^screen'
    " tmux knows the extended mouse mode
"    set ttymouse=xterm2
"endif

"--------------------
" Misc configurations
"--------------------

" unbind keys
nmap Q <Nop> 
map <C-a> <Nop>
map <C-x> <Nop>

" disable audible bell
set noerrorbells visualbell t_vb=

" open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

"---------------------
" Local customizations
"---------------------

" local customizations in ~/.vimrc_local
let $LOCALFILE=expand("~/.vimrc_local")
if filereadable($LOCALFILE)
        source $LOCALFILE
endif
