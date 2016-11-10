let s:bookmarks_dir = $XDG_DATA_HOME . '/nilsboy_bookmarks'
let s:bookmarks_file = s:bookmarks_dir . '/bookmarks'

call helpers#touch(s:bookmarks_file)

function! nilsboy_bookmarks#add(file) abort
    if empty(a:file)
        return
    endif
    call writefile([a:file], s:bookmarks_file, 'a')
endfunction

function! nilsboy_bookmarks#file() abort
    return s:bookmarks_file
endfunction

function! nilsboy_bookmarks#list() abort
    let &l:makeprg='tac ' . nilsboy_bookmarks#file() . ' \| head -1001'
    setlocal errorformat=%f
    silent! make!
    copen
endfunction

nnoremap <silent> <leader>ba :call nilsboy_bookmarks#add(expand('%:p'))<cr>
nnoremap <silent> <leader>bb :call nilsboy_bookmarks#list()<cr>
nnoremap <silent> <leader>be :execute 'edit ' . nilsboy_bookmarks#file()<cr>

