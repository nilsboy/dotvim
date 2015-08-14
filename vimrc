"### misc ######################################################################

" Create a directory if does not exist jet
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
let g:vim['bundle'] = { 'dir' : g:vim.dir . "bundle/" }
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
" au BufRead,BufNewFile *.json set filetype=json | setlocal syntax=txt

" Recognize .md as markdown for vim < 7.4.480
" au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown

" Make the clipboard register the same as the default register
" this allows easy copy to other x11 apps
set clipboard=unnamed

" Chdir to the dir of the current buffer
set autochdir
autocmd BufEnter * silent! execute "lcd %:p:h:gs/ /\\ /

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
set wildignore=.*,*.class

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

" autocmd * qf set winheight=10
autocmd FileType qf set winheight=10
autocmd FileType help set buflisted | only
" autocmd BufCreate * set buflisted | only

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
set nolist
set linebreak
set breakat&vim
let &showbreak=repeat(' ', 10) . "↪ "
" TODO next vim: "This feature has been implemented on June 25, 2014 as patch 7.4.338"
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

nnoremap <silent><leader>i :!firefox "https://duckduckgo.com/?q=<cword>"<cr><cr> 

nnoremap <c-u> g,
nnoremap <c-p> g;

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
let &t_SI = "\<Esc>]12;red\x7"
" use a red cursor otherwise
let &t_EI = "\<Esc>]12;orange\x7"
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

" set cursorline
" autocmd WinLeave * setlocal nocursorline
" autocmd WinEnter * setlocal cursorline

"### Gui mode ##################################################################

" No menus, scrollbars, or other junk
set guioptions=

" disables the GUI tab line in favor of the plain text version
set guioptions-=e

"### Install plugin manager ####################################################

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

"### Plugins ###################################################################

    " uber awesome syntax and errors highlighter
    NeoBundle 'scrooloose/syntastic'

    " A Git wrapper so awesome, it should be illegal
    NeoBundle 'tpope/vim-fugitive'
      " nnoremap <silent> <leader>gs :Gstatus<CR>
      " nnoremap <silent> <leader>gd :Gdiff<CR>
      " nnoremap <silent> <leader>gc :Gcommit<CR>
      " nnoremap <silent> <leader>gb :Gblame<CR>
      " nnoremap <silent> <leader>gl :Glog<CR>
      " nnoremap <silent> <leader>gp :Git push<CR>
      " nnoremap <silent> <leader>gw :Gwrite<CR>
      " nnoremap <silent> <leader>gr :Gremove<CR>

    NeoBundleLazy 'gregsexton/gitv', 
                \ {'depends':['tpope/vim-fugitive'],
                \ 'autoload':{'commands':'Gitv'}}
      " nnoremap <silent> <leader>gv :Gitv<CR>
      " nnoremap <silent> <leader>gV :Gitv!<CR>

    " shows a git diff in the gutter
    " TODO some hilight error
    " NeoBundle 'airblade/vim-gitgutter'

    " ack support
    NeoBundle 'mileszs/ack.vim'
      if executable('ack')
        set grepprg=ack\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow\ $*
        set grepformat=%f:%l:%c:%m
      endif
      if executable('ag')
        set grepprg=ag\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow
        set grepformat=%f:%l:%c:%m
      endif

    " Prerequisite for some vim plugins
    NeoBundle 'l9'

    " Next generation completion framework
    NeoBundle 'Shougo/neocomplete.vim'
        let g:neocomplete#enable_at_startup=1
        let g:neocomplete#data_directory=g:vim.cache.dir . 'neocomplete'

    " Universal syntax script for all txt docs, logs and other types
    NeoBundle 'txt.vim'

    " EasyMotion and friends
    NeoBundle 'lokaltog/vim-easymotion'
    " NeoBundle 't9md/vim-smalls'
    NeoBundle 'justinmk/vim-sneak'

    " Search and display information from arbitrary sources
    NeoBundle 'shougo/unite.vim'

    " Most recently used plugin for unite.vim
    NeoBundle 'shougo/neomru.vim'

    " Provides your Vim's buffer with the outline view
    NeoBundle 'shougo/unite-outline'

    " Perl omni completion
    NeoBundle 'c9s/perlomni.vim'

    " Select tags or select files including tags
    NeoBundle 'tsukkee/unite-tag'

    " Lean & mean status/tabline for vim that's light as air.
    " NeoBundle 'bling/vim-airline'

    " NeoBundle 'scrooloose/nerdtree'

    " Vim sugar for the UNIX shell commands
    NeoBundle 'tpope/vim-eunuch'

    " Bringing GVim colorschemes to the terminal
    " NeoBundle 'godlygeek/csapprox'
        let g:CSApprox_verbose_level = 0

    " Use GUI Color Schemes in Supported Terminals
    NeoBundle 'KevinGoodsell/vim-csexact'

    " Colorschemes
    " NeoBundle 'altercation/vim-colors-solarized'
    NeoBundle 'jonathanfilip/vim-lucius'

    " cycle through (almost) all available colorschemes
    " :CycleColorNext
    NeoBundle 'vim-scripts/CycleColor'

    " Quickfix
    " NeoBundle 'sgur/unite-qf'

    " Show the syntax group name of the item under cursor
    " :call SyntaxAttr()<CR>
    NeoBundle 'vim-scripts/SyntaxAttr.vim'

    " Support perl regexes
    NeoBundle 'vim-scripts/eregex.vim'

    " Define temporary keymaps
    NeoBundle 'tomtom/tinykeymap_vim'

    " Mappings for simultaneously pressed keys
    " NeoBundle 'kana/vim-arpeggio'

    " NeoBundle 'fholgado/minibufexpl.vim'
    " let g:miniBufExplVSplit = 20   " column width in chars

    " Highlight ANSI escape sequences in their respective colors
    " NeoBundle 'vim-scripts/AnsiEsc.vim'
    NeoBundle 'powerman/vim-plugin-AnsiEsc'

    " Forget Vim tabs – now you can have buffer tabs
    NeoBundle 'ap/vim-buftabline'

    " Sometimes, it's useful to line up text.
    NeoBundle 'godlygeek/tabular'
      nmap <Leader>a& :Tabularize /&<CR>
      vmap <Leader>a& :Tabularize /&<CR>
      nmap <Leader>a= :Tabularize /=<CR>
      vmap <Leader>a= :Tabularize /=<CR>
      nmap <Leader>a: :Tabularize /:<CR>
      vmap <Leader>a: :Tabularize /:<CR>
      nmap <Leader>a:: :Tabularize /:\zs<CR>
      vmap <Leader>a:: :Tabularize /:\zs<CR>
      nmap <Leader>a, :Tabularize /,<CR>
      vmap <Leader>a, :Tabularize /,<CR>
      nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
      vmap <Leader>a<Bar> :Tabularize /<Bar><CR>

    " Vim Markdown runtime files 
    NeoBundle 'tpope/vim-markdown'

    " Gundo.vim is Vim plugin to visualize your Vim undo tree.
    NeoBundle 'sjl/gundo.vim'

    " Comment stuff out.
    NeoBundle 'tpope/vim-commentary'

    " asynchronous build and test dispatcher
    NeoBundle 'tpope/vim-dispatch'

    " Configurable and extensible tab line and status line
    " NeoBundle 'tpope/vim-flagship'

    " Vim Cucumber runtime files
    NeoBundle 'tpope/vim-cucumber'

    " Unicode character metadata
    " (press ga on top a character)
    NeoBundle 'tpope/vim-characterize'

    " Semantic Highlighting
    NeoBundle 'jaxbot/semantic-highlight.vim'

    " Seamless navigation between tmux panes and vim splits
    " TODO NeoBundle 'christoomey/vim-tmux-navigator'

    " a Vim plugin for making Vim plugins
    NeoBundle 'tpope/vim-scriptease'

    " codesearch source for unite.vim
    NeoBundle 'junkblocker/unite-codesearch'

    " Changes Vim working directory to project root
    NeoBundle 'airblade/vim-rooter'

    " quoting/parenthesizing made simple
    NeoBundle 'tpope/vim-surround'

    " enable repeating supported plugin maps with "." 
    NeoBundle 'tpope/vim-repeat'

    " HTML5 omnicomplete and syntax
    NeoBundle 'othree/html5.vim'

    " Vim's MatchParen for HTML tags
    NeoBundle 'gregsexton/MatchTag'

    " TODO checkout:
    " NeoBundle 'tpope/vim-unimpaired'

    " super simple vim plugin to show the list of buffers in the command bar
    " NeoBundle 'bling/vim-bufferline'

    " provides insert mode auto-completion for quotes, parens, brackets, etc.
    NeoBundle 'Raimondi/delimitMate'

    " NeoBundle 'unblevable/quick-scope'
        let g:qs_first_occurrence_highlight_color = '#afff5f' " gui vim
        let g:qs_first_occurrence_highlight_color = 26 " terminal vim

        let g:qs_second_occurrence_highlight_color = '#5fffff'  " gui vim
        let g:qs_second_occurrence_highlight_color = 20 " terminal vim

    " Interactive command execution in Vim
    NeoBundle 'Shougo/vimproc.vim', {
      \ 'build': {
        \ 'unix': 'make -f make_unix.mak',
      \ },
    \ }

    " extended % matching for HTML, LaTeX, and many other languages
    NeoBundle 'matchit.zip'

    " web stuff
    NeoBundleLazy 'groenewege/vim-less', {'autoload':{'filetypes':['less']}}
    NeoBundleLazy 'cakebaker/scss-syntax.vim', {'autoload':{'filetypes':['scss','sass']}}
    NeoBundleLazy 'hail2u/vim-css3-syntax', {'autoload':{'filetypes':['css','scss','sass']}}
    NeoBundleLazy 'ap/vim-css-color', {'autoload':{'filetypes':['css','scss','sass','less','styl']}}
    NeoBundleLazy 'othree/html5.vim', {'autoload':{'filetypes':['html']}}
    NeoBundleLazy 'wavded/vim-stylus', {'autoload':{'filetypes':['styl']}}
    NeoBundleLazy 'digitaltoad/vim-jade', {'autoload':{'filetypes':['jade']}}
    NeoBundleLazy 'juvenn/mustache.vim', {'autoload':{'filetypes':['mustache']}}
    NeoBundleLazy 'gregsexton/MatchTag', {'autoload':{'filetypes':['html','xml']}}
    NeoBundleLazy 'mattn/emmet-vim', {'autoload':{'filetypes':['html','xml','xsl','xslt','xsd','css','sass','scss','less','mustache']}} "{{{

    " javascript
    NeoBundleLazy 'marijnh/tern_for_vim', {
      \ 'autoload': { 'filetypes': ['javascript'] },
      \ 'build': {
        \ 'unix': 'npm install',
      \ },
    \ }

    " Vastly improved Javascript indentation and syntax support in Vim
    NeoBundleLazy 'pangloss/vim-javascript', {'autoload':{'filetypes':['javascript']}}

    " vim plugin which formated javascript files by js-beautify
    NeoBundleLazy 'maksimr/vim-jsbeautify', {'autoload':{'filetypes':['javascript']}}

    " Typescript syntax files for Vim
    NeoBundleLazy 'leafgarland/typescript-vim', {'autoload':{'filetypes':['typescript']}}

    " CoffeeScript support for vim
    NeoBundleLazy 'kchmck/vim-coffee-script', {'autoload':{'filetypes':['coffee']}}

    " File type detect plugin for vim which detects node.js shebang
    NeoBundleLazy 'mmalecki/vim-node.js', {'autoload':{'filetypes':['javascript']}}

    " Better JSON handling
    NeoBundleLazy 'leshill/vim-json', {'autoload':{'filetypes':['javascript','json']}}

    " Syntax file for some JavaScript libraries
    NeoBundleLazy 'othree/javascript-libraries-syntax.vim', {'autoload':{'filetypes':['javascript','coffee','ls','typescript']}}

    " vim-snipmate default snippets
    NeoBundle 'honza/vim-snippets'

    " search your selection text in Visual-mode
    NeoBundle 'thinca/vim-visualstar' 
    
    " visually select increasingly larger regions
    NeoBundle 'terryma/vim-expand-region'

    " for focussing on a selected region
    NeoBundle 'chrisbra/NrrwRgn'

    " insert or delete brackets, parens, quotes in pair
    NeoBundle 'jiangmiao/auto-pairs'

    " Fast and Easy Find and Replace Across Multiple Files
    NeoBundleLazy 'EasyGrep', {'autoload':{'commands':'GrepOptions'}}
      let g:EasyGrepRecursive=1
      let g:EasyGrepAllOptionsInExplorer=1
      let g:EasyGrepCommand=1
      nnoremap <leader>vo :GrepOptions<cr>
      
    " Fuzzy file, buffer, mru, tag, etc finder
    NeoBundle 'ctrlpvim/ctrlp.vim', { 'depends': 'tacahiroy/ctrlp-funky' }
      let g:ctrlp_clear_cache_on_exit=1
      let g:ctrlp_max_height=40
      let g:ctrlp_show_hidden=0
      let g:ctrlp_follow_symlinks=1
      let g:ctrlp_max_files=20000
      let g:ctrlp_cache_dir=g:vim.cache.dir . 'ctrlp'
      let g:ctrlp_reuse_window='startify'
      let g:ctrlp_extensions=['funky']
      let g:ctrlp_custom_ignore = {
            \ 'dir': '\v[\/]\.(git|hg|svn|idea)$',
            \ 'file': '\v\.DS_Store$'
            \ }

      if executable('ag')
        let g:ctrlp_user_command='ag %s -l --nocolor -g ""'
      endif

      nmap \ [ctrlp]
      nnoremap [ctrlp] <nop>

      nnoremap [ctrlp]t :CtrlPBufTag<cr>
      nnoremap [ctrlp]T :CtrlPTag<cr>
      nnoremap [ctrlp]l :CtrlPLine<cr>
      nnoremap [ctrlp]o :CtrlPFunky<cr>
      nnoremap [ctrlp]b :CtrlPBuffer<cr>

"### Install bundles ###########################################################

    call neobundle#end()

    " If there are uninstalled bundles found on startup,
    " this will conveniently prompt you to install them.
    NeoBundleCheck

    " NeoBundleClean!

"###############################################################################

" syntax on

" Detect filetypes and run filetype plugins
filetype on
filetype plugin on
filetype indent on

if filereadable(g:vim.rc_local)
  execute "source " . g:vim.rc_local
endif

" has to be done last - it set somewhere else before already
let &viminfo="'50,<1000,s100,:100,n" . g:vim.var.dir . "viminfo"

"###############################################################################
