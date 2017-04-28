" Handle notes from vim

let g:notes_dir = "~/stuff/notes/"
let g:notes_last_note = ''

nnoremap <silent> <leader>nN :execute 'edit ' . notes#newFileName()<cr>
nnoremap <silent> <leader>nh :execute 'edit ' . g:notes_dir . "Home.txt"<cr>
nnoremap <silent> <leader>nt :execute 'edit ' . g:notes_dir . "todo.txt"<cr>
nnoremap <silent> <leader>ne yiW:execute "edit " 
      \ . g:notes_dir . fnameescape(@") . ".txt"<cr>

nnoremap <silent> <leader>ni :execute "edit " 
      \ . g:notes_dir . fnameescape(input('Topic: ')) . ".txt"<cr>

nnoremap <silent> <leader>nn :execute 'edit ' . g:notes_last_note<cr>

function! notes#editLastNote() abort
  if g:notes_last_note != ''
    execute 'edit ' . g:notes_last_note<cr>
    return
  endif
  call nilsboy_quickfix#search({
      \ 'term': 'note_',
      \ 'path': g:notes_dir })
endfunction

augroup augroup_notes
  autocmd!
  autocmd BufReadPost */notes/*.txt setlocal filetype=markdown
augroup END

nnoremap <silent> <leader>nfw yiw:call nilsboy_quickfix#search({
      \ 'term': @",
      \ 'path': g:notes_dir })<cr>
nnoremap <silent> <leader>nfW yiW:call nilsboy_quickfix#search({
      \ 'term': @",
      \ 'path': g:notes_dir })<cr>
nnoremap <silent> <leader>nfi :call nilsboy_quickfix#search({
      \ 'term': input('Search: '),
      \ 'path': g:notes_dir })<cr>

function! notes#newFileName() abort
  let g:notes_last_note = g:notes_dir . "/note_" 
        \ . strftime("%Y%m%d_%H%M") . ".txt"
  return g:notes_last_note
endfunction
