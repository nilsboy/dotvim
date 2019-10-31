" Handle notes from vim
" NOTE: alternative: vimwiki - it can use markdown files too

let g:MyNotesDir = "~/stuff/notes/"

nnoremap <silent> <leader>nn :execute 'edit ' . g:MyNotesDir . "README.md"<cr>
nnoremap <silent> <leader>ns :execute 'edit ' . MyNotesNewFilename()<cr>
vnoremap <silent> <leader>nn "zy:execute 'edit ' . g:MyNotesDir . fnameescape(@z)<cr>

augroup MyNotesAugroupForceMarkdown
  autocmd!
  autocmd BufReadPost,BufNewFile */stuff/notes/* setlocal filetype=markdown
augroup END

function! MyNotesNewFilename() abort
  return g:MyNotesDir . "/scratch_" . strftime("%Y%m%d_%H%M") 
endfunction
