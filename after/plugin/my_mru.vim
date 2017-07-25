" List recent edited or viewed files
" tags: recent

let g:MyMrudir = $XDG_DATA_HOME . '/nilsboy_mru/'
let g:MruFiles = g:MyMrudir . 'mru_files'
let g:MruFilesWritten = g:MyMrudir . 'mru_files_written'

augroup MyNilsboyMruAugroupReadFiles
  autocmd!
  autocmd BufWinLeave * :call MyMruAddFile(expand('%:p'))
augroup END

augroup MyNilsboyMruAugroupWrittenFiles
  autocmd!
  autocmd BufWritePost * :let b:nilsboy_mru_written = 1
augroup END

call helpers#touch(g:MruFiles)

function! MyMruAddFile(file) abort
    if ! IsNeoVim()
      return
    endif
    if empty(a:file)
        return
    endif
    if BufferIsSpecial()
      return
    endif
    call writefile([a:file], g:MruFiles, 'a')
    if exists('b:nilsboy_mru_written')
      call writefile([a:file], g:MruFilesWritten, 'a')
    endif
endfunction

function! MyMruFiles() abort
    return g:MruFiles
endfunction

function! MyMruFilesWritten() abort
    return g:MruFilesWritten
endfunction

function! MyMruListFiles(file) abort
    cclose
    let &l:makeprg='tac ' . a:file . ' | head -1001 | uniq-unsorted'
    setlocal errorformat=%f
    Neomake!
    copen
endfunction

nnoremap <silent> <leader>rr :call 
      \ MyMruListFiles(MyMruFilesWritten())<cr>
nnoremap <silent> <leader>rer :silent! execute 'silent! edit ' . 
      \ MyMruFilesWritten()<cr>

nnoremap <silent> <leader>ro :call 
      \ MyMruListFiles(MyMruFiles())<cr>
nnoremap <silent> <leader>reo :silent! execute 'silent! edit ' . 
      \ MyMruFiles()<cr>
