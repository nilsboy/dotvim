"### misc ######################################################################

" Create a directory if it does not exist jet
function! _mkdir(path)
if !isdirectory(expand(a:path))
  call mkdir(expand(a:path))
endif
endfunction

" vars
let g:vim           = {}
let g:vim.dir       = $REMOTE_HOME . "/.vim/"
let g:vim['etc']    = { 'dir' : g:vim.dir . "etc/" }
let g:vim.rc        = g:vim.etc.dir . "vimrc"
let g:vim.rc_local  = g:vim.rc . ".local"
let g:vim['var']    = { 'dir' : g:vim.dir . "var/" }
let g:vim['plugin'] = { 'dir' : g:vim.etc.dir . "plugin/" }
let g:vim.bundle = {}
let g:vim.bundle.dir =  g:vim.dir . "bundle/"
let g:vim.bundle.settings = {}
let g:vim.bundle.settings.dir = g:vim.etc.dir . "bundle/"
let g:vim['cache']  = { 'dir' : $REMOTE_HOME . "/.cache/vim" }

call _mkdir(g:vim.dir)
call _mkdir(g:vim.etc.dir)
call _mkdir(g:vim.var.dir)
call _mkdir(g:vim.cache.dir)

" reset everything to their defaults
set all&

let g:vim['tags']   = g:vim.var.dir . "tags"
let &tags = g:vim.tags
set showfulltag

" Keep undo history after closing a file
set undofile
let &undodir = g:vim.var.dir . "undo"
call _mkdir(&undodir)

" Security
set modelines=0

" Enable vim enhancements
set nocompatible

" Force 256 colors for terminals that call themselfs TERM=xterm
set t_Co=256

" Show trailing whitespace as red
" highlight ExtraWhitespace ctermbg=darkred guibg=#382424
" autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
" autocmd BufWinEnter * match ExtraWhitespace /\s\+$/

" TODO paths
set runtimepath+=$REMOTE_HOME/.vim/etc
set runtimepath+=$REMOTE_HOME/.vim/etc/after

" TODO paths
" Add system PATH to vim path to be used by :find
let &path = &path . ",**," . $HOME . "/src/**" . "," . substitute($PATH, ':', ',', 'g')

" Reload vimrc on write
" autocmd BufWritePost vimrc source %

" set colorcolumn=81

" Prevent creation of .netrwhist file
let g:netrw_dirhistmax = 0

" prevent vim from using javascript as filetype for json
" au BufRead,BufNewFile *.json setlocal filetype=json | setlocal syntax=txt

" Recognize .md as markdown for vim < 7.4.480
" au BufNewFile,BufFilePre,BufRead *.md setloal filetype=markdown

" Make the clipboard register the same as the default register
" this allows easy copy to other x11 apps
set clipboard=unnamed

" Chdir to the dir of the current buffer
" set autochdir
" autocmd BufEnter * silent! execute "lcd %:p:h:gs/ /\\ /

" Expand current dir
cabbrev <expr> ./ expand('%:p:h')

" A history of ":" commands, and a history of previous search patterns
set history=1000

" Show line numbers
" set number
" Relative line numbers
" set rnu

" allow the cursor to pass the last character
" set virtualedit=onemore

" Set to auto read when a file is changed from the outside
set autoread

" Automatically write file if leaving a buffer
set autowriteall

" Leave my cursor where it was - even on page jump
set nostartofline

" Insert spaces when the tab key is hit
set expandtab

" automatically indent to match adjacent lines
set autoindent

" use shiftwidth to enter tabs
set smarttab

" Tab spacing of 4
set tabstop=4

" number of spaces per tab in insert mode
set softtabstop=4

" Shift width (moved sideways for the shift command)
set shiftwidth=4

" Make backspace more flexible
set backspace=indent,eol,start

" show list for autocomplete
set wildmenu

" Use tab expansion in vim prompts
set wildmode=longest:list

" Ignore case in file names
set wildignorecase

" Ignore patterns
" set wildignore=.*,*.class,*/node_modules/*,./node_modules/*

set splitbelow
set splitright

" No line wrapping of long lines
set wrap

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
set t_vb=

" assume fast terminal connection
set ttyfast

" Keep cursor position (if possible) when executing certain commands
set nostartofline

set hidden
" set winheight=9999
" set winminheight=10

autocmd FileType qf setlocal winheight=20
autocmd FileType help setlocal buflisted | only
" autocmd BufCreate * setlocal buflisted | only

" " Epic
" augroup forceSingleWindowMode
"     autocmd!
"     autocmd BufCreate,BufAdd,BufEnter *
"         \ if bufname("%") !~ "Location List"
"         \     | setlocal buflisted
"         \     | only
"         \ | endif
" augroup END
"         " \     | resize
"         " \     | setlocal nowinfixheight

" Highlight unknown filetypes as text
autocmd! BufEnter * if &syntax == '' | setlocal syntax=txt | endif

" Highlight vim documentation even if opened directly from file
autocmd! BufEnter *vim*/doc/*.txt setlocal filetype=help

" show count of selected lines / columns
set showcmd

" Make macros render faster (lazy draw)
set lazyredraw

set display=lastline,uhex

" Vim will wrap long lines at a character in 'breakat'
set nolist
set linebreak
set breakat&vim
let &showbreak=repeat(' ', 10) . "↪ "
" TODO next vim:
" This feature has been implemented on June 25, 2014 as patch 7.4.338"
" (https://stackoverflow.com/questions/1204149/smart-wrap-in-vim)

" set mouse=nvi
" set mousemodel=popup

" hide mouse when characters are typed
set mousehide

" always assume decimal numbers
set nrformats-=octal

" Determine how text with the "conceal" syntax attribute
set conceallevel=1
set listchars+=conceal:Δ

set guifont=Monospace\ 13

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
" use <leader>! as prefix to remap stuff - like:
" nnoremap ,!a <C-i>
let mapleader = ","

" map <silent> q <esc>
" inoremap <silent> jj <esc>
nnoremap <silent> <ESC><ESC> <Nop>
nnoremap <silent> <leader>l :Explore<cr>

" use saner regexes
" TODO checkout bundle 'vim-scripts/eregex.vim'
" vnoremap . :
" nnoremap . :
nnoremap ,, :

vnoremap - /\v
nnoremap - /\v

nnoremap / /\v
vnoremap / /\v

" vnoremap _ ?\v
" nnoremap _ ?\v

nnoremap ? ?\v
vnoremap ? ?\v
nnoremap :s/ :s/\v

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
" Tab and Ctrl-I (<c-i><c-I>)
" Enter and Ctrl-M (<c-m>)
" Esc and Ctrl-[ (<c-[>)

" Clear all mappings
" :mapclear

" nnoremap <silent> w /(\@<=\W)\w<cr>
" nnoremap <silent> jj }
" nnoremap <silent> kk {

" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$

nnoremap <silent><leader>i :!firefox "https://duckduckgo.com/?
    \q=<cword>"<cr><cr>

" eval vimscript by line or visual selection
nmap <silent> <leader>e :call Source(line('.'), line('.'))<CR>
vmap <silent> <leader>e :call Source(line('v'), line('.'))<CR>

" reselect visual block after indent
vnoremap < <gv
vnoremap > >gv

" hide annoying quit message
nnoremap <C-c> <C-c>:echo<cr>

"### Statusline ################################################################

" Avoid 'hit enter prompt'
set shortmess=atTIW

" Increase ruler height
set cmdheight=2

" always show status line
set laststatus=2

" always show tab page labels
set showtabline=2

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

"### Cursor ##################################################################

" use an orange cursor in insert mode
" TODO let &t_SI = "\<Esc>]12;red\x7"
" use a red cursor otherwise
" TODO let &t_EI = "\<Esc>]12;orange\x7"
" silent !echo -ne "\033]12;red\007"
" reset cursor when vim exits
" autocmd VimLeave * silent !echo -ne "\033]12;gray\007"

" use \003]12;gray\007 for gnome-terminal
" solid underscore
" let &t_SI .= "\<Esc>[4 q"
" let &t_EI .= "\<Esc>[6 q"
" 2 -> solid block
" 1 or 0 -> blinking block
" 3 -> blinking underscore
" Recent versions of xterm (282 or above) also support
" 5 -> blinking vertical bar
" 6 -> solid vertical bar

" setlocal cursorline
" autocmd WinLeave * setlocal nocursorline
" autocmd WinEnter * setlocal cursorline

" Disable all blinking:
set guicursor+=a:blinkon0

"### Gui mode ##################################################################

" No menus, scrollbars, or other junk
set guioptions=

" disables the GUI tab line in favor of the plain text version
set guioptions-=e

"### plugin manager "###########################################################

function! IsPluginInstalled(path)
    let l:basename = fnamemodify(a:path,':t:h')
    if isdirectory(g:vim.bundle.dir . l:basename)
        return 1
    endif 
    return 0
endfunction

if !IsPluginInstalled("neobundle.vim")
    echo "Installing NeoBundle..."
    echo ""
    silent !mkdir -p "$g:vim.bundle.dir"
    execute "!git clone https://github.com/Shougo/neobundle.vim " .
            \ g:vim.bundle.dir . "/neobundle.vim"
endif
execute "set runtimepath+=" . g:vim.bundle.dir . "/neobundle.vim/"

" Required:
call neobundle#begin(g:vim.bundle.dir)

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

for fpath in split(globpath(g:vim.bundle.settings.dir, '*.vim'), '\n')
    " echo "sourcing " . fpath
    execute 'source' fpath
endfor

call neobundle#end()

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck

" Remove installed plugins that are not configured anymore
" NeoBundleClean!

"###############################################################################

" Detect filetypes and run filetype plugins
filetype on
filetype plugin on
filetype indent on

" colorscheme lucius

if filereadable(g:vim.rc_local)
  execute "source " . g:vim.rc_local
endif

" has to be done last - it is set somewhere else before already
let &viminfo="'50,<1000,s100,:100,n" . g:vim.var.dir . "viminfo"

"###############################################################################
