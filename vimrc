"### TODO ######################################################################
" - set $XDG_CACHE_DIR from remote_home for neomru etc?
"### misc ######################################################################

" Use <Leader> as prefix key for own key mappings
let mapleader = ","

" vars
let VIM = $REMOTE_HOME . "/.vim/etc/"
let VIM_VAR = $REMOTE_HOME . "/.vim/var/"
let VIM_BUNDLE = $REMOTE_HOME . ".vim/bundle/"
let TAGS = VIM_VAR . "tags"

let &tags = TAGS

" TODO set viminfo=$REMOTE_HOME/.vim/var/viminfo
set viminfo='50,<1000,s100,:0,n~/vim/viminfo

" Create VIM_VAR dir if missing
if isdirectory(VIM_VAR) == 0
    silent execute '!mkdir -p ' . VIM_VAR
endif

" Keep undo history after closing a file
set undofile
let &undodir = VIM_VAR . "undo"

" Create undodir if missing
if isdirectory(&undodir) == 0
    silent execute '!mkdir -p ' . &undodir
endif

" Security
set modelines=0

" Enable vim enhancements
set nocompatible

" Force 256 colors for terminals that call themselfs TERM=xterm
set t_Co=256

set runtimepath+=$REMOTE_HOME/.vim/etc
set runtimepath+=$REMOTE_HOME/.vim/etc/after

" Reload vimrc on write
autocmd BufWritePost vimrc source %

" set colorcolumn=81

" Prevent creation of .netrwhist file
let g:netrw_dirhistmax = 0

" Detect filetypes and run filetype plugins
filetype on
filetype plugin on
filetype indent on

" Make the clipboard register the same as the default register
" this allows easy copy to other x11 apps
set clipboard=unnamed

" Chdir to the dir of the current buffer
set autochdir

"### searching #################################################################

" Show matching brackets.
set showmatch

" Incremental search
set incsearch

" Highlight found text
set hlsearch

set ignorecase

" Case insensitive search when all lowercase
set smartcase

" Case inferred by default
set infercase

"###############################################################################

" Set to auto read when a file is changed from the outside
set autoread

" Automatically write file if leaving a buffer
set autowriteall

" Timeout on mappings and key codes (faster escape etc)
set timeout
set timeoutlen=300
set ttimeoutlen=10

" Leave my cursor where it was - even on page jump
set nostartofline

" Insert spaces when the tab key is hit
set expandtab

" Tab spacing of 4
set tabstop=4

" Shift width (moved sideways for the shift command)
set sw=4

set smarttab

" Make backspace more flexible
set backspace=indent,eol,start

" Use tab expansion in vim prompts
set wildmode=longest:list

" Ignore case in file names
if exists("&wildignorecase")
    set wildignorecase
endif

" No line wrapping of long lines
set nowrap

" Do not wrap while searching
set nowrapscan

" Show arrows for too long lines / show trailing spaces
set list listchars=tab:\ \ ,trail:.,precedes:<,extends:>

" Stay in the middle of the screen
set scrolloff=999
set sidescrolloff=0

" Scroll by one char at end of line
set sidescroll=1

" None of these are word dividers
set iskeyword+=:,_,$,@,%,#

" Don't make noise
set noerrorbells
set novisualbell

set ttyfast

" Keep cursor position (if possible) when executing certain commands
set nostartofline

" Epic: Force single window mode!
augroup winEnter_only
    autocmd!
    autocmd WinEnter * only
augroup END

" Make all unlisted buffers listed
augroup bufEnter_setBufListed
    autocmd!
    autocmd BufEnter * set buflisted
augroup END

"### undo and swap #############################################################

" Maximum amount of memory in Kbyte to use for all buffers together.
set maxmemtot=2048

" Default 1000
" set undolevels=

" Never create backup files
set nobackup
set nowritebackup

" Don't create swapfiles
set noswapfile

"### mappings ##################################################################

" These are the same for vim
" Tab and Ctrl-I
" Enter and Ctrl-M
" Esc and Ctrl-[ 

" Clear all mappings
" :mapclear

" Disable F1
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

nnoremap <silent> <ESC><ESC> :q!<CR>

nnoremap <silent><C-l> :bnext<cr>
nnoremap <silent><C-h> :bprev<cr>

nnoremap <leader>l :!tree<cr>

" Dont use Q for Ex mode
map Q :q

" Run current buffer
nnoremap <leader>e :!%:p

"### Statusline ################################################################

" Avoid 'hit enter prompt'
set shortmess=atTIW

" Increase ruler height
" set cmdheight=2

set laststatus=2

" Always show ruler (right part of the command line)
" set ruler

" Tail of the filename
set statusline=%t

" Containing directory
set statusline+=\ (%{fnamemodify(expand('%:p'),':h:t')})

" Separator
set statusline+=\ 

" Set color of error highlight group
set statusline+=%#error#

" read only flag
set statusline+=%{filewritable(expand('\%'))?'':'RO'}

" Reset color
set statusline+=%*

" left/right separator
set statusline+=%=

" filetype
set statusline+=%{strlen(&ft)?&ft.'\ ':''}

" file encoding
set statusline+=%{&enc=='utf-8'?'':&enc.'\ '}

" File format
set statusline+=%{&ff=='unix'?'':&ff.'\ '}

" Separator
set statusline+=\ \ \ \ \ 

" Cursor line/total lines
set statusline+=%l/%L

" Cursor column
set statusline+=:%c

" Separator
set statusline+=\ \ \ \ \ 

" Percent through file
set statusline+=%P

"### Install Vundle - The Plugin Manager #######################################

    let iCanHazVundle=1
    let vundle_readme=expand('~/.vim/bundle/vundle/README.md')
    if !filereadable(vundle_readme)
        echo "Installing Vundle.."
        echo ""
        silent !mkdir -p ~/.vim/bundle
        silent !git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle
        let iCanHazVundle=0
    endif
    set rtp+=~/.vim/bundle/vundle/
    call vundle#rc()

"### Bundles ###################################################################

    " Vundle itself
    Plugin 'gmarik/vundle'

    " uber awesome syntax and errors highlighter
    Plugin 'Syntastic'

    " A Git wrapper so awesome, it should be illegal
    Plugin 'tpope/vim-fugitive'

    " ack support
    Plugin 'mileszs/ack.vim'

    " Prerequisite for some vim plugins
    Plugin 'l9'

    Plugin 'shougo/neocomplcache.vim'

    " Universal syntax script for all txt docs, logs and other types
    Plugin 'txt.vim'

    " EasyMotion provides a much simpler way to use some motions in vim
    Plugin 'lokaltog/vim-easymotion'

    " Search and display information from arbitrary sources
    Plugin 'shougo/unite.vim'

    " Most recently used plugin for unite.vim
    Plugin 'shougo/neomru.vim'

    " Provides your Vim's buffer with the outline view
    Plugin 'shougo/unite-outline'

    " Perl omni completion
    Plugin 'c9s/perlomni.vim'

    " Tags completion
    Plugin 'ctags.vim'

    " Select tags or select files including tags
    Plugin 'tsukkee/unite-tag'

    " Lean & mean status/tabline for vim that's light as air.
    " Plugin 'bling/vim-airline'

    Plugin 'scrooloose/nerdtree'

    " File operations
    Plugin 'tpope/vim-eunuch'

    " Bringing GVim colorschemes to the terminal
    " Plugin 'godlygeek/csapprox'

    " Use GUI Color Schemes in Supported Terminals
    Plugin 'KevinGoodsell/vim-csexact'

    " Colorschemes
    Plugin 'altercation/vim-colors-solarized'
    Plugin 'jonathanfilip/vim-lucius'

    Plugin 'vim-scripts/CycleColor'

    " Select tags or select files including tags
    " Plugin 'haha/unite-grep_sync'

    " Plugin 'Shougo/vimproc.vim'

    Plugin 'sgur/unite-qf'

"### Install bundles ###########################################################

    if iCanHazVundle == 0
        echo "Installing Bundles, please ignore key map error messages"
        echo ""
        :PluginInstall
    endif

"###############################################################################
