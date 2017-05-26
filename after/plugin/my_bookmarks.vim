" Manually create bookmarks for files

let g:MyBookmarksDir = $XDG_DATA_HOME . '/nilsboy_bookmarks'
let g:MyBookmarksFile = g:MyBookmarksDir . '/bookmarks'

call helpers#touch(g:MyBookmarksFile)

function! MyBookmarksAdd(file) abort
    if empty(a:file)
        return
    endif
    if IsNeoVim()
      call writefile([a:file], g:MyBookmarksFile, 'a')
    endif
endfunction

function! MyBookmarksFile() abort
    return g:MyBookmarksFile
endfunction

function! MyBookmarksList() abort
    let &l:makeprg='tac ' . MyBookmarksFile() . ' | head -1001'
    setlocal errorformat=%f
    Neomake!
    copen
endfunction

nnoremap <silent> <leader>ba :call MyBookmarksAdd(expand('%:p'))<cr>
nnoremap <silent> <leader>bb :call MyBookmarksList()<cr>
nnoremap <silent> <leader>be :execute 'edit ' . MyBookmarksFile()<cr>

