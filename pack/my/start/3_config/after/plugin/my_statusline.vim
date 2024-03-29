" Avoid 'hit enter prompt'
set shortmess=atTIWF

if nb#isNeovim()
  " don't give ins-completion-menu messages.
  set shortmess+=c
endif

" Increase ruler height
" set cmdheight=2

" always show status line
set laststatus=2

set showtabline=0

" Prevent mode info messages on the last line to prevent 'hit enter prompt'
set noshowmode

" generic var to use to display debug infos
let g:my_statusline_debug = ''

function! my_statusline#specialBufferName() abort
  if BufferIsQuickfix()
    return 'qf'
  endif
  if BufferIsLoclist()
    return 'll'
  endif
  if &previewwindow == 1
    return 'preview'
  endif
  return ''
endfunction

function! MyStatuslineDir() abort
  let dir = expand("%:p:h:t")
  let project = getcwd()
  let project = fnamemodify(project, ':t')
  if dir == project
    return ''
  endif
  return dir
endfunction

let &statusline .= '%#StatusLine#'
let &statusline .= ' %-0.30{fnamemodify(getcwd(), ":t")} '
let &statusline .= '%#StatusLine#'

let &statusline .= '%#StatusLine#'
let &statusline .= '%-0.30(%{MyStatuslineDir()} %)'
let &statusline .= '%#StatusLine#'

" don't show names of special buffers
function! my_statusline#bufferName() abort
  if MyBufferIsSpecial(bufnr('%'))
    return ''
  endif
  let file = fnamemodify(bufname(), ':t')
  if file == ''
    let file = '[No Name]'
  endif
  return file
endfunction

let &statusline .= '%#Cursorline#'
let &statusline .= '%( %{my_statusline#bufferName()} %)'
let &statusline .= '%#StatusLine#'

let &statusline .= '%( %< %)'

function! my_statusline#truncateRight(value, max) abort
  if len(a:value) < a:max
    return a:value
  endif
  let value = substitute(a:value, '\v\s+.*', '', 'g')
  return value
  " return printf("%." . a:max . "s", a:value) . "..."
endfunction

let &statusline .= '%#Cursorline#'
let &statusline .= '%( %{exists("w:quickfix_title") ? my_statusline#truncateRight(w:quickfix_title, 30) : ""} %)'
" let &statusline .= '%( %{exists("w:quickfix_title") ? w:quickfix_title : ""} %)'
let &statusline .= '%#StatusLine#'

let &statusline .= '%='

" quickfix

let g:MyStatuslineQfErrors = ''
let g:MyStatuslineQfWarnings = ''
let g:MyStatuslineQfInfos = ''
let g:MyStatuslineQfOther = ''

let g:MyStatuslineLoclistErrors = ''
let g:MyStatuslineLoclistWarnings = ''
let g:MyStatuslineLoclistInfos = ''
let g:MyStatuslineLoclistOther = ''

function! MyStatuslineUpateQickfixValues() abort
  let g:MyStatuslineQfErrors = substitute(len(filter(copy(getqflist()), "v:val.type == \"e\"")), "^0$", "", "g")
  let g:MyStatuslineQfWarnings = substitute(len(filter(copy(getqflist()), "v:val.type == \"w\"")), "^0$", "", "g")
  let g:MyStatuslineQfInfos = substitute(len(filter(copy(getqflist()), "v:val.type == \"i\"")), "^0$", "", "g")
  let g:MyStatuslineQfOther = substitute(len(filter(copy(getqflist()), "v:val.type !~? \"i\" && v:val.type !~? \"w\" && v:val.type !~? \"e\" && v:val.valid == 1")), "^0$", "", "g")
endfunction

function! MyStatuslineUpateLoclistValues() abort
  let g:MyStatuslineLoclistErrors = substitute(len(filter(copy(getloclist(0)), "v:val.type == \"e\"")), "^0$", "", "g")
  let g:MyStatuslineLoclistWarnings = substitute(len(filter(copy(getloclist(0)), "v:val.type == \"w\"")), "^0$", "", "g")
  let g:MyStatuslineLoclistInfos = substitute(len(filter(copy(getloclist(0)), "v:val.type == \"i\"")), "^0$", "", "g")
  let g:MyStatuslineLoclistOther = substitute(len(filter(copy(getloclist(0)), "v:val.type !~? \"i\" && v:val.type !~? \"w\" && v:val.type !~? \"e\" && v:val.valid == 1")), "^0$", "", "g")
endfunction

let &statusline .= '%#ErrorMsg#'
let &statusline .= '%( %{g:MyStatuslineQfErrors} %)'
let &statusline .= '%#StatusLine#'

let &statusline .= '%#WarningMsg#'
let &statusline .= '%( %{g:MyStatuslineQfWarnings} %)'
let &statusline .= '%#StatusLine#'

let &statusline .= '%#MoreMsg#'
let &statusline .= '%( %{g:MyStatuslineQfInfos} %)'
let &statusline .= '%#StatusLine#'

let &statusline .= '%#Cursorline#'
let &statusline .= '%( %{g:MyStatuslineQfOther} %)'
let &statusline .= '%#StatusLine#'

" loclist

let &statusline .= '%#ErrorMsg#'
let &statusline .= '%( %{g:MyStatuslineLoclistErrors}. %)'
let &statusline .= '%#StatusLine#'

let &statusline .= '%#WarningMsg#'
let &statusline .= '%( %{g:MyStatuslineLoclistWarnings}. %)'
let &statusline .= '%#StatusLine#'

let &statusline .= '%#MoreMsg#'
let &statusline .= '%( %{g:MyStatuslineLoclistInfos}. %)'
let &statusline .= '%#StatusLine#'

let &statusline .= '%#Cursorline#'
let &statusline .= '%( %{g:MyStatuslineLoclistOther}. %)'
let &statusline .= '%#StatusLine#'

let g:my_statusline_debug = ''
let &statusline .= '%#MoreMsg#'
let &statusline .= '%( %{my_statusline#debugInfo()} %)'
let &statusline .= '%#StatusLine#'

function! my_statusline#debugInfo() abort
  return g:my_statusline_debug
endfunction

" misc

" let &statusline .= '%#MoreMsg#'
" let &statusline .= '%( %{my_statusline#specialBufferName()} %)'
" let &statusline .= '%#StatusLine#'

" let &statusline .= '%( %{my_statusline#specialBufferName() == "" ? &filetype : ""} %)'
let &statusline .= '%( %{&filetype} %)'

let &statusline .= '%#ErrorMsg#'
let &statusline .= '%( %{exists("b:fugitive_type") ? "fugitive" : ""} %)'
let &statusline .= '%#StatusLine#'

" let &statusline .= '%#ErrorMsg#'
" let &statusline .= '%( %{FugitiveStatusline()} %)'
" let &statusline .= '%#StatusLine#'

let &statusline .= '%#ErrorMsg#'
let &statusline .= '%( %{exists("b:region_filetype") ? "" . b:region_filetype : ""} %)'
let &statusline .= '%#StatusLine#'

let &statusline .= '%#ErrorMsg#'
let &statusline .= '%( %{substitute(substitute(&paste, "1", "PASTE", "g"), "0", "", "g")} %)'
let &statusline .= '%#StatusLine#'

let &statusline .= '%#ErrorMsg#'
let &statusline .= '%( %{substitute(&enc, "utf-8", "", "g")} %)'
let &statusline .= '%#StatusLine#'

let &statusline .= '%#ErrorMsg#'
let &statusline .= '%( %{substitute(&ff, "unix", "", "g")} %)'
let &statusline .= '%#StatusLine#'

let &statusline .= ' %3l,%-02c %P '

let g:MyStatusline = &statusline

if exists("b:MyStatuslinePluginLoaded")
    finish
endif
let b:MyStatuslinePluginLoaded = 1

" Borrowed from lightline
augroup my_statusline#autogroup
  autocmd!
  autocmd WinEnter,BufWinEnter,FileType,SessionLoadPost * call setwinvar(0, '&statusline', g:MyStatusline)
  autocmd SessionLoadPost * call setwinvar(0, '&statusline', g:MyStatusline)
  autocmd ColorScheme * if !has('vim_starting') || expand('<amatch>') !=# 'macvim'
        \ | runtime('plugin/my_statusline.vim') | call setwinvar(0, '&statusline', g:MyStatusline) | endif
  autocmd CursorMoved,BufUnload,QuickFixCmdPost * call setwinvar(0, '&statusline', g:MyStatusline)
augroup END

augroup my_statusline#autogroupQuickfix
  autocmd!
  autocmd QuickFixCmdPost [^l]* :call MyStatuslineUpateQickfixValues()
  autocmd QuickFixCmdPost l* :call MyStatuslineUpateLoclistValues()
augroup END

augroup my_statusline#augroupInactive
  autocmd!
  autocmd WinLeave * :let &l:statusline = ' '
augroup END

