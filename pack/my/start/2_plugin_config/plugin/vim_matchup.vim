" even better % navigate and highlight
" TAGS: matchit parens
PackAdd andymass/vim-matchup

" NOTE: needs matchparen to be enabled (2020-01-10)
" let g:matchup_transmute_enabled = 1

let g:matchup_matchparen_enabled = 0

" copy of matchup private function
function! vim_matchup#clear() abort
  if exists('w:matchup_match_id_list')
    for l:id in w:matchup_match_id_list
      silent! call matchdelete(l:id)
    endfor
    unlet! w:matchup_match_id_list
  endif
endfunction

" makes the cursor hang when searching for matches
" augroup vim_matchup#augroupHighlight
"   autocmd!
"   autocmd CursorHold * :call vim_matchup#clear()  
"   autocmd CursorHold * :call matchup#matchparen#highlight_surrounding()  
" augroup END

" Remove CursorMoved autocmds for speed up.
" Open ticket?
augroup matchup_matchparen
  autocmd!
augroup END
