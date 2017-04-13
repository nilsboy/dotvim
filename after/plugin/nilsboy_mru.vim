" tags: recent

let s:mru_dir = $XDG_DATA_HOME . '/nilsboy_mru/'
let s:mru_files = s:mru_dir . 'mru_files'
let s:mru_files_written = s:mru_dir . 'mru_files_written'

augroup nilsboy_mru_ReadMru
  autocmd!
  autocmd BufWinLeave * :call nilsboy_mru#add_file(expand('%:p'))
augroup END

augroup nilsboy_mru_WriteMru
  autocmd!
  autocmd BufWritePost * :let b:nilsboy_mru_written = 1
augroup END

call helpers#touch(s:mru_files)

function! nilsboy_mru#add_file(file) abort
    if ! IsNeoVim()
      return
    endif
    if empty(a:file)
        return
    endif
    if BufferIsSpecial()
      return
    endif
    call writefile([a:file], s:mru_files, 'a')
    if exists('b:nilsboy_mru_written')
      call writefile([a:file], s:mru_files_written, 'a')
    endif
endfunction

function! nilsboy_mru#mru_files() abort
    return s:mru_files
endfunction

function! nilsboy_mru#mru_files_written() abort
    return s:mru_files_written
endfunction

function! nilsboy_mru#list_files(file) abort
    cclose
    let &l:makeprg='tac ' . a:file . ' | head -1001 | uniq-unsorted'
    setlocal errorformat=%f
    Neomake!
    copen
endfunction

nnoremap <silent> <leader>rr :call 
      \ nilsboy_mru#list_files(nilsboy_mru#mru_files_written())<cr>
nnoremap <silent> <leader>rR :silent! execute 'silent! edit ' . 
      \ nilsboy_mru#mru_files_written()<cr>

nnoremap <silent> <leader>ro :call 
      \ nilsboy_mru#list_files(nilsboy_mru#mru_files())<cr>
nnoremap <silent> <leader>rO :silent! execute 'silent! edit ' . 
      \ nilsboy_mru#mru_files()<cr>
