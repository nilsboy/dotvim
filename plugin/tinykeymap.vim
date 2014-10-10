" no timeout
let g:tinykeymap#timeout = 0

" doh - cannot deactivate message
let g:tinykeymap#message_fmt = "%.0s%.0s"
" let g:tinykeymap#show_message = "statusline"

" Don't load default keymaps
" let g:tinykeymaps_default = ["quickfixlist"]

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
call tinykeymap#Map("file", "o", "normal! :edit <cfile>")
call tinykeymap#Map("file", "t", ':call Tree(".")')

call tinykeymap#EnterMap('help', '<leader>h', {'name': 'help'})
call tinykeymap#Map("help", "h", ':call Notes()', {'exit' : 1})
call tinykeymap#Map("help", "m", ':execute ":edit " . g:MY_VIM . "/plugin/tinykeymap.vim"', {'exit': 1})
call tinykeymap#Map("help", "v", ':call VimEnvironment()', {'exit': 1})
call tinykeymap#Map("help", "l", ':execute ":edit ' . MY_VIM . '/plugin/helpers.vim"', {'exit' : 1 })

" call tinykeymap#EnterMap('quickfixlist', '<leader>q', {'name': 'quickfix'})

call tinykeymap#EnterMap('quickfix', '<leader>z', {'name': 'quickfix'})
call tinykeymap#Map("quickfix", "q", ":cwindow")
call tinykeymap#Map("quickfix", "x", ":RunIntoBuffer")
call tinykeymap#Map("quickfix", "X", ":write | :make | :cwindow")
call tinykeymap#Map("quickfix", "h", "cprevious")
call tinykeymap#Map("quickfix", "l", "cnext")
