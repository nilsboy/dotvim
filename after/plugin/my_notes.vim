" Handle notes from vim
" TODO: checkout vimwiki - it works with markdown files too

let g:MyNotesDir = "~/stuff/notes/"
let g:MyNotesLastNote = ''

nnoremap <silent> <leader>ns :call MyNotesEditLastNote()<cr>
nnoremap <silent> <leader>nS :execute 'edit ' . MyNotesNewFileName()<cr>

nnoremap <silent> <leader>nh :execute 'edit ' . g:MyNotesDir . "Home.txt"<cr>
nnoremap <silent> <leader>nt :execute 'edit ' . g:MyNotesDir . "todo.txt"<cr>

vnoremap <silent> <leader>nv y:execute 'edit ' . g:MyNotesDir . fnameescape(@") . '.txt'<cr>

nnoremap <silent> <leader>ne :execute "edit " 
      \ . g:MyNotesDir . fnameescape(input('Topic: ')) . ".txt"<cr>

nnoremap <silent> <leader>ni :call MyQuickfixSearch({
      \ 'term': input('Search: '),
      \ 'path': g:MyNotesDir })<cr>

function! MyNotesEditLastNote() abort
  if g:MyNotesLastNote == ''
    let g:MyNotesLastNote = MyNotesNewFileName()
  endif
  execute 'edit ' . g:MyNotesLastNote
endfunction

" Hack until the old notes are converted from zim to markdown
augroup MyNotesAugroup
  autocmd!
  autocmd BufReadPost */notes/*.txt setlocal filetype=markdown
augroup END

function! MyNotesNewFileName() abort
  let g:MyNotesLastNote = g:MyNotesDir . "/note_" 
        \ . strftime("%Y%m%d_%H%M") . ".txt"
  return g:MyNotesLastNote
endfunction

if neobundle#tap('vim-operator-user') 
  function! neobundle#hooks.on_post_source(bundle) abort
    call operator#user#define('notes', 'OpOpenNote')
    function! OpOpenNote(motion_wise) abort
	    let v = operator#user#visual_command_from_wise_name(a:motion_wise)
	    execute 'normal!' '`[' . v . '`]"xy'
      execute "edit " . g:MyNotesDir . fnameescape(@x) . ".txt"
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
      call MyQuickfixSearch({
            \ 'term': @x,
            \ 'path': g:MyNotesDir })
    endfunction
  endfunction
  call neobundle#untap()
endif
map <leader>nf <Plug>(operator-notefind)
