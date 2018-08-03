if $DISPLAY != ''
  " Make the clipboard register the same as the default register
  " this allows easy copy to other x11 apps
  set clipboard=unnamed,unnamedplus
endif

" A history of ":" commands, and a history of previous search patterns
set history=1000

" Show line numbers
" set number
" Relative line numbers
" set relativenumber

" allow the cursor to pass the last character
" set virtualedit=all

" Set reload a file when it is changed from the outside
set autoread

" Automatically write file if leaving a buffer
set autowriteall

" Leave cursor where it was - even on page jump
set nostartofline

let &tabstop = 2
let &softtabstop = &tabstop
let &shiftwidth = &tabstop
set shiftround
set smarttab
set expandtab

" automatically indent to match adjacent lines
set autoindent

" only set for specific filetypes
" set textwidth=80

set backspace=indent,start

set splitbelow

" Line wrapping
set wrap

" Stay in the middle of the screen
set scrolloff=999
" set sidescrolloff=0

" Scroll by one char at end of line
" set sidescroll=1

" None of these are word dividers
set iskeyword+=_,$,@,%,#,-

" Don't make noise
set noerrorbells
set novisualbell
set t_vb=

" assume fast terminal connection
set ttyfast

set hidden
" set winheight=9999

" only show 1 line for minimized windows
" set winminheight=0

" Set preview window height
" set previewheight=99

augroup MyVimrcAugroupMaximizeHelp
  autocmd!
  autocmd BufEnter * :if &buftype == 'help' | only | endif
augroup END

" augroup MyVimrcAugroupListAllBuffers
"   autocmd!
"   autocmd BufEnter * :setlocal buflisted
" augroup END

" show count of selected lines / columns
set showcmd

" Make macros render faster (lazy draw)
" set lazyredraw

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

set isfname-==

command! -nargs=* RemoveTrailingSpaces :silent %s/\s\+$//e
command! -nargs=* RemoveNewlineBlocks
      \ :silent %s/\v\s*\n(\s*\n)+/\r\r/g
      \ | :silent %s/\n*\%$//g

" Deactivate gui cursor to fix nvim regression (2017-07-25)
" (https://github.com/neovim/neovim/issues/7049)
set guicursor=

"### Undo and swap

" Maximum amount of memory in Kbyte to use for all buffers together.
" not supported anymore? (2018-06-19)
" set maxmemtot=2048

" Never create backup files
set nobackup
set nowritebackup

" Never create swapfiles
set noswapfile

" Show matching brackets
set showmatch

" Don't blink when matching
set matchtime=0

" Incremental search
set incsearch

set wildignorecase

set ignorecase

" Case insensitive search when all lowercase
set smartcase

" Case inferred by default
set infercase

" Do not wrap while searching
" set nowrapscan

" Switch window if it contains wanted buffer
set switchbuf=useopen

" nomodeline can not be revered by plugins
" but modeline is needed by dbext even though it uses its own parser.
set nomodeline

" Modlines might be dangerous
" see also securemodelines.vim
set modelines=0

" Timeout on mappings and key codes (faster escape etc)
" set timeout
" set timeoutlen=300
" set ttimeoutlen=10

" used for the CursorHold autocommand event
set updatetime=1000

set suffixesadd=.txt,.md

" don't echo make output to screen
let &shellpipe = '&>'

