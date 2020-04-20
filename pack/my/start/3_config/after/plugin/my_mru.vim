" List recent edited or viewed files
" tags: recent

let g:MyMrudir = stdpath("data") . '/nilsboy_mru/'
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

call nb#touch(g:MruFiles)

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
    let &l:makeprg='tac ' . a:file . ' \| grep -v "^/tmp/" \| head -1001 \| uniq-unsorted'
    setlocal errorformat=%f
    silent make!
    copen
endfunction

nnoremap <silent> <leader>rr :call 
      \ MyMruListFiles(MyMruFilesWritten())<cr>
nnoremap <silent> <leader>rer :silent execute 'edit ' . 
      \ MyMruFilesWritten()<cr>

nnoremap <silent> <leader>ro :call 
      \ MyMruListFiles(MyMruFiles())<cr>
nnoremap <silent> <leader>reo :silent execute 'edit ' .
      \ MyMruFiles()<cr>
