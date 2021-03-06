" Manually create bookmarks for files
" SEE ALSO: https://github.com/MattesGroeger/vim-bookmarks

let g:MyBookmarksDir = stdpath("data") . '/nilsboy_bookmarks'
let g:MyBookmarksFile = g:MyBookmarksDir . '/bookmarks'

call nb#touch(g:MyBookmarksFile)

function! MyBookmarksAdd(file) abort
    if empty(a:file)
        return
    endif
    if nb#isNeovim()
      call writefile([a:file], g:MyBookmarksFile, 'a')
    endif
endfunction

function! MyBookmarksFile() abort
    return g:MyBookmarksFile
endfunction

function! MyBookmarksList() abort
    let &l:makeprg='tac ' . MyBookmarksFile() . ' \| head -1001'
    setlocal errorformat=%f
    silent make!
    copen
endfunction

nnoremap <silent> <leader>Ba :call MyBookmarksAdd(expand('%:p'))<cr>
nnoremap <silent> <leader>BB :call MyBookmarksList()<cr>
nnoremap <silent> <leader>Be :execute 'edit ' . MyBookmarksFile()<cr>

