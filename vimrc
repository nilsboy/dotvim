"### TODO ######################################################################
" - set $XDG_CACHE_DIR from remote_home for neomru etc?
" - check preview-window
"### misc ######################################################################

" Use <Leader> as prefix key for own key mappings
let mapleader = " "

" vars
let g:MY_VIM = $REMOTE_HOME . "/.vim/etc/"
let g:MY_VIM_RC = $REMOTE_HOME . "/.vim/etc/vimrc"
let g:MY_VIM_VAR = $REMOTE_HOME . "/.vim/var/"
let TAGS = g:MY_VIM_VAR . "/tags"

let &tags = TAGS

" TODO set viminfo=$REMOTE_HOME/.vim/var/viminfo
set viminfo='50,<1000,s100,:0,n~/vim/viminfo

" Create g:MY_VIM_VAR dir if missing
if isdirectory(g:MY_VIM_VAR) == 0
    silent execute '!mkdir -p ' . g:MY_VIM_VAR
endif

" Keep undo history after closing a file
set undofile
let &undodir = g:MY_VIM_VAR . "undo"

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

" Add system PATH to vim path to be used by :find
let &path = &path . "," . substitute($PATH, ':', ',', 'g')

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

" Do not wrap while searching
" set nowrapscan

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
set wildignorecase

" Ignore patterns
set wildignore=.*,*.class

" No line wrapping of long lines
set nowrap

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

" Highlight the screen line of the cursor with CursorLine
" set cursorline

" Epic
augroup forceSingleWindowMode
    autocmd!
    autocmd WinEnter,QuickFixCmdPost,VimResized,BufCreate,BufAdd,BufEnter *
        \ if &buftype !~ "quickfix"
        \     | set buflisted
        \     | set hidden
        \     | only
        \ | endif
augroup END
        " \     | resize
        " \     | set nowinfixheight

" Highlight unknown filetypes as text
augroup setDefaultSyntax
    autocmd!
    autocmd BufEnter *
        \ if &syntax == '' | setlocal syntax=txt | endif
augroup END

" Highlight vim documentation if opened directly from file
augroup setVimDocSyntax
    autocmd!
    autocmd BufEnter */vim/*/doc/*.txt
        \ if &filetype != 'help' | setlocal filetype=help | endif
augroup END

" show count of selected lines / columns
set showcmd


"### undo and swap #############################################################

" Maximum amount of memory in Kbyte to use for all buffers together.
set maxmemtot=2048

" Default 1000
" set undolevels=

" Never create backup files
set nobackup
set nowritebackup

" Never create swapfiles
set noswapfile

"### mappings ##################################################################

" These are the same for vim
" Tab and Ctrl-I
" Enter and Ctrl-M
" Esc and Ctrl-[ 

" Clear all mappings
" :mapclear

" nnoremap <silent> w /(\@<=\W)\w<cr>
" nnoremap <silent> jj }
" nnoremap <silent> kk {

nnoremap <silent> <ESC><ESC> :x!<CR>

nnoremap <silent> - /\v
nnoremap <silent> / -
nnoremap <silent> _ ?
nnoremap <silent> ? _

nnoremap <silent> Ö :
nnoremap <silent> ö ;

nnoremap <silent> Ä "
nnoremap <silent> ä '

nnoremap <silent> ü [
nnoremap <silent> Ü {

nnoremap <silent> + ]
nnoremap <silent> * }

" nnoremap <silent> : ,
nnoremap <silent> , :
nnoremap <silent> <leader>k1 <F1>

nnoremap <silent><C-l> :bnext<cr>
nnoremap <silent><C-h> :bprev<cr>

" Dont use Q for Ex mode
map Q :q

" Run current buffer
nnoremap <leader>e :!clear ; %:p<cr>

" Alway clear shell screen
nnoremap :! :!clear; 

"### Statusline ################################################################

" Avoid 'hit enter prompt'
set shortmess=atTIW

" Increase ruler height
set cmdheight=2

set laststatus=2

" Always show ruler (right part of the command line)
" set ruler

set statusline=\ 

" Containing directory
set statusline+=%{Location()}

" TODO using an echo in statusline removes old messages - maybe a way to
" suppress stuff?

function! Location()

    let l:fn = "/home/user/src/dotvim/vimrc"
    let l:fn = "/usr/share/vim/vim74/doc/change.txt"
    let l:fn = "/home/user/src/dotvim/plugin/BufferCloseSanely.vim"
    let l:fn = "/home/user/src/dotvim/after/plugin/Ack.vim"
    let l:fn = "/home/user/bashrc"
    let l:fn = expand("%:p")

    let l:prefix = ""
    let l:dirname = ""

    " let l:fn = substitute(l:fn, $HOME . "/src/", "", "")
    let l:fn = substitute(l:fn, "/home", "", "")

    let l:dirs = split(fnamemodify(l:fn, ":h"), "/")
    let l:basename = fnamemodify(l:fn,':t:h')

    if len(l:dirs) == 0
        let l:dirname= "~"
    elseif len(l:dirs) == 1
        let l:prefix = dirs[0]
    elseif len(l:dirs) == 2
        let l:prefix = dirs[0]
        let l:dirname = dirs[1]
    elseif len(l:dirs) > 2
        let l:prefix = dirs[2]
        if len(dirs) > 3
            let l:dirname = dirs[len(dirs) - 1]
        endif
    endif

     if l:dirname != ""
         let l:dirname .= "/"
     endif

    if l:prefix != ""
        let l:prefix .= ":"
    endif

    let l:fn = l:prefix . l:dirname . l:basename
    return l:fn

endfunction

" Tail of the filename
" set statusline+=%t

" Separator
set statusline+=\ 

" Set color of error highlight group
set statusline+=%#errormsg#

" read only flag
" set statusline+=%{filewritable(expand('\%'))?'':'RO'}

" Reset color
set statusline+=%*

" left/right separator
set statusline+=%=

" filetype
set statusline+=%{strlen(&filetype)?&filetype.'\ ':''}
set statusline+=%{strlen(&syntax)?&syntax.'\ ':''}

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

set statusline+=\ 

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

    " EasyMotion and friends
    Plugin 'lokaltog/vim-easymotion'
    " Plugin 't9md/vim-smalls'
    Plugin 'justinmk/vim-sneak'

" let g:sneak#streak = 1

    " Search and display information from arbitrary sources
    Plugin 'shougo/unite.vim'

    " Most recently used plugin for unite.vim
    Plugin 'shougo/neomru.vim'

    " Provides your Vim's buffer with the outline view
    Plugin 'shougo/unite-outline'

    " Perl omni completion
    Plugin 'c9s/perlomni.vim'

    " Select tags or select files including tags
    Plugin 'tsukkee/unite-tag'

    " Lean & mean status/tabline for vim that's light as air.
    " Plugin 'bling/vim-airline'

    " Plugin 'scrooloose/nerdtree'

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

    " Quickfix
    Plugin 'sgur/unite-qf'

    " Show the syntax group name of the item under cursor
    " :call SyntaxAttr()<CR>
    Plugin 'vim-scripts/SyntaxAttr.vim'

    " Support perl regexes
    Plugin 'vim-scripts/eregex.vim'

    " Define temporary keymaps
    Plugin 'tomtom/tinykeymap_vim'

    " Mappings for simultaneously pressed keys
    " Plugin 'kana/vim-arpeggio'

    " Plugin 'fholgado/minibufexpl.vim'
    " let g:miniBufExplVSplit = 20   " column width in chars

    " Highlight ANSI escape sequences in their respective colors
    " Plugin 'vim-scripts/AnsiEsc.vim'
    Plugin 'powerman/vim-plugin-AnsiEsc'
 

"### Install bundles ###########################################################

    if iCanHazVundle == 0
        echo "Installing Bundles, please ignore key map error messages"
        echo ""
        :PluginInstall
    endif

"###############################################################################
