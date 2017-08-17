"### Debugging

" set verbosefile=/tmp/vim-debug.log
" set verbose=15
" set verbose=9
" set verbose=1

"### Misc

if empty($XDG_CONFIG_HOME)
    let $XDG_CONFIG_HOME = $REMOTE_HOME . "/.config"
endif

if empty($XDG_DATA_HOME)
    let $XDG_DATA_HOME = $REMOTE_HOME . "/.local/share"
endif

if empty($XDG_CACHE_DIR)
    let $XDG_CACHE_DIR = $REMOTE_HOME . "/.cache"
endif

" vars
let g:vim           = {}
let g:vim.dir       = $REMOTE_HOME . "/.vim/"
let g:vim['etc']    = { 'dir' : g:vim.dir . "etc/" }
let g:vim['after']  = { 'dir' : g:vim.etc.dir . "after/" }
let g:vim.rc        = g:vim.etc.dir . "vimrc"
let g:vim.rc_local  = $REMOTE_HOME . "/.vimrc.local"
let g:vim['var']    = { 'dir' : $XDG_DATA_HOME . '/vim/' }
let g:vim['plugin'] = { 'dir' : g:vim.etc.dir . "plugin/" }
let g:vim['cache']  = { 'dir' : $XDG_CACHE_DIR }

let g:vim['contrib']  = { 'dir' : g:vim.etc.dir . '/contrib/' }
let g:vim.contrib['etc']  = { 'dir' : g:vim.contrib.dir . '/etc/' }
let g:vim.contrib['bin']  = { 'dir' : g:vim.contrib.dir . '/bin/' }

let $MYVIMRC = g:vim.rc

let g:vim.bundle = {}
let g:vim.bundle.dir =  g:vim.dir . "bundle/"
let g:vim.bundle.settings = {}
let g:vim.bundle.settings.dir = g:vim.etc.dir . "bundle_config/"
let $_VIM_BUNDLE_DIR = g:vim.bundle.dir

let g:vim.config = {}
let g:vim.config.dir = g:vim.etc.dir . "config/"

execute "source " . g:vim.after.dir . '/plugin/helpers.vim'

call Mkdir(g:vim.dir, "p")
call Mkdir(g:vim.etc.dir, "p")
call Mkdir(g:vim.var.dir, "p")

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
call Mkdir(&undodir, "p")

" nomodeline can not be revered by plugins
" but modeline is needed by dbext even though it uses its own parser.
" set nomodeline

" Enable vim enhancements
set nocompatible

augroup MyVimrcAugroupOnlySetCurrentDirAsPath
  autocmd!
  autocmd VimEnter * set path=,,
augroup END

" Make helpgrep find vim's own help files before plugin help files
let &runtimepath = '/usr/share/nvim/runtime,'
      \ . &runtimepath

execute "set runtimepath+=" . g:vim.etc.dir
execute "set runtimepath+=" . g:vim.after.dir

" Reload vimrc on write
" autocmd BufWritePost vimrc source $MYVIMRC
" nnoremap <leader>vr :execute "source " . $MYVIMRC<cr>

" Prevent creation of .netrwhist file
let g:netrw_dirhistmax = 0

" Use gx to open any file under cursor in appropriate app
let g:netrw_browsex_viewer="xdg-open"

if $DISPLAY
  " Make the clipboard register the same as the default register
  " this allows easy copy to other x11 apps
  set clipboard=unnamed
endif

" Chdir to the dir of the current buffer
" set autochdir
" autocmd BufEnter * silent! execute "lcd %:p:h:gs/ /\\ /

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

let &tabstop = 2
let &softtabstop = &tabstop
let &shiftwidth = &tabstop
set shiftround
set smarttab
set expandtab

" automatically indent to match adjacent lines
set autoindent

" textformattting
set textwidth=80

" Note: if the listpat fits in the previous row the listpat is wrapped into the
" previous row

" TODO: needs work
" " These seem to get overwritten by too many plugins
" function! MyVimrcForceFormattingSettings() abort
"   set formatoptions=roqanj1c
"   let &formatlistpat = '\c\v^\s*[-\+\*]\s+'
"   let &formatlistpat .= '|\c\v^\s*(todo|note|tags|see also|fix)\s+'
"   set noautoindent
" endfunction
" augroup MyVimrcAugroupForceFormattingSettings
"   autocmd!
"   autocmd BufWinEnter * call MyVimrcForceFormattingSettings()
" augroup END

" see also:
" :h auto-format
function! MyVimrcShowFormatSettings() abort
  call INFO('&comments:', &comments)
  call INFO('&commentstring:', &commentstring)
  call INFO('&formatoptions:', &formatoptions)
  call INFO('&formatlistpat:', &formatlistpat)
  call INFO('&autoindent:', &autoindent)
  call INFO('&smartindent:', &smartindent)
  call INFO('&cindent:', &cindent)
  " call INFO('g:MyMarkdownFormatoptions:', g:MyMarkdownFormatoptions)
endfunction

" Make backspace more flexible
set backspace=indent,eol,start

set splitbelow
set splitright

" Line wrapping
set wrap

" Show arrows for too long lines / show trailing spaces
set list listchars=tab:\ \ ,trail:.,precedes:<,extends:>

" Stay in the middle of the screen
set scrolloff=999
" set sidescrolloff=0

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

augroup MyVimrcAugroupListAllBuffers
  autocmd!
  autocmd BufEnter * :set buflisted
augroup END

set synmaxcol=300

" show count of selected lines / columns
set showcmd

" Make macros render faster (lazy draw)
" set lazyredraw

set display=lastline,uhex

" Vim will wrap long lines at any character in 'breakat'
set nolist
set linebreak
set breakat&vim
if IsNeoVim()
  set breakindent
  let &showbreak="  ↪ "
  " let &showbreak="  "
else
  let &showbreak=repeat(' ', &tabstop * 2) . "↪ "
endif

set mousehide
set mouse=

" always assume decimal numbers
set nrformats-=octal

" Determine how text with the "conceal" syntax attribute is shown
" set conceallevel=1
" set listchars+=conceal:Δ

set isfname-==

command! -nargs=* RemoveTrailingSpaces :silent %s/\s\+$//e
command! -nargs=* RemoveNewlineBlocks  :silent %s/\v\n\n+/\r\r/e | :silent %s/\n*\%$//g

" Deactivate gui cursor to fix nvim regression (2017-07-25)
" (https://github.com/neovim/neovim/issues/7049)
set guicursor=

"### Undo and swap

" Maximum amount of memory in Kbyte to use for all buffers together.
set maxmemtot=2048

" Default 1000
" set undolevels=

" Never create backup files
set nobackup
set nowritebackup

" Never create swapfiles
set noswapfile

"### Timeouts

" Timeout on mappings and key codes (faster escape etc)
" set timeout
" set timeoutlen=300
" set ttimeoutlen=10

" used for the CursorHold autocommand event
set updatetime=1000

set suffixesadd=.txt,.md

" don't echo make output to screen
let &shellpipe = '&>'

" turn off folding
set nofoldenable

"### Mappings

" For a list of vim's internal mappings see:
" :h index

" Potentially reassignable keys for normal mode:
" s, S, Q, Z, <bs>, M, m, r, R, <space>, Y
" <cr> is used in quickfix etc for jumping
" Maybe use r as secondary leader?

" Possible insert mode leaders:
" imap <c-b>
" imap <c-space>

" These are the same for vim
" Tab and Ctrl-I (<c-i><c-I>)
" Enter and Ctrl-M (<c-m>)
" Esc and Ctrl-[ (<c-[>)

" Clear all mappings
" :mapclear

" Map space to leader instead of the other way around to keep the original
" leader in insert mode - because space does not work well there.
nmap <space> <leader>
vmap <space> <leader>

" Ignore the leader if the following key is not mapped
nmap <leader> <nop>
vmap <leader> <nop>

" also use <space> for custom text-objects - i.e. see: vim-textobj-lastpat.vim

nnoremap <leader>vee :call VimEnvironment()<cr><esc>
nnoremap <leader>veg :call DUMP(g:)<cr>

" use saner regexes
" TODO checkout bundle 'vim-scripts/eregex.vim'
nnoremap :s/ :s/\V

nnoremap <c-z> :silent wall<cr><c-z>
inoremap <c-z> <esc>:silent wall<cr><c-z>

" Switch to alternative file
" nnoremap <BS> <C-^>

" Save file as root
command! -nargs=* WW :SudoWrite

" Adding a left shift key does not work like this
" nnoremap < <shift>

" Does not work on terminal vim
" nnoremap <s-space> <C-b>

nmap <silent>L :bnext<cr>
nmap <silent>H :bprev<cr>

" use <leader>! as prefix to remap stuff
" Remap <C-i> as it's the same as Tab
" nnoremap <leader>!a <C-o>
" nnoremap <leader>!b <C-i>

nnoremap <c-u> <C-i>

" Write all when leaving a tmux pane
nmap <silent><c-j> :silent wall<cr><c-j>
nmap <silent><c-k> :silent wall<cr><c-k>
nmap <silent><c-h> :silent wall<cr><c-h>
nmap <silent><c-l> :silent wall<cr><c-l>

imap <c-h> <esc><c-h>
imap <c-l> <esc><c-l>
imap <c-j> <esc><c-j>
imap <c-k> <esc><c-k>

vmap <c-h> <esc><c-h>
vmap <c-l> <esc><c-l>
vmap <c-j> <esc><c-j>
vmap <c-k> <esc><c-k>

nnoremap <silent> <leader>go :only<cr>

" Never use formatprg (it's global) and doesn't fallback to vim's default
set formatprg=false

" Nicer redo
" tags: undo
nnoremap U <c-r>
nnoremap <leader>gu U

" Dont use Q for Ex mode
nnoremap Q :xa<cr>

" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$

" make . work with visually selected lines
xnoremap . :norm.<CR>

" Remap set mark because m is used by easyclip
nnoremap <leader>m m
nnoremap M '

" Quickly jump to buffers
nnoremap <nowait>gb :ls<cr>:buffer<space>

nnoremap <silent><leader>if :!firefox
      \ "https://duckduckgo.com/?q=<cword> site:stackoverflow.com"<cr><cr>
vnoremap <silent><leader>if y:execute '!firefox '
      \ . 'https://duckduckgo.com/?q=' . @"<cr>
nnoremap <silent><leader>is :execute
      \ ":RunIntoBuffer so-lucky ". expand("<cword>") . " [" . &filetype . "]"<cr>

" Run current line in the shell
nnoremap <silent><leader>el :RunCursorLine<cr>

" Don't wait after escape in insert mode
" Breaks curser keys etc. (apparently not in Neovim)
" removed from Neovim (2017-03-01)
" set noesckeys

" Close buffer
" Mapping <esc> in vimrc breaks arrow behaviour"
" (http://stackoverflow.com/questions/11940801)
" - seems to be no problem with neovim
nnoremap <silent><esc> :call BufferClose()<cr>

" Causes delay
" nnoremap <esc>[ <esc>[

" Open command-line window
" :h cmdline-window
nnoremap <space><space> q:i
vnoremap <space><space> q:i
nnoremap <leader>k q:i<esc>k
nnoremap <leader>A q:i<esc>kA

augroup MyVimrcAugroupAdjustWindowSizes
    autocmd VimEnter,VimResized * :let &cmdwinheight = &lines / 5
    autocmd VimEnter,VimResized * :execute 'nnoremap rl ' . &columns / 2 . 'l'
    autocmd VimEnter,VimResized * :execute 'nnoremap rh ' . &columns / 2 . 'h'
    autocmd VimEnter,VimResized * :execute 'nnoremap rj ' . (&lines / 2 - 3) . 'j'
    autocmd VimEnter,VimResized * :execute 'nnoremap rk ' . (&lines / 2 - 3) . 'k'
augroup END

augroup MyVimrcAugroupCmdwinSetup
  autocmd!
  " Reset <cr> mapping for command-line-window in case <cr> is mapped somewhere
  autocmd CmdwinEnter * nnoremap <buffer> <cr> <cr>

  " autocmd CmdwinEnter * inoremap <buffer><silent> <tab> <esc>:quit<cr>
  autocmd CmdwinEnter * nnoremap <buffer><silent> <tab> :quit<cr>

  autocmd CmdwinEnter * nmap <buffer><silent> <c-h> :quit<cr><c-h>
  autocmd CmdwinEnter * nmap <buffer><silent> <c-j> :quit<cr><c-j>
  autocmd CmdwinEnter * nmap <buffer><silent> <c-k> :quit<cr>
  autocmd CmdwinEnter * nmap <buffer><silent> <c-l> :quit<cr><c-l>

  autocmd CmdwinEnter * nmap <buffer><silent> <leader>k :quit<cr>

  autocmd CmdwinEnter * imap <buffer><silent> <c-h> <esc>:quit<cr><c-h>
  autocmd CmdwinEnter * imap <buffer><silent> <c-j> <esc>:quit<cr><c-j>
  autocmd CmdwinEnter * imap <buffer><silent> <c-k> <esc>:quit<cr>
  autocmd CmdwinEnter * imap <buffer><silent> <c-l> <esc>:quit<cr><c-l>
augroup END

" Reselect visual block after indent
vnoremap <nowait>< <gv
vnoremap <nowait>> >gv

" hide annoying quit message
" nnoremap <C-c> <C-c>:echo<cr>

" always search forward and N backward, use this
" nnoremap <expr> n 'Nn'[v:searchforward]
" nnoremap <expr> N 'nN'[v:searchforward]

nmap <leader>?? <leader>vr
nnoremap <leader>vr :execute "edit " . g:vim.etc.dir . "/README.md"<cr>
nnoremap <leader>vv :execute "edit " . $MYVIMRC<cr>
nnoremap <silent> <leader>vt :execute "edit " . g:vim.etc.dir
      \ . '/after/ftplugin/' . &filetype . '.vim'<cr>

command! -nargs=* EditInBufferDir
      \ :execute 'edit ' . expand('%:p:h') . '/' . expand('<args>')

" Show all <leader> mappings
nnoremap <leader>vm :Verbose map <leader><cr> <bar> :only<cr>

" Show all <leader> search mappings
nnoremap <leader>/? :Verbose map <leader>/<cr> <bar> :only<cr>

" open search history / select last entry
nnoremap <leader>// q/k
vnoremap <leader>// q/k

nnoremap <leader>/c /\v^\s*[/"#]+<cr>
" nnoremap <leader>/b /^.*\S\+\s\+{\s*$<cr>
nnoremap <leader>/b /^.*{.*$<cr>
nnoremap <leader>/i /^\S\+<cr>
nnoremap <leader>/w /\<\><left><left>
nnoremap <leader>/r gg/require<cr>}
nnoremap <leader>/t gg/TODO<cr>

" nnoremap <silent> r[ :call search('(', 'bz')<cr>
" nnoremap <silent> r] :call search(')', 'z')<cr>
" nnoremap <silent> r[ ?\v[(\}\[]<cr>
" nnoremap <silent> r] /\v[)\}\]]<cr>
" nnoremap <c-space>h <esc>?\v[(\}\[]<cr>
" inoremap <c-space>h <esc>?\v[(\}\[]<cr>
" nnoremap <c-space>l <esc>/\v[)\}\]]<cr>
" inoremap <c-space>l <esc>/\v[)\}\]]<cr>

nnoremap <silent> <leader>vt :execute ':edit ' \ . fnameescape(g:vim.after.dir . 'ftplugin/' . &filetype . '.vim')<cr>

" Make gf work with relative file names and non existent files
nnoremap <leader>gf :execute ":edit " . expand('%:h') . '/' . expand('<cfile>')<cr>

nnoremap ' `
nnoremap ` '

" Restore cursor position after visual selection
nnoremap v m`v
nnoremap V m`V
nnoremap <C-v> m`<C-v>
vnoremap <esc> <esc>``
vnoremap y y``
" TODO: clean up <leader>l namespace
nnoremap <leader>lr :%s/<C-r><C-w>/
nnoremap <leader>lR :%s/<C-r><C-w>/<c-r><c-w>
nnoremap <silent><leader>gm :echom '=== Messages until ' . strftime("%H:%M:%S")
      \ . ' ======================='
      \ \| :silent Verbose messages<cr> \| :silent only \| :normal G <cr>
      \ \| :setlocal syntax=txt
      \ \| echom ''
      \ <cr>

" Easier change and replace word
nnoremap c* *Ncgn
nnoremap c# #NcgN
nnoremap cg* g*Ncgn
nnoremap cg# g#NcgN

nnoremap <leader>hW :execute 'Help ' . expand('<cWORD>')<cr>
nnoremap <leader>hh :execute 'Help ' . expand('<cword>')<cr>
vnoremap <leader>hh y:execute 'Help ' . escape(expand(@"), ' ')<cr>
nnoremap <leader>hp :call Help(expand('%:t:r'))<cr>

" " TODO: tune
" " TODO: already included in vim-unimpaired?
" map [[ ?{<CR>w99[{
" map ][ /}<CR>b99]}
" map ]] j0[[%/{<CR>
" map [] k$][%?}<CR>

" Go to alternate file
nnoremap <leader>ga <c-^>

nnoremap <silent> <leader>gw :silent wall<cr>

" ### Searching

" Show matching brackets
set showmatch

" Don't blink when matching
set matchtime=0

" Incremental search
set incsearch

" Highlight found text
" set hlsearch

" Toggle highlighting current matches
nmap <silent><c-c> :set hlsearch! hlsearch?<CR>

set ignorecase

" Case insensitive search when all lowercase
set smartcase

" Case inferred by default
set infercase

" Do not wrap while searching
" set nowrapscan

" Switch window if it contains wanted buffer
set switchbuf=useopen

" Extend a previous match
nnoremap //   /<C-R>/
" nnoremap ///  [[/<C-R>/\<BAR>]]

"### Plugin manager

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
    call Mkdir(g:vim.bundle.dir, "p")
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

NeoBundleCheck

if IsNeoVim()
  " Provides Neovim's UpdateRemotePlugins but does not seem to be sourced jet:
  source /usr/share/nvim/runtime/plugin/rplugin.vim
  " Calls UpdateRemotePlugins the NeoBundle way
  silent! NeoBundleRemotePlugins
endif

" Remove installed plugins that are not configured anymore
" :NeoBundleClean!

"### Must run last

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
