setlocal keywordprg=:help

setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=2

" there doesn't seem to be a formatter for vimscript (2017-01-24)
" let g:neoformat_enabled_vim = [ '' ]

" Pip installation currently broken (2017-01-24):
" https://github.com/Kuniwak/vint/issues/182
" let g:ale_linters['vim'] = ['vint']
" let g:ale_vim_vint_show_style_issues = 0
"
" function! lsp#ui#vim#references() abort
  " ^\s*fu\%[nction][! ]\s*\%(s:\)\=

" let &l:define = '^\s*fu\%[nction][! ]|augroup\s*'
let b:outline = '^\s*fun\w*[! ]+'
