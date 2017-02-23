let s:mru_dir = $XDG_DATA_HOME . '/nilsboy_mru/'
let s:mru_files = s:mru_dir . 'mru_files'
let s:mru_files_written = s:mru_dir . 'mru_files_written'

autocmd BufWinLeave * :call nilsboy_mru#add_file(expand('%:p'), s:mru_files)
autocmd BufWritePost *
      \ :call nilsboy_mru#add_file(expand('%:p'), s:mru_files_written)

call helpers#touch(s:mru_files)

function! nilsboy_mru#add_file(file, mru_file) abort
    " exclude temp files from NrrwRgn plugin
    if a:file =~ '/tmp/NrrwRgn_.*'
      return
    endif
    let l:flag = printf('%s%s', 'b:nilsboy_mru_', fnamemodify(a:mru_file, ':t'))
    if exists(l:flag)
        return
    endif
    if empty(a:file)
        return
    endif
    if &previewwindow
        return
    endif
    execute 'let ' . l:flag . ' = 1'
    if IsNeoVim()
      call writefile([a:file], a:mru_file, 'a')
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
      \ nilsboy_mru#list_files(nilsboy_mru#mru_files())<cr>
nnoremap <silent> <leader>rw :call 
      \ nilsboy_mru#list_files(nilsboy_mru#mru_files_written())<cr>
nnoremap <silent> <leader>rer :silent! execute 'silent! edit ' . 
      \ nilsboy_mru#mru_files()<cr>
nnoremap <silent> <leader>rew :silent! execute 'silent! edit ' . 
      \ nilsboy_mru#mru_files_written()<cr>
