finish
" Highlight current word under cursor
" see also: https://old.reddit.com/r/vim/comments/dytipf/best_most_performant_plugin_to_highlight_the_word/f83xl4m/

" NOTE: TBD

let g:my_cursorword_highlight_matchId = 0

highlight! link MatchCursorWord MoreMsg

nnoremap <leader>hh :call my_cursorword_highlight#highlight()<cr>

function! my_cursorword_highlight#highlight() abort
  if g:my_cursorword_highlight_matchId != 0
    silent! call matchdelete(g:my_cursorword_highlight_matchId)
    let g:my_cursorword_highlight_matchId = 0
  endif
  let g:my_cursorword_highlight_matchId = matchadd('MatchCursorWord', expand('<cword>'))
  if g:my_cursorword_highlight_matchId == -1
    let g:my_cursorword_highlight_matchId = 0
  endif
endfunction

augroup my_cursorword_highlight#augroupHighlightCursorWord
  autocmd!
  autocmd CursorHold * :call my_cursorword_highlight#highlight()
augroup END

" NOTE: slows scrolling down
" augroup my_cursorword_highlight#augroupHighlightCursorWord
"   autocmd!
"   autocmd CursorMoved * :call my_cursorword_highlight#highlight()
" augroup END

