let s:bookmarks_dir = $XDG_CONFIG_HOME . '/nilsboy_bookmarks'
let s:bookmarks_file = s:bookmarks_dir . '/bookmarks'

silent execute '!mkdir -p ' . escape(s:bookmarks_dir, ' ')

function! nilsboy_bookmarks#add(file) abort
    if empty(a:file)
        return
    endif
    silent execute '!echo ' . escape(a:file, ' ') . '>> ' . s:bookmarks_file
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

