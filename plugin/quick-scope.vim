finish
" Lightning fast left-right movement in Vim 
PackAdd unblevable/quick-scope

augroup qs_colors
  autocmd!
  autocmd ColorScheme * highlight QuickScopePrimary ctermfg=196 cterm=underline
  autocmd ColorScheme * highlight QuickScopeSecondary ctermfg=110 cterm=underline
augroup END
