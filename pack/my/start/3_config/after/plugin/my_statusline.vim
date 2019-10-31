" Avoid 'hit enter prompt'
set shortmess=atTIWF

if IsNeoVim()
  " don't give ins-completion-menu messages.
  set shortmess+=c
endif

" Increase ruler height
" set cmdheight=2

" always show status line
set laststatus=2

" always show tab page labels
" set showtabline=2

" Prevent mode info messages on the last line to prevent 'hit enter prompt'
set noshowmode

function! MyStatuslineDir() abort
  let dir = expand("%:p:h:t")
  let project = getcwd()
  let project = fnamemodify(project, ':t')
  if dir == project
    return ''
  endif
  return dir
endfunction

let &statusline .= '%#MyStatuslineProject#'
let &statusline .= ' %<%-0.30{fnamemodify(getcwd(), ":t")} '
let &statusline .= '%#StatusLine#'

let &statusline .= '%#MyStatuslineDirectory#'
let &statusline .= '%<%( %{MyStatuslineDir()} %)'
let &statusline .= '%#StatusLine#'

let &statusline .= '%#MyStatuslineFile#'
let &statusline .= '%<%( %t %)'
let &statusline .= '%#StatusLine#'

let &statusline .= '%#ErrorMsg#'
let &statusline .= '%<%( %w %)'
let &statusline .= '%#StatusLine#'

" let &statusline .= '%#ErrorMsg#'
" let &statusline .= '%<%( %q %)'
" let &statusline .= '%#StatusLine#'
let &statusline .= '%( %{exists("w:quickfix_title") ? w:quickfix_title : ""} %)'

let &statusline .= '%='

" quickfix

let &statusline .= '%#ErrorMsg#'
let &statusline .= '%( %{substitute(len(filter(copy(getqflist()), "v:val.type == \"e\"")), "^0$", "", "g")} %)'
let &statusline .= '%#StatusLine#'

let &statusline .= '%#WarningMsg#'
let &statusline .= '%( %{substitute(len(filter(copy(getqflist()), "v:val.type == \"w\"")), "^0$", "", "g")} %)'
let &statusline .= '%#StatusLine#'

let &statusline .= '%#MoreMsg#'
let &statusline .= '%( %{substitute(len(filter(copy(getqflist()), "v:val.type == \"i\"")), "^0$", "", "g")} %)'
let &statusline .= '%#StatusLine#'

let &statusline .= '%#Cursorline#'
let &statusline .= '%( %{substitute(len(filter(copy(getqflist()), "v:val.type !~? \"i\" && v:val.type !~? \"w\" && v:val.type !~? \"e\" && v:val.valid == 1")), "^0$", "", "g")} %)'
let &statusline .= '%#StatusLine#'

" loclist

let &statusline .= '%#ErrorMsg#'
let &statusline .= '%( %{substitute(len(filter(copy(getloclist(0)), "v:val.type == \"e\"")), "^0$", "", "g")} %)'
let &statusline .= '%#StatusLine#'

let &statusline .= '%#WarningMsg#'
let &statusline .= '%( %{substitute(len(filter(copy(getloclist(0)), "v:val.type == \"w\"")), "^0$", "", "g")} %)'
let &statusline .= '%#StatusLine#'

let &statusline .= '%#MoreMsg#'
let &statusline .= '%( %{substitute(len(filter(copy(getloclist(0)), "v:val.type == \"i\"")), "^0$", "", "g")} %)'
let &statusline .= '%#StatusLine#'

let &statusline .= '%#Cursorline#'
let &statusline .= '%( %{substitute(len(filter(copy(getloclist(0)), "v:val.type !~? \"i\" && v:val.type !~? \"w\" && v:val.type !~? \"e\" && v:val.valid == 1")), "^0$", "", "g")} %)'
let &statusline .= '%#StatusLine#'

"

let &statusline .= ' %{&filetype} '

let &statusline .= '%#ErrorMsg#'
let &statusline .= '%( %{exists("b:region_filetype") ? ">" . b:region_filetype : ""} %)'
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
augroup MyStatuslineAugroup
  autocmd!
  autocmd WinEnter,BufWinEnter,FileType,SessionLoadPost * call setwinvar(0, '&statusline', g:MyStatusline)
  autocmd SessionLoadPost * call setwinvar(0, '&statusline', g:MyStatusline)
  autocmd ColorScheme * if !has('vim_starting') || expand('<amatch>') !=# 'macvim'
        \ | runtime('plugin/my_statusline.vim') | call setwinvar(0, '&statusline', g:MyStatusline) | endif
  autocmd CursorMoved,BufUnload * call setwinvar(0, '&statusline', g:MyStatusline)
augroup END
