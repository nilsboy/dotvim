" Define temporary keymaps
NeoBundle 'tinykeymap'

"### config ####################################################################

if neobundle#tap('tinykeymap')
    function! neobundle#hooks.on_source(bundle)

" no timeout
let g:tinykeymap#timeout = 0

" doh - cannot deactivate message
let g:tinykeymap#message_fmt = "%.0s%.0s"
" let g:tinykeymap#show_message = "statusline"

" Default keymaps to load
let g:tinykeymaps_default = []

" ### help ###################################################################

call tinykeymap#EnterMap('help', '<leader>h', {'name': 'help'})
call tinykeymap#Map("help", "h", ':call Notes()', {'exit' : 1})
call tinykeymap#Map("help", "m", ':execute ":edit ' . g:vim.bundle.settings.dir . '/tinykeymap.vim"', {'exit': 1})
call tinykeymap#Map("help", "e", ':call VimEnvironment()', {'exit': 1})
call tinykeymap#Map("help", "l", ':execute ":edit ' . g:vim.plugin.dir . '/helpers.vim"', {'exit': 1 })
call tinykeymap#Map("help", "v", ':execute ":e ' . g:vim.rc . '"', {'exit': 1 })

" ### buffers ################################################################

call tinykeymap#EnterMap('buffers', '<leader>b', {'name': 'buffers'})
call tinykeymap#Map('buffers', 'n', 'new') 
call tinykeymap#Map("buffers", "c", "bdelete")
call tinykeymap#Map("buffers", "l", "bnext")
call tinykeymap#Map("buffers", "h", "bprev")
call tinykeymap#Map("buffers", "g", ":L9GrepBufferAll ")
call tinykeymap#Map("buffers", "i", "", {'exit': 1})
call tinykeymap#Map("buffers", "<leader>", "", {'exit': 1})

" ### windows #################################################################

call tinykeymap#EnterMap('windows', '<leader>w', {'name': 'windows'})
call tinykeymap#Map('windows', 'n', ':new')
call tinykeymap#Map("windows", "o", "only", {'exit': 1 })
call tinykeymap#Map("windows", "c", "close")
call tinykeymap#Map("windows", "h", "wincmd h")
call tinykeymap#Map("windows", "l", "wincmd l")
call tinykeymap#Map("windows", "j", "wincmd j")
call tinykeymap#Map("windows", "k", "wincmd k")
call tinykeymap#Map("windows", "s", "split")
call tinykeymap#Map("windows", "v", "vsplit")
call tinykeymap#Map("windows", "q", "quit")
call tinykeymap#Map("windows", "i", "", {'exit': 1})
call tinykeymap#Map("windows", "<leader>", "", {'exit': 1})

" ### Tags #####################################################################

" call tinykeymap#EnterMap('tags', '<leader>t', {'name': 'tags'})
" call tinykeymap#Map("tags", "t", ':UniteWithCursorWord -buffer-name=unite-tags -keep-focus tag')
" " call tinykeymap#Map("tags", "t", ':new | :UniteWithCursorWord -buffer-name=unite-tags -keep-focus tag')
" " call tinykeymap#Map("tags", "t", 'tjump <C-w>')
" call tinykeymap#Map("tags", "T", "tjump")
" call tinykeymap#Map("tags", "l", "tnext")
" call tinykeymap#Map("tags", "j", "tprev")
" " nnoremap <silent>t :execute 'tjump ' . expand("<cword>")<cr>
" " nnoremap <silent>T :tjump 

" ### Marks ####################################################################

call tinykeymap#EnterMap('marks', '<leader>m', {'name': 'marks'})
" jump to next lowercase mark
call tinykeymap#Map("marks", "k", "normal! ['")
" jump to previous lowercase mark 
call tinykeymap#Map("marks", "j", "normal! ]'")

" ### Jumps ####################################################################

" Remap keys to be usable by tinykeymap and use <tab> somewhere else
nnoremap <leader>!a <C-o>
nnoremap <leader>!b <C-i>

function! Noop(...)
    echo "unknown key"
    return 0
endfunction

call tinykeymap#EnterMap('jumps', '<leader>j', {'name': 'jumps'
    \ , 'unknown_key': 'Noop'
  \ })
call tinykeymap#Map("jumps", "o", ":Unite jump", { 'exit': 1 })
call tinykeymap#Map("jumps", "h", "normal ,!a")
call tinykeymap#Map("jumps", "l", "normal ,!b")
call tinykeymap#Map("jumps", "i", "", {'exit': 1})

" ### Files ####################################################################

call tinykeymap#EnterMap('file', '<leader>f', {'name': 'file'})
call tinykeymap#Map("file", "f", ':Unite -buffer-name=files -start-insert file_rec', {'exit': 1})
call tinykeymap#Map("file", "x", 'new | r! find-and | :normal ggdd', {'exit': 1})
call tinykeymap#Map("file", "o", "normal! :edit <cfile>")
call tinykeymap#Map("file", "t", ':call Tree(".")', {'exit': 1})


" ### Quickfix #################################################################

" call tinykeymap#EnterMap('quickfixlist', '<leader>q', {'name': 'quickfix'})

call tinykeymap#EnterMap('quickfix', '<leader>q', {'name': 'quickfix'})
call tinykeymap#Map("quickfix", "q", ":copen", {'exit': 1})
call tinykeymap#Map("quickfix", "X", ":RunIntoBuffer", {'exit': 1 })
call tinykeymap#Map("quickfix", "x", ":write | :make | :cwindow", {'exit': 1})
call tinykeymap#Map("quickfix", "h", ":cprevious")
call tinykeymap#Map("quickfix", "l", ":cnext")

" ### Location list ############################################################

call tinykeymap#EnterMap('location', '<leader>x', {'name': 'location'})
call tinykeymap#Map("location", "q", ":lwindow", {'exit': 1})
call tinykeymap#Map("location", "x", ':RunIntoBufferOrLastCommand' , {'exit': 1 })
call tinykeymap#Map("location", "X", ":RunIntoBufferCurrentBuffer", {'exit': 1 })
" call tinykeymap#Map("location", "X", ":write | :make | :lwindow", {'exit': 1})

call tinykeymap#Map("location", "c", ":Redir :RunCursorLine", {'exit': 1})
call tinykeymap#Map("location", "C", ":RunCursorLine", {'exit': 1})
call tinykeymap#Map("location", "0", "lrewind")
call tinykeymap#Map("location", "$", "llast")
call tinykeymap#Map("location", "h", "lprevious")
call tinykeymap#Map("location", "l", "lnext")

" Jump between files
call tinykeymap#Map("location", "j", "lpfile")
call tinykeymap#Map("location", "k", "lnfile")

" Change to older location list results
call tinykeymap#Map("location", "o", "lnewer")
call tinykeymap#Map("location", "i", "lolder")

" ### End ######################################################################

  endfunction
  call neobundle#untap()
endif
