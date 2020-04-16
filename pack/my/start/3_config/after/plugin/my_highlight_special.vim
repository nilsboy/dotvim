finish
" Hightlight all occurences of special character under cursor

augroup MyHighlightSpecialAugroup
  autocmd!
  autocmd CursorHold * call my_highlight_special#hi()
augroup END

function! my_highlight_special#hi() abort
  let toMatch = matchstr(getline('.'), '\%' . col('.') . 'c.') 
  if toMatch =~ '\v\a|\s'
    match none
    return
  endif
  let toMatch = escape(toMatch, '\')
  echo "toMatch: " . toMatch
  execute 'match Todo /\V' . toMatch . '/'
endfunction
