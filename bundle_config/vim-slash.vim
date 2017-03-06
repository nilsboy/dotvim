" Enhancing in-buffer search experience
" NeoBundle 'junegunn/vim-slash'
" Use pullrequest for now to make slash_immobile work
NeoBundle 'nilsboy/vim-slash'
" Note: removes highlight on cursor move

let g:slash_immobile = 0

if neobundle#tap('vim-slash') 
  function! neobundle#hooks.on_post_source(bundle) abort
    " unmap *
  endfunction
  call neobundle#untap()
endif

finish

" TODO: use for search start highlight?
function! s:flash()
  set cursorline!
  redraw
  sleep 20m
  set cursorline!
  return ''
endfunction

noremap <expr> <plug>(slash-after) <sid>flash()
