"### help ######################################################################
" html help: http://vimdoc.sourceforge.net/htmldoc/usr_toc.html
" what configuration was last loaded: :verbose set formatoptions
" http://vim.wikia.com/wiki/Learn_to_use_help
" :h pattern
" vim scripting:
" http://www.ibm.com/developerworks/linux/library/l-vim-script-1/index.html
"
"### misc ######################################################################

" Security
set modelines=0

set nocompatible " Enable vim enhancements

set shortmess=astTI " avoid 'hit enter prompt'
set cmdheight=2 " increase ruler height

set ruler " always show status line
set rulerformat=%80(%<%F\ %{(&fenc==\"\"?&enc:&fenc)}%Y%{&ff=='unix'?'':','.&ff}%=\ %2c\ %P%)

set colorcolumn=81

let VIM_VAR = $REMOTE_HOME . "/.vim.var"
let &tags = VIM_VAR . "/tags"

let &viminfo = VIM_VAR . "/viminfo"

" TEST: prevent creation of .netrwhist file
let g:netrw_dirhistmax = 0

" detect filetypes and run filetype plugins
filetype on
filetype plugin on
filetype indent on

" load plugins in bundle/*
call pathogen#infect()

" clipboard
" set clipboard=unnamed
" set go+=a

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

set autoread " Set to auto read when a file is changed from the outside

set nostartofline " leave my cursor where it was - even on page jump

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

set iskeyword+=:,_,$,@,%,# " none of these are word dividers

set noerrorbells " don't make noise
set novisualbell

set ttyfast

"### undo and swap #############################################################

" Maximum amount of memory in Kbyte to use for all buffers together.
set maxmemtot=2048

set noswapfile

" Keep undo history after closing a file
set undofile
let &undodir=VIM_VAR . "/undo"

" create undodir if missing
if isdirectory(&undodir) == 0
    silent execute '!mkdir -p ' . &undodir
endif

" default 1000
" set undolevels=

" never create backup files
set nobackup
set nowritebackup

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

" nnoremap <ESC> :q<CR>

" dont use Q for Ex mode
map Q :q

let mapleader = ","

" move between windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" open new window an move into it
nnoremap <leader>w :80vs<cr><C-w>l
nnoremap <leader>wc <C-w>c

" jumlist
" nmap <C-I> <C-W>j:call g:SrcExpl_Jump()<CR>
" nmap <C-O> :call g:SrcExpl_GoBack()<CR>

" history jump
nnoremap <c-h> <c-o>
nnoremap <c-l> <c-i>

" nnoremap <c-k> g<c-]>
" nnoremap <c-j> <c-t>

"### automatically give executable permissions #################################

au BufWritePost * silent call ModeChange()

function ModeChange()
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
if &t_Co > 1
    syntax enable
endif

set t_Co=256
set background=light

try
    colorscheme autumnleaf256
catch /find/
    " nothing
endtry

" highlight the whole file not just the window - slower but more accurate.
autocmd BufEnter * :syntax sync fromstart

"### Keep cursor position on undo and redo #####################################

map <silent> u :call MyUndo()<CR>
function MyUndo()
    let _view=winsaveview()
    :undo
    call winrestview(_view)
endfunction

map <silent> <c-r> :call MyRedo()<CR>
function MyRedo()
    let _view=winsaveview()
    :redo
    call winrestview(_view)
endfunction

"###############################################################################
