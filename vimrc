"### help ######################################################################
" html help: http://vimdoc.sourceforge.net/htmldoc/usr_toc.html
" what configuration was last loaded: :verbose set formatoptions
" http://vim.wikia.com/wiki/Learn_to_use_help
" :h pattern
" vim scripting:
" http://www.ibm.com/developerworks/linux/library/l-vim-script-1/index.html
"
"### notes #####################################################################
" who set a var:
" 5verbose set fo?
" 5verbose setl fo?
"### misc ######################################################################

" Use <Leader> as prefix key for own key mappings
let mapleader = ","

" vars
let VIM = $REMOTE_HOME . "/.vim/etc/"
let VIM_VAR = $REMOTE_HOME . "/.vim/var/"
let VIM_BUNDLE = $REMOTE_HOME . ".vim/bundle/"
let TAGS = VIM_VAR . "tags"

let &tags = TAGS

" does not work:
" set viminfo=$REMOTE_HOME/.vim/var/viminfo

" create VIM_VAR dir if missing
if isdirectory(VIM_VAR) == 0
    silent execute '!mkdir -p ' . VIM_VAR
endif

" Keep undo history after closing a file
set undofile
let &undodir = VIM_VAR . "undo"

" create undodir if missing
if isdirectory(&undodir) == 0
    silent execute '!mkdir -p ' . &undodir
endif

" Security
set modelines=0

" Enable vim enhancements
set nocompatible

set runtimepath+=$REMOTE_HOME/.vim/etc

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
    Plugin 'bling/vim-airline'

"### Install bundles ###########################################################

    if iCanHazVundle == 0
        echo "Installing Bundles, please ignore key map error messages"
        echo ""
        :PluginInstall
    endif

"###############################################################################

" reload vimrc on write - no works?
" autocmd bufwritepost $MYVIMRC source $MYVIMRC

" set shortmess=astTI " avoid 'hit enter prompt'
" set cmdheight=2 " increase ruler height

" set ruler " always show status line
" set rulerformat=%80(%<%F\ %{(&fenc==\"\"?&enc:&fenc)}%Y%{&ff=='unix'?'':','.&ff}%=\ %2c\ %P%)

" set colorcolumn=81

" prevent creation of .netrwhist file
let g:netrw_dirhistmax = 0

" detect filetypes and run filetype plugins
filetype on
filetype plugin on
filetype indent on

" make the clipboard register the same as the default register
" this allows easy copy to other x11 apps
set clipboard=unnamed

"### searching #################################################################

" use normal regexes
" nnoremap / /\v
" vnoremap / /\v

set showmatch " Show matching brackets.
set incsearch " Incremental search
set hlsearch " highlight found text

set ignorecase
set smartcase " case insensitive search when all lowercase
set infercase " case inferred by default

"###############################################################################

" Set to auto read when a file is changed from the outside
set autoread

" Automatically write file if leaving a buffer
set autowriteall

" Timeout on mappings and key codes (faster escape etc)
set timeout
set timeoutlen=300
set ttimeoutlen=10

" leave my cursor where it was - even on page jump
set nostartofline

set expandtab " Insert spaces when the tab key is hit
set tabstop=4 " Tab spacing of 4
set sw=4 " shift width (moved sideways for the shift command)
set smarttab

set backspace=indent,eol,start " make backspace more flexible

" use tab expansion in vim prompts
set wildmode=longest:list

" ignore case in file names
if exists("&wildignorecase")
    set wildignorecase
endif

" try to restore last known cursor position
autocmd BufReadPost * if line("'\"") | exe "normal '\"" | endif

set nowrap " no line wrapping of long lines
set nowrapscan " do not wrap while searching

" show arrows for too long lines / show trailing spaces
set list listchars=tab:\ \ ,trail:.,precedes:<,extends:>

" stay in the middle of the screen
set scrolloff=999
set sidescrolloff=0

" scroll by one char at end of line
set sidescroll=1

" none of these are word dividers
set iskeyword+=:,_,$,@,%,#

" don't make noise
set noerrorbells
set novisualbell

set ttyfast

"### undo and swap #############################################################

" Maximum amount of memory in Kbyte to use for all buffers together.
set maxmemtot=2048

" default 1000
" set undolevels=

" never create backup files
set nobackup
set nowritebackup

" in memory only
set noswapfile

"###############################################################################

" set encoding=utf-8
" set laststatus=2

"### mappings ##################################################################

" these are the same for vim
" Tab and Ctrl-I
" Enter and Ctrl-M
" Esc and Ctrl-[ 

" clear all mappings
" :mapclear

" disable F1
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

nnoremap <ESC> :q<CR>
nnoremap <ESC><ESC> :q!<CR>

nnoremap <C-l> :bnext<cr>
nnoremap <C-h> :bprev<cr>

" dont use Q for Ex mode
map Q :q

" move between windows
" nnoremap <C-h> <C-w>h
" nnoremap <C-j> <C-w>j
" nnoremap <C-k> <C-w>k
" nnoremap <C-l> <C-w>l

" open new window an move into it
" nnoremap <leader>w :80vs<cr><C-w>l
" nnoremap <leader>wc <C-w>c

" history jump
" nnoremap <c-h> <c-o>
" nnoremap <c-l> <c-i>

" nnoremap <c-k> g<c-]>
" nnoremap <c-j> <c-t>

"### automatically give executable permissions #################################

au BufWritePost * silent call ModeChange()

function! ModeChange()
  if getline(1) =~ "^#!"
    if getline(1) =~ "/bin/"
      silent !chmod a+x <afile>
    endif
    if getline(1) =~ "perl"
      silent set filetype=perl
    endif
  endif
endfunction

"### highlighting ##############################################################

" NOTE
" to convert a highcolor theme to run in a 256-color-terminal-vim
" use CSApprox plugin and store theme with :CSApproxSnapshot

" enable colors only if terminal supports colors

set t_Co=256
set background=light

try
    colorscheme github
catch /find/
    " nothing
endtry

if &t_Co > 1
    syntax enable
endif

" highlight the whole file not just the window - slower but more accurate.
autocmd BufEnter * :syntax sync fromstart

"### Keep cursor position on undo and redo #####################################

map <silent> u :call MyUndo()<CR>
function! MyUndo()
    let _view=winsaveview()
    :undo
    call winrestview(_view)
endfunction

map <silent> <c-r> :call MyRedo()<CR>
function! MyRedo()
    let _view=winsaveview()
    :redo
    call winrestview(_view)
endfunction

"###############################################################################
