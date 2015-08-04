"### misc ######################################################################

" vars
let g:MY_VIM_BUNDLE = $REMOTE_HOME . "/.vim/bundle/"
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

" Show trailing whitespace as red
highlight ExtraWhitespace ctermbg=darkred guibg=#382424
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/

set runtimepath+=$REMOTE_HOME/.vim/etc
set runtimepath+=$REMOTE_HOME/.vim/etc/after

" Add system PATH to vim path to be used by :find
let &path = &path . ",**," . $HOME . "/src/**" . "," . substitute($PATH, ':', ',', 'g')

" Reload vimrc on write
" autocmd BufWritePost vimrc source %

" set colorcolumn=81

" Prevent creation of .netrwhist file
let g:netrw_dirhistmax = 0

" prevent vim from using javascript as filetype for json
" au BufRead,BufNewFile *.json set filetype=json | setlocal syntax=txt

" Recognize .md as markdown for vim < 7.4.480
" au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown

" Make the clipboard register the same as the default register
" this allows easy copy to other x11 apps
set clipboard=unnamed

" Chdir to the dir of the current buffer
" set autochdir
autocmd BufEnter * silent! execute "lcd %:p:h:gs/ /\\ /

" A history of ":" commands, and a history of previous search patterns
set history=1000

" Show line numbers
" set number
" Relative line numbers
" set rnu

" allow the cursor to pass the last character
set virtualedit=onemore

" Set to auto read when a file is changed from the outside
set autoread

" Automatically write file if leaving a buffer
set autowriteall

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
" set sidescroll=1

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

set hidden
" set winheight=9999
" set winminheight=10

" autocmd * qf set winheight=10
autocmd FileType qf set winheight=10
autocmd FileType help set buflisted | only
autocmd BufCreate * set buflisted | only

" " Epic
" augroup forceSingleWindowMode
"     autocmd!
"     autocmd BufCreate,BufAdd,BufEnter *
"         \ if bufname("%") !~ "Location List"
"         \     | set buflisted
"         \     | only
"         \ | endif
" augroup END
"         " \     | resize
"         " \     | set nowinfixheight

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

" Make macros render faster (lazy draw)
set lazyredraw

set display=lastline,uhex

" Vim will wrap long lines at a character in 'breakat'
set linebreak
let &showbreak=repeat(' ', 10) . ">>> "
" TODO next vim: "This feature has been implemented on June 25, 2014 as patch 7.4.338"
" (https://stackoverflow.com/questions/1204149/smart-wrap-in-vim)

set mouse=nvi
set mousemodel=popup

"### searching #################################################################

" Show matching brackets.
set showmatch

" Don't blink when matching
set matchtime=0

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

" Timeout on mappings and key codes (faster escape etc)
set timeout
set timeoutlen=300
set ttimeoutlen=10

" Use <Leader> as prefix key for own key mappings
let mapleader = " "

nnoremap <silent> <ESC><ESC> <Nop>
nnoremap <silent> <leader>l :Explore<cr>

vnoremap - /\v
vnoremap , :
nnoremap - /\v
nnoremap , :

nnoremap <leader>k1 <F1>

nnoremap <silent><C-l> :bnext<cr>
nnoremap <silent><C-h> :bprev<cr>

" Dont use Q for Ex mode
nnoremap Q <Nop>

" nnoremap <silent> / -
" nnoremap <silent> _ ?
" nnoremap <silent> ? _

" nnoremap <silent> Ö :
" nnoremap <silent> ö ;

" nnoremap <silent> Ä "
" nnoremap <silent> ä '

" nnoremap <silent> ü [
" nnoremap <silent> Ü {

" nnoremap <silent> + ]
" nnoremap <silent> * }

" nnoremap <silent> ( *

" nnoremap <silent> : ,

" These are the same for vim
" Tab and Ctrl-I
" Enter and Ctrl-M
" Esc and Ctrl-[ 

" Clear all mappings
" :mapclear

" nnoremap <silent> w /(\@<=\W)\w<cr>
" nnoremap <silent> jj }
" nnoremap <silent> kk {

" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$

"### Statusline ################################################################

" Avoid 'hit enter prompt'
set shortmess=atTIW

" Increase ruler height
set cmdheight=2

" always show status line
set laststatus=2

" always show tab page labels
set showtabline=2

" No menus, scrollbars, or other junk
set guioptions=

" disables the GUI tab line in favor of the plain text version
set guioptions-=e

" Always show ruler (right part of the command line)
" set ruler

set statusline=\ 

" too slow needs to be ss
" set statusline+=%{system('git-project')}

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
" set statusline+=%{strlen(&syntax)?&syntax.'\ ':''}

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
    Plugin 'scrooloose/syntastic'

    " A Git wrapper so awesome, it should be illegal
    Plugin 'tpope/vim-fugitive'

    " ack support
    Plugin 'mileszs/ack.vim'

    " Prerequisite for some vim plugins
    Plugin 'l9'

    " Next generation completion framework
    Plugin 'Shougo/neocomplete.vim'

    " Universal syntax script for all txt docs, logs and other types
    Plugin 'txt.vim'

    " EasyMotion and friends
    Plugin 'lokaltog/vim-easymotion'
    " Plugin 't9md/vim-smalls'
    Plugin 'justinmk/vim-sneak'

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

    " Vim sugar for the UNIX shell commands
    Plugin 'tpope/vim-eunuch'

    " Bringing GVim colorschemes to the terminal
    " Plugin 'godlygeek/csapprox'

    " Use GUI Color Schemes in Supported Terminals
    Plugin 'KevinGoodsell/vim-csexact'

    " Colorschemes
    " Plugin 'altercation/vim-colors-solarized'
    Plugin 'jonathanfilip/vim-lucius'

    " cycle through (almost) all available colorschemes
    " :CycleColorNext
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

    " Forget Vim tabs – now you can have buffer tabs
    Plugin 'ap/vim-buftabline'

    " Tern plugin for Vim
    " Plugin 'marijnh/tern_for_vim'

    " Sometimes, it's useful to line up text.
    Plugin 'godlygeek/tabular'

    " Vim Markdown runtime files 
    Plugin 'tpope/vim-markdown'

    " Gundo.vim is Vim plugin to visualize your Vim undo tree.
    Plugin 'sjl/gundo.vim'

    " Comment stuff out.
    Plugin 'tpope/vim-commentary'

    " asynchronous build and test dispatcher
    Plugin 'tpope/vim-dispatch'

    " Configurable and extensible tab line and status line
    " Plugin 'tpope/vim-flagship'

    " Vim Cucumber runtime files
    Plugin 'tpope/vim-cucumber'

    " Unicode character metadata
    " (press ga on top a character)
    Plugin 'tpope/vim-characterize'

    " Semantic Highlighting
    Plugin 'jaxbot/semantic-highlight.vim'

    " Seamless navigation between tmux panes and vim splits
    " TODO Plugin 'christoomey/vim-tmux-navigator'

    " a Vim plugin for making Vim plugins
    Plugin 'tpope/vim-scriptease'

    " Autocomplete for Node.js
    Plugin 'myhere/vim-nodejs-complete'
    " Easy node module opening
    Plugin 'moll/vim-node'
    " Better JavaScript syntax handling
    Plugin 'jelera/vim-javascript-syntax'
    " CoffeeScript support
    Plugin 'kchmck/vim-coffee-script'
    " Better JSON handling
    Plugin 'elzr/vim-json'
    " Support library for above
    Plugin 'pangloss/vim-javascript'

    " codesearch source for unite.vim
    Plugin 'junkblocker/unite-codesearch'

    " Changes Vim working directory to project root
    Plugin 'airblade/vim-rooter'

    " quoting/parenthesizing made simple
    Plugin 'tpope/vim-surround'

    " enable repeating supported plugin maps with "." 
    Plugin 'tpope/vim-repeat'

    " HTML5 omnicomplete and syntax
    Plugin 'othree/html5.vim'

    " Vim's MatchParen for HTML tags
    Plugin 'gregsexton/MatchTag'

    "TODO checkout:
    " Plugin 'tpope/vim-unimpaired'

    " super simple vim plugin to show the list of buffers in the command bar
    Plugin 'bling/vim-bufferline'

    " provides insert mode auto-completion for quotes, parens, brackets, etc.
    Plugin 'Raimondi/delimitMate'

"### Install bundles ###########################################################

    if iCanHazVundle == 0
        echo "Installing Bundles, please ignore key map error messages"
        echo ""
        :PluginInstall
    endif

"### Install bundles ###########################################################

" syntax on

" Detect filetypes and run filetype plugins
filetype on
filetype plugin on
filetype indent on

"###############################################################################
