"### help ######################################################################
" html help: http://vimdoc.sourceforge.net/htmldoc/usr_toc.html
" what configuration was last loaded: :verbose set formatoptions
" http://vim.wikia.com/wiki/Learn_to_use_help
" :h pattern
" vim scripting:
" http://www.ibm.com/developerworks/linux/library/l-vim-script-1/index.html

"### misc ######################################################################

" Security
set modelines=0

set nocompatible " Enable vim enhancements

set shortmess=astTI " avoid 'hit enter prompt'
set cmdheight=2 " increase ruler height

set ruler " always show status line
set rulerformat=%80(%<%F\ %{(&fenc==\"\"?&enc:&fenc)}%Y%{&ff=='unix'?'':','.&ff}%=\ %2c\ %P%)

" searching

" use normal regexes
" nnoremap / /\v
" vnoremap / /\v

set showmatch " Show matching brackets.
set incsearch " Incremental search
set hlsearch " highlight found text

set ignorecase
set smartcase " case insensitive search when all lowercase
set infercase " case inferred by default

set autoread " Set to auto read when a file is changed from the outside

set nostartofline " leave my cursor where it was - even on page jump

set expandtab " Insert spaces when the tab key is hit
set tabstop=4 " Tab spacing of 4
set sw=4 " shift width (moved sideways for the shift command)
set smarttab

set backspace=indent,eol,start " make backspace more flexible

set wildmenu " use tab expansion in vim prompts

" try to restore last known cursor position
autocmd BufReadPost * if line("'\"") | exe "normal '\"" | endif

set nowrap " do wrap long lines
set nowrapscan " do not wrap while searching

" set textwidth=80 " wrap automatically on edit

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

" save undo after closing a file
" set undofile

" set encoding=utf-8
" set laststatus=2

let mapleader = ","
" inoremap jj <ESC>jj

" disable F1
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" load plugins in bundle/*
call pathogen#infect()

filetype on " detect filetypes and run filetype plugins - needed for taglist
filetype plugin on
filetype indent on

"### split windows #############################################################

" move between windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" open new window an move into it
nnoremap <leader>w :80vs<cr><C-w>l
nnoremap <leader>wc <C-w>c

"### mappings ##################################################################

" these are the same for vim
" Tab and Ctrl-I
" Enter and Ctrl-M
" Esc and Ctrl-[ 

" clear all mappings
" :mapclear

" dont use Q for Ex mode
map Q :q

" nnoremap <c-k> g<c-]>
" nnoremap <c-j> <c-t>

" history jump
nnoremap <c-h> <c-o>
nnoremap <c-l> <c-i>

" file name expansion
set wildmode=longest:list

" ignore case in file names
if exists("&wildignorecase")
    set wildignorecase
endif

"### Highlight cursor line after cursor jump ###################################

" causes copy and past via mouse to add lots of spaces?!?
" au CursorMoved,CursorMovedI * call s:Cursor_Moved()
let g:last_pos = 0

function s:Cursor_Moved()
  let cur_pos = winline()
  if g:last_pos == 0
    set cul
    let g:last_pos = cur_pos
    return
  endif
  let diff = g:last_pos - cur_pos
  if diff > 1 || diff < -1
    set cul
  else
    set nocul
  endif
  let g:last_pos = cur_pos
endfunction

"### automatically give executable permissions #################################

au BufWritePost * silent call ModeChange()

function ModeChange()
  if getline(1) =~ "^#!"
    if getline(1) =~ "/bin/"
      silent !chmod a+x <afile>
    endif
  endif
endfunction

"### perl ######################################################################

au FileType perl silent call PerlStuff()
function! PerlStuff()

" syntax check on write
" au BufWritePost *.p[lm] !perl -wcIlib %

" map E :w<CR>:!r<CR>

"--- perltidy ------------------------------------------------------------------

map <silent> W :call PerlTidy()<CR>

function PerlTidy()
    let _view=winsaveview()
    %!perltidy -q
    " %!tidyall --conf-name ~/.tidyallrc -p ~/.tidyallrc
    call winrestview(_view)
endfunction

"--- :make with error parsing --------------------------------------------------

map E :make<cr>
set makeprg=$VIMRUNTIME/tools/efm_perl.pl\ -c\ %\ $*
set errorformat=%f:%l:%m

"--- show documentation for builtins and modules under cursor ------------------
" http://www.perlmonks.org/?node_id=441738

map <silent> M :call PerlDoc()<cr>:set nomod<cr>:set filetype=man<cr>

function! PerlDoc()

  normal yy

  let l:this = @

  if match(l:this, '^ *\(use\|require\) ') >= 0

    exe ':new'
    exe ':resize'

    let l:this = substitute(l:this, '^ *\(use\|require\) *', "", "")
    let l:this = substitute(l:this, ";.*", "", "")
    let l:this = substitute(l:this, " .*", "", "")

    exe ':0r!perldoc -t ' . l:this
    exe ':0'
    noremap <buffer> <esc> <esc>:q!<cr>

    return

  endif

  normal yiw
  exe ':new'
  exe ':resize'
  exe ':0r!perldoc -t -f ' . @
  exe ':0'
  noremap <buffer> <esc> <esc>:q!<cr>

endfunction

" PerlStuff() end
endfunction

"### SQL #######################################################################

au FileType sql map <silent> S :w<CR>:,$r !reportmail %<CR>

"### XML #######################################################################

au FileType xml,html,xhtml,svg,wsdd silent call XmlStuff()
function! XmlStuff()

map <silent> W :call XMLTidy()<CR>

function XMLTidy()
    let _view=winsaveview()
    %!tidy --indent-spaces 4 --vertical-space 1 --indent-attributes 1 --indent 1 --markup 1 --sort-attributes alpha --tab-size 4 --wrap 80 --wrap-attributes 1 --quiet 1 --input-xml 1
" --uppercase-tags 1
    " %!xmllint --format --recover -
    call winrestview(_view)
endfunction

" XmlStuff() end
endfunction

"### CSS #######################################################################

au FileType css silent call CssStuff()
function! CssStuff()

map <silent> W :call CSSTidy()<CR>

function CSSTidy()
    let _view=winsaveview()
    %!csstidy - --silent=true --template=low --sort_properties=true --sort_selectors=true --preserve_css=true
    call winrestview(_view)
endfunction

" CssStuff() end
endfunction

"### json ######################################################################

au BufEnter,BufNew oms.conf setfiletype json
au FileType json silent call JSONStuff()
function! JSONStuff()

map <silent> W :call JSONTidy()<CR>

function JSONTidy()
    let _view=winsaveview()
    %!json_pp -json_opt pretty,canonical,indent
    call winrestview(_view)
endfunction

" JSONStuff() end
endfunction

"### javascript ################################################################

au FileType javascript silent call JavaScriptStuff()
function! JavaScriptStuff()

map <silent> W :call JSTidy()<CR>

function JSTidy()
    let _view=winsaveview()
    " installed by cpanm JavaScript::Beautifier
    %!js_beautify.pl -
    call winrestview(_view)
endfunction

" JavaScriptStuff() end
endfunction

"### colorscheme ###############################################################

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

" hi NonText ctermfg=red ctermbg=NONE cterm=bold
" hi NonText ctermfg=NONE ctermbg=red cterm=bold

"### taglist ###################################################################

if executable('ctags')

    map <silent> <c-o> :call My_TagList()<CR>gg/

    function My_TagList()

        exe ":TlistToggle"
        exe ":TlistUpdate"

        noremap <buffer> <esc> <esc>:q<cr>

    endfunction

    let Tlist_GainFocus_On_ToggleOpen = 1
    let Tlist_Close_On_Select = 1
    let Tlist_Compact_Format = 1
    let Tlist_Exit_OnlyWindow = 1
    let Tlist_Auto_Highlight_Tag = 1
    let Tlist_Highlight_Tag_On_BufEnter = 1
    let Tlist_Inc_Winwidth = 0
    let Tlist_Auto_Update = 1
    let Tlist_Display_Tag_Scope = 0

else

    let loaded_taglist = 'no'

endif

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
