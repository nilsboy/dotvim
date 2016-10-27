"### misc ######################################################################

" set verbosefile=/tmp/vim-debug.txt
" set verbose=15

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
let g:vim['after']    = { 'dir' : g:vim.dir . "after/" }
let g:vim.rc        = g:vim.etc.dir . "vimrc"
let g:vim.rc_local  = $REMOTE_HOME . "/.vimrc.local"
let g:vim['var']    = { 'dir' : g:vim.dir . "var/" }
let g:vim['plugin'] = { 'dir' : g:vim.etc.dir . "plugin/" }

let $MYVIMRC = g:vim.rc

let g:vim.bundle = {}
let g:vim.bundle.dir =  g:vim.dir . "bundle/"
let g:vim.bundle.settings = {}
let g:vim.bundle.settings.dir = g:vim.etc.dir . "bundle_config/"
let $_VIM_BUNDLE_DIR = g:vim.bundle.dir

let g:vim.config = {}
let g:vim.config.dir = g:vim.etc.dir . "config/"

" TODO change to $XDG_CACHE_HOME
" TODO use $XDG_CACHE_DIR
let g:vim['cache']  = { 'dir' : $REMOTE_HOME . "/.cache/vim/" }

" Log autocmds etc to file
" let &verbosefile = g:vim.var.dir . "/verbose.log"
" let &verbose = 15

call _mkdir(g:vim.dir)
call _mkdir(g:vim.etc.dir)
call _mkdir(g:vim.var.dir)
call _mkdir(g:vim.cache.dir)

" Remove all existing autocommands on vimrc reload
autocmd!

" reset everything to their defaults
set all&

let g:vim['tags']   = g:vim.var.dir . "tags"
let &tags = g:vim.tags
set showfulltag

" Keep undo history after closing a file
set undofile
let &undodir = g:vim.var.dir . "undo"
call _mkdir(&undodir)

" nomodeline can not be revered by plugins
" but modeline is needed by dbext even though it uses its own parser.
" set nomodeline

" Enable vim enhancements
set nocompatible

execute "set runtimepath+=" . g:vim.etc.dir
execute "set runtimepath+=" . g:vim.after.dir

" Reload vimrc on write
" autocmd BufWritePost vimrc source $MYVIMRC

" set colorcolumn=81

" Prevent creation of .netrwhist file
let g:netrw_dirhistmax = 0

" Use gx to open any file under cursor in appropriate app
let g:netrw_browsex_viewer="xdg-open"

" prevent vim from using javascript as filetype for json
autocmd BufRead,BufNewFile *.{json,handlebars} setlocal filetype=json
autocmd BufRead,BufNewFile .tern-project setlocal filetype=json
autocmd BufRead,BufNewFile *.swagger.{yaml,json} setlocal filetype=swagger

" Make the clipboard register the same as the default register
" this allows easy copy to other x11 apps
set clipboard=unnamed

" Chdir to the dir of the current buffer
" set autochdir
" autocmd BufEnter * silent! execute "lcd %:p:h:gs/ /\\ /

" Expand current dir
cabbrev <expr> ./ expand('%:p:h')
cabbrev <expr> fn expand('%:p')

" A history of ":" commands, and a history of previous search patterns
set history=1000

" Show line numbers
" set number
" Relative line numbers
" set rnu

" allow the cursor to pass the last character
" set virtualedit=onemore

" Set reload a file when it is changed from the outside
set autoread

" Automatically write file if leaving a buffer
set autowriteall

" Leave cursor where it was - even on page jump
set nostartofline

" Insert spaces when the tab key is hit
set expandtab

" automatically indent to match adjacent lines
set autoindent

" use shiftwidth to enter tabs
set smarttab

" Tab spacing
set tabstop=2

" Number of spaces per tab in insert mode
set softtabstop=2

" Shift width (moved sideways for the shift command)
set shiftwidth=2

" set textwidth=80

" Make backspace more flexible
set backspace=indent,eol,start

" show list for autocomplete
set wildmenu

" Use tab expansion in vim prompts
set wildmode=longest:list

" Ignore case in file names
set wildignorecase

" Ignore patterns
" set wildignore+=.*/**,*.class,node_modules/**,*/target/classes/**
set wildignore+=*.class,*/target/classes/**

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
set iskeyword+=_,$,@,%,#

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

" only show 1 line for minimized windows
" set winminheight=0

" autocmd BufAdd * setlocal buflisted
" autocmd FileType qf setlocal winheight=20

" autocmd BufCreate,BufAdd,BufEnter * if expand('%') ==# '' | setlocal nobuflisted | endif
" autocmd BufNew,BufCreate,BufAdd,BufEnter * if &previewwindow | setlocal nobuflisted | endif

" Turn off previewwindow for completion
set completeopt-=preview

" Use tab key to move down in popup menu
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" Set preview window height
" set previewheight=99

" Highlight unknown filetypes as text
autocmd! BufAdd * if &syntax == '' | setlocal syntax=txt | endif

" Set filetype on vimdocs even when opened directly from file
autocmd! BufAdd *vim*/doc/*.txt setlocal filetype=help

" show count of selected lines / columns
set showcmd

" Make macros render faster (lazy draw)
" set lazyredraw

set display=lastline,uhex

" Vim will wrap long lines at a character in 'breakat'
set nolist
set linebreak
set breakat&vim
let &showbreak=repeat(' ', 10) . "↪ "
" Next vim:
" This feature has been implemented on June 25, 2014 as patch 7.4.338"
" (https://stackoverflow.com/questions/1204149/smart-wrap-in-vim)

" set mouse=nvi
" set mousemodel=popup

" hide mouse when characters are typed
set mousehide

" Disable mouse
set mouse=

" always assume decimal numbers
set nrformats-=octal

" Determine how text with the "conceal" syntax attribute is shown
" set conceallevel=1
" set listchars+=conceal:Δ

set guifont=Monospace\ 13

set isfname-==

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

" Switch window if it contains wanted buffer
set switchbuf=useopen

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

" For a list of vim's internal mappings see:
" :h index

" Potentially usable keys for normal mode:
" sSQZ <cr> <bs>
" - r
" - R - I do use it but should use c-mappings instead
" - M

" Timeout on mappings and key codes (faster escape etc)
" set timeout
" set timeoutlen=300
" set ttimeoutlen=10

" used for the CursorHold autocommand event
set updatetime=1000

" Use <Leader> as prefix key for own key mappings
" use <leader>! as prefix to remap stuff - like:
" nnoremap ,!a <C-i>
" let mapleader = "\"

" use saner regexes
" TODO checkout bundle 'vim-scripts/eregex.vim'
" vnoremap . :
" nnoremap . :

nnoremap :s/ :s/\V

" nnoremap <leader>z :wall<cr><c-z>
nnoremap <c-z> :wall<cr><c-z>
inoremap <c-z> <esc>:wall<cr><c-z>

nnoremap <space> <c-f>
vnoremap <space> <c-f>
nnoremap <bs> <c-b>
vnoremap <bs> <c-b>
nnoremap M <c-b>
vnoremap M <c-b>

" Save file as root
command! -nargs=* WW :silent call WriteSudo()
function! WriteSudo() abort
    silent write !env SUDO_EDITOR=tee sudo -e % >/dev/null
    let &modified = v:shell_error
endfunction

" Expanding left shift does not work like this
" nnoremap < <shift>

" Does not work on terminal vim
nnoremap <s-space> <C-b>

nmap <silent>L :bnext<cr>
nmap <silent>H :bprev<cr>

" Remap <C-i> as it's the same as Tab
nnoremap <leader>!a <C-o>
nnoremap <leader>!b <C-i>

" nmap <silent><C-j> <leader>!a
" nmap <silent><C-k> <leader>!b

nnoremap <silent> <leader>ww :wincmd w<cr>
nnoremap <silent> <leader>wo :only<cr>

nnoremap <silent> <leader>wj :wincmd j<cr>
nnoremap <silent> <leader>wk :wincmd k<cr>
nnoremap <silent> <leader>wh :wincmd h<cr>
nnoremap <silent> <leader>wl :wincmd l<cr>

nnoremap <silent> <leader>x :Autoformat \| :Neomake<cr>

" Never use formatprg (it's global) and don't fallback to vim default
set formatprg=false

" Use <leader>c to get rid of ctrl mappings
nnoremap <silent> <leader>cv <c-v>
nnoremap <silent> <leader>cp <c-p>
nnoremap <silent> <leader>cn <c-n>
nnoremap <silent> <leader>cr <c-r>
nnoremap <silent> <leader>ct <c-t>
nnoremap <silent> <leader>c] <c-]>

" Nicer redo
nnoremap U <c-r>

" Dont use Q for Ex mode
nnoremap Q :xa<cr>

" These are the same for vim
" Tab and Ctrl-I (<c-i><c-I>)
" Enter and Ctrl-M (<c-m>)
" Esc and Ctrl-[ (<c-[>)

" Clear all mappings
" :mapclear

" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$

" make . work with visually selected lines
xnoremap . :norm.<CR>
" nnoremap <nowait><leader>b :ls!<cr>:b<space>

nnoremap <silent><leader>if :!firefox "https://duckduckgo.com/?q=<cword> site:stackoverflow.com"<cr><cr>
nnoremap <silent><leader>is :execute ":RunIntoBuffer so-lucky ". expand("<cword>") . " [" . &filetype . "]"<cr>

" Run current buffer in the shell
nnoremap <silent><leader>ee :RunCurrentBuffer<cr>
" Run current line in the shell
nnoremap <silent><leader>el :RunCursorLine<cr>
" Run current line as vim script
nnoremap <silent><leader>ev :RunCursorLineVim<cr>

" Don't wait after escape in insert mode
" Breaks curser keys etc.
set noesckeys

" Close buffer
"Mapping <esc> in vimrc breaks arrow behaviour"
"(http://stackoverflow.com/questions/11940801)
nnoremap <silent><esc> :call BufferClose()<cr>
"
" Causes delay
" nnoremap <esc>[ <esc>[

" Open command-line window
" :h cmdline-window
nnoremap <leader><leader> q:i
vnoremap <leader><leader> q:i
set cmdwinheight=10
" autocmd CmdwinEnter * inoremap <buffer><silent> <tab> <esc>:quit<cr>
autocmd CmdwinEnter * nnoremap <buffer><silent> <tab> :quit<cr>

autocmd CmdwinEnter * nmap <buffer><silent> <c-h> :quit<cr><c-h>
autocmd CmdwinEnter * nmap <buffer><silent> <c-j> :quit<cr><c-j>
autocmd CmdwinEnter * nmap <buffer><silent> <c-k> :quit<cr>
autocmd CmdwinEnter * nmap <buffer><silent> <c-l> :quit<cr><c-l>

autocmd CmdwinEnter * imap <buffer><silent> <c-h> <esc>:quit<cr><c-h>
autocmd CmdwinEnter * imap <buffer><silent> <c-j> <esc>:quit<cr><c-j>
autocmd CmdwinEnter * imap <buffer><silent> <c-k> <esc>:quit<cr>
autocmd CmdwinEnter * imap <buffer><silent> <c-l> <esc>:quit<cr><c-l>

nnoremap / q/i\V
vnoremap / q/i\V

nnoremap ? ?\V
vnoremap ? ?\V

" Reselect visual block after indent
vnoremap < <gv
vnoremap > >gv

" hide annoying quit message
nnoremap <C-c> <C-c>:echo<cr>

" always search forward and N backward, use this
nnoremap <expr> n 'Nn'[v:searchforward]
nnoremap <expr> N 'nN'[v:searchforward]

" Make gf work with relative file names and non existent files
nnoremap <leader>gf :execute ":edit " . expand('%:h') . '/' . expand('<cfile>')<cr>

" nnoremap <leader>b :ls<cr>:b

nnoremap ' `
nnoremap ` '

" Keep cursor position after visual yank
vmap y ygv<Esc>

nnoremap <leader>lr :%s/<C-r><C-w>/

nnoremap MM :Messages<cr> \| :only \| :normal G<cr>

nnoremap <C-j> 7j
nnoremap <C-k> 7k

" Edit file under cursor even if it does not exist
nnoremap <leader>gf :execute ":E " . expand("<cfile>")<cr>

" Easier change and replace word
nnoremap c* *Ncgn
nnoremap c# #NcgN
nnoremap cg* g*Ncgn
nnoremap cg# g#NcgN

" TODO
nnoremap <leader>* /\<<C-R>=expand('<cword>')<CR>\><CR>
nnoremap <leader># ?\<<C-R>=expand('<cword>')<CR>\><CR>

"### Misc ######################################################################

command! -nargs=* RemoveTrailingSpaces :%s/\s\+$//e

"### Statusline ################################################################

" Avoid 'hit enter prompt'
set shortmess=atTIW

" Increase ruler height
" set cmdheight=2

" always show status line
set laststatus=2

" always show tab page labels
set showtabline=2

" Prevent mode info messages on the last line to prevent 'hit enter prompt'
set noshowmode

" Always show ruler (right part of the command line)
" set ruler

" TODO using an echo in statusline removes old messages - maybe a way to
" suppress stuff?

" too slow needs to be ss
" set statusline+=%{system('git-project')}

" Containing directory
set statusline+=%{Location()}

" set statusline+=%{pwd()}

" Tail of the filename
" set statusline+=%t

" Separator
set statusline+=" "

" Set color of error highlight group
set statusline+=%#errormsg#

" read only flag
" set statusline+=%{filewritable(expand('\%'))?'':'RO'}

" Reset color
set statusline+=%*

" left/right separator
set statusline+=%=

" filetype
set statusline+=%{strlen(&filetype)?&filetype:''}
" set statusline+=%{strlen(&syntax)?&syntax.'\ ':''}

" region filetype
set statusline+=%{exists(\"b:region_filetype\")?'/'.b:region_filetype.'\ ':''}

" file encoding
set statusline+=%{&enc=='utf-8'?'':&enc.'\ '}

" File format
set statusline+=%{&ff=='unix'?'':&ff.'\ '}

" Cursor line/total lines
set statusline+=\ \ \ \ \ %l

" Cursor column
set statusline+=:%c

" Percent through file
set statusline+=\ \ \ \ \ %P/%L

function! Location() abort

    let l:fn = "/home/user/src/dotvim/vimrc"
    let l:fn = "/usr/share/vim/vim74/doc/change.txt"
    let l:fn = "/home/user/src/dotvim/plugin/BufferCloseSanely.vim"
    let l:fn = "/home/user/src/dotvim/after/plugin/Ack.vim"
    let l:fn = "/home/user/bashrc"
    let l:fn = expand("%:p")

    return l:fn

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

"### Cursor ##################################################################

autocmd InsertLeave,WinEnter,BufEnter * setlocal cursorline
autocmd InsertEnter * setlocal nocursorline

" Disable all blinking
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
    silent execute "!mkdir -p " g:vim.bundle.dir
    execute "!git clone https://github.com/Shougo/neobundle.vim " .
                \ g:vim.bundle.dir . "/neobundle.vim"
endif
execute "set runtimepath+=" . g:vim.bundle.dir . "/neobundle.vim/"

" Required:
call neobundle#begin(g:vim.bundle.dir)

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" TODO checkout runtime! *.vim
" execute "runtime! " . g:vim.bundle.settings.dir . "/*.vim"
for fpath in split(globpath(g:vim.bundle.settings.dir, '*.vim'), '\n')
    execute 'source' fpath
endfor

call neobundle#end()

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck

" Remove installed plugins that are not configured anymore
" NeoBundleClean!

"### my config #################################################################

" stuff to load after the bundles

for fpath in split(globpath(g:vim.config.dir, '*.vim'), '\n')
    execute 'source' fpath
endfor

"###############################################################################

" Detect filetypes and run filetype plugins
filetype on
filetype plugin on
filetype indent on

" Modlines might be dangerous
" see also securemodelines.vim
set modelines=0

if filereadable(g:vim.rc_local)
    execute "source " . g:vim.rc_local
endif

" has to be done last - it is set somewhere else before already
" let &viminfo="'50,<1000,s100,:100,n" . g:vim.var.dir . "viminfo"

"###############################################################################
