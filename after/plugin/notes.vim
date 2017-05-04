" Handle notes from vim

let g:notes_dir = "~/stuff/notes/"
let g:notes_last_note = ''

nnoremap <silent> <leader>ns :call notes#editLastNote()<cr>
nnoremap <silent> <leader>nS :execute 'edit ' . notes#newFileName()<cr>

nnoremap <silent> <leader>nh :execute 'edit ' . g:notes_dir . "Home.txt"<cr>
nnoremap <silent> <leader>nt :execute 'edit ' . g:notes_dir . "todo.txt"<cr>

nnoremap <silent> <leader>ne :execute "edit " 
      \ . g:notes_dir . fnameescape(input('Topic: ')) . ".txt"<cr>

nnoremap <silent> <leader>ni :call nilsboy_quickfix#search({
      \ 'term': input('Search: '),
      \ 'path': g:notes_dir })<cr>

function! notes#editLastNote() abort
  if g:notes_last_note == ''
    let g:notes_last_note = notes#newFileName()
  endif
  execute 'edit ' . g:notes_last_note
  " call nilsboy_quickfix#search({
  "     \ 'term': '\/note_',
  "     \ 'path': g:notes_dir })
endfunction

" Hack until the old notes are converted from zim to markdown
augroup augroup_notes
  autocmd!
  autocmd BufReadPost */notes/*.txt setlocal filetype=markdown
augroup END

function! notes#newFileName() abort
  let g:notes_last_note = g:notes_dir . "/note_" 
        \ . strftime("%Y%m%d_%H%M") . ".txt"
  return g:notes_last_note
endfunction

if neobundle#tap('vim-operator-user') 
  function! neobundle#hooks.on_post_source(bundle) abort
    call operator#user#define('notes', 'OpOpenNote')
    function! OpOpenNote(motion_wise) abort
	    let v = operator#user#visual_command_from_wise_name(a:motion_wise)
	    execute 'normal!' '`[' . v . '`]"xy'
      execute "edit " . g:notes_dir . fnameescape(@x) . ".txt"
    endfunction
  endfunction
  call neobundle#untap()
endif
map <leader>nn <Plug>(operator-notes)

if neobundle#tap('vim-operator-user') 
  function! neobundle#hooks.on_post_source(bundle) abort
    call operator#user#define('notefind', 'OpNoteFind')
    function! OpNoteFind(motion_wise) abort
      let v = operator#user#visual_command_from_wise_name(a:motion_wise)
	    execute 'normal!' '`[' . v . '`]"xy'
      call nilsboy_quickfix#search({
            \ 'term': @x,
            \ 'path': g:notes_dir })
    endfunction
  endfunction
  call neobundle#untap()
endif
map <leader>nf <Plug>(operator-notefind)
