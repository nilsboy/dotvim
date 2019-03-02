" Handle notes from vim
" NOTE: alternative: vimwiki - it can use markdown files too

let g:MyNotesDir = "~/stuff/notes/"

nnoremap <silent> <leader>nn :execute 'edit ' . g:MyNotesDir . "README.md"<cr>
nnoremap <silent> <leader>ns :execute 'edit ' . MyNotesNewFilename()<cr>
nnoremap <silent> <leader>nt :execute 'edit ' . g:MyNotesDir . "todo.txt"<cr>
vnoremap <silent> <leader>nn y:execute 'edit ' . g:MyNotesDir . fnameescape(@")<cr>

augroup MyNotesAugroupForceMarkdown
  autocmd!
  autocmd BufReadPost,BufNewFile */notes/* setlocal filetype=markdown
augroup END

function! MyNotesNewFilename() abort
  return g:MyNotesDir . "/note_" . strftime("%Y%m%d_%H%M") 
endfunction
