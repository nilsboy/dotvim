if $DISPLAY != ''
  " Make the clipboard register the same as the default register
  " this allows easy copy to other x11 apps
  set clipboard=unnamed,unnamedplus
endif

set history=1000
set autoread
set autowriteall
set nostartofline

let &tabstop = 2
let &softtabstop = &tabstop
let &shiftwidth = &tabstop
set shiftround
set smarttab
set expandtab
set autoindent
set backspace=indent,start

set splitbelow
set wrap

" Stay in the middle of the screen
set scrolloff=999

set iskeyword+=_,$,@,%,#,-
set isfname-==

" Don't make noise
set noerrorbells
set visualbell
set t_vb=

set hidden
set showcmd
set display=lastline,uhex

" Vim will wrap long lines at any character in 'breakat'
set linebreak
set breakat&vim
if IsNeoVim()
  set breakindent
  " more chars:
  " :help digraph-table
  " ≡ ↪ »«‖⇒→><│▓├┠▶ ↑^∟┃
  let &showbreak=repeat('┃', &tabstop - 1) . " " 
else
  " let &showbreak=repeat(' ', &tabstop * 2) . "↪ "
  let &showbreak=repeat('›', &tabstop - 1) . " " 
endif

set mousehide
set mouse=

" always assume decimal numbers
set nrformats-=octal

" Deactivate gui cursor to fix nvim regression (2017-07-25)
" (https://github.com/neovim/neovim/issues/7049)
" (https://github.com/neovim/neovim/issues/6041)
" Fixes 001b appearing on the command line
" This does not help when running without config `-u NORC`.
" (See ~/.bin/vi for a workaround)
" Alacritty does not have this problem.
" Newer gnome-terminal supposedly fixes this - currently running: 3.6.2.
set guicursor=

set undofile

set nobackup
set nowritebackup
set noswapfile

set showmatch
" Don't blink when matching
set matchtime=0

set incsearch
set wildignorecase
set ignorecase
set smartcase
set infercase

set switchbuf=useopen

" Modlines may be malicious
" see also securemodelines.vim
set nomodeline
set modelines=0

set updatetime=1000
set suffixesadd=.txt,.md

" don't echo make output to screen
let &shellpipe = '&>'
