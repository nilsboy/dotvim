" highlighting word under cursor and all of its occurences
PackAdd dominikduda/vim_current_word

let g:vim_current_word#enabled = 1

" Twins of word under cursor:
let g:vim_current_word#highlight_twins = 1
" The word under cursor:
let g:vim_current_word#highlight_current_word = 1

function! MyCurrentWordSetColors() abort
  highlight CurrentWord ctermbg=194
  highlight CurrentWordTwins ctermbg=194
endfunction
augroup MyCurrentWordAugroup
  autocmd!
  autocmd ColorScheme,Syntax,FileType * call MyCurrentWordSetColors()
augroup END
