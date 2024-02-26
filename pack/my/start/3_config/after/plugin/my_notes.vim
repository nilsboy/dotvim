" Helpers for taking notes

let my_notes#dir = "~/stuff/notes/"

nnoremap <silent> <leader>nn :execute 'edit ' . my_notes#dir . "README.md"<cr>
nnoremap <silent> <leader>ns :execute 'edit ' . my_notes#dir . "/scratch_" . strftime("%Y%m%d_%H%M")<cr>
nnoremap <silent> <leader>nS :call MyQuickfixSearch(
  \ { 'term': 'scratch_', 'path': my_notes#dir, 'grep': 0 })<cr>
vnoremap <silent> <leader>nn 
  \ "zy:execute 'edit ' . my_notes#dir . fnameescape(@z)<cr>

augroup my_notes#autocmdForceMarkdown
  autocmd!
  autocmd BufReadPost,BufNewFile */stuff/notes/* setlocal filetype=markdown
augroup END
