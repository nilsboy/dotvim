autocmd BufEnter * :call nilsboy_mru#add_file(expand('%:p'))

let s:mru_dir = $XDG_DATA_HOME . '/nilsboy_mru'
let s:mru_files = s:mru_dir . '/mru_files'

call helpers#touch(s:mru_files)

function! nilsboy_mru#add_file(file) abort
    if exists('b:MyMru_done')
        return
    endif
    if empty(a:file)
        return
    endif
    if &previewwindow
        return
    endif
    let b:MyMru_done = 1
    call writefile([a:file], s:mru_files, 'a')
endfunction

function! nilsboy_mru#files() abort
    return s:mru_files
endfunction

function! nilsboy_mru#list_files() abort
    let &l:makeprg='tac ' . nilsboy_mru#files() . ' \| head -1001'
    setlocal errorformat=%f
    silent! make!
    copen
endfunction

nnoremap <silent> <leader>rr :call nilsboy_mru#list_files()<cr>
nnoremap <silent> <leader>re :silent! execute 'silent! edit ' . nilsboy_mru#files()<cr>
