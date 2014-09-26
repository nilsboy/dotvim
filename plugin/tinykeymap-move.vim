" no timeout
let g:tinykeymap#timeout = 0

" doh - cannot deactivate message
let g:tinykeymap#message_fmt = "%.0s%.0s"
" let g:tinykeymap#show_message = "statusline"

" Don't load default keymaps
let g:tinykeymaps_default = [""]

call tinykeymap#EnterMap('buffers', '<leader>b', {'name': 'buffers'})
call tinykeymap#Map('buffers', 'n', 'new') 
call tinykeymap#Map("buffers", "c", "bdelete")
call tinykeymap#Map("buffers", "l", "bnext")
call tinykeymap#Map("buffers", "h", "bprev")

call tinykeymap#EnterMap('windows', '<leader>ww', {'name': 'windows'})
call tinykeymap#Map('windows', 'n', 'new') 
call tinykeymap#Map("windows", "c", "close")
call tinykeymap#Map("windows", "h", "wincmd h")
call tinykeymap#Map("windows", "l", "wincmd l")
call tinykeymap#Map("windows", "j", "wincmd j")
call tinykeymap#Map("windows", "k", "wincmd k")

call tinykeymap#EnterMap('tags', '<leader>t', {'name': 'tags'})
call tinykeymap#Map("tags", "t", ':UniteWithCursorWord -buffer-name=unite-tags -keep-focus tag')
" call tinykeymap#Map("tags", "t", ':new | :UniteWithCursorWord -buffer-name=unite-tags -keep-focus tag')
" call tinykeymap#Map("tags", "t", 'tjump <C-w>')
call tinykeymap#Map("tags", "T", "tjump")
call tinykeymap#Map("tags", "l", "tnext")
call tinykeymap#Map("tags", "j", "tprev")
" nnoremap <silent>t :execute 'tjump ' . expand("<cword>")<cr>
" nnoremap <silent>T :tjump 

call tinykeymap#EnterMap('marks', '<leader>m', {'name': 'marks'})
" jump to next lowercase mark
call tinykeymap#Map("marks", "k", "normal! ['")
" jump to previous lowercase mark 
call tinykeymap#Map("marks", "j", "normal! ]'")

call tinykeymap#EnterMap('jumps', '<leader>j', {'name': 'jumps'})
call tinykeymap#Map("jumps", "i", ":Unite jump")
call tinykeymap#Map("jumps", "h", "normal! <C-O>")
call tinykeymap#Map("jumps", "l", "normal! <C-I>")

call tinykeymap#EnterMap('file', '<leader>f', {'name': 'file'})
call tinykeymap#Map("file", "f", ':call Find(".")')
call tinykeymap#Map("file", "a", ':call Find("~/src")')
call tinykeymap#Map("file", "g", ':call Find("~/src")')
call tinykeymap#Map("file", "o", "normal! :e <cfile>")
call tinykeymap#Map("file", "t", ':call Tree(".")')

call tinykeymap#EnterMap('quickfix', '<leader>z', {'name': 'quickfix'})
call tinykeymap#Map("quickfix", "q", ":copen 999")
call tinykeymap#Map("quickfix", "r", ":make | :copen 999 | normal! <esc>")
call tinykeymap#Map("quickfix", "h", "cprevious")
call tinykeymap#Map("quickfix", "l", "cnext")

nnoremap <leader>xz :make<cr>:cwindow 999<cr>
nnoremap <leader>x :call Run()<cr>
nnoremap <leader>q <silent> :cwindow 999<cr>

" let &grepprg=cd 
" set grepformat=%f:%l:%m

function! Run()

    let file = expand("<cfile>")
    enew
    setlocal nowrite
    execute ":r!" . file
    normal <cr>
    normal ggdd
    AnsiEsc

endfunction

" command! -nargs=1 GB call GrepFile("<cfile>", "<args>")
function! GrepBuffer(path, ...)

    execute "e " . a:path . "/._vim_find"
    setlocal nowrite
    execute ":r!cd " . a:path . " && find-or-grep " . join(a:000, " ")
    normal ggdd
    nnoremap <buffer> <CR> gf

endfunction

command! -nargs=1 G call Grep("~/src", "<args>")
function! Grep(path, ...)

    execute "e " . a:path . "/._vim_find"
    setlocal nowrite
    execute ":r!cd " . a:path . " && find-or-grep " . join(a:000, " ")
    normal ggdd
    nnoremap <buffer> <CR> gf

endfunction

command! -nargs=1 F call Find("~/src", "<args>")
function! Find(path, ...)

    execute "e " . a:path . "/._vim_find"
    setlocal nowrite
    execute ":r!cd " . a:path . " && find-and " . join(a:000, " ")
    normal ggdd
    nnoremap <buffer> <CR> gf

endfunction

function! Tree(path)

    enew
    setlocal nowrite
    setlocal listchars=
    nnoremap <buffer> <CR> gf
    execute ":r!tree --no-colors --exclude '\class$' " . a:path
    normal gg

endfunction
