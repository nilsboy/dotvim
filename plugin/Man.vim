" runtime! ftplugin/man.vim

nnoremap <silent> K :call MyMan()<cr>

function! MyMan()
    :e 'man bash'
    r!man bash
    exec "normal ggdd"
    :set filetype=man
    :setlocal buftype=nofile
    map <buffer> <silent> <esc> :bwipeout!<cr>
    " haha
endfunction
