finish
" NOTE: checkout surfraw
" checkout: selenium - use with headless browser?

" nnoremap <silent><leader>ii :call Browser()<CR>

" nnoremap <leader>ii :silent !xdg-open <C-R>=escape("<C-R><C-F>", "#?&;\|%")<CR><CR>

function! MyBrowser() abort
    let line = getline(".")
    let url = matchstr(line, "http[^ ]*")
    if url ==""
        let url = matchstr(line, "ftp[^ ]*")
    endif
    if url == ""
        let url = matchstr(line, "file[^ ]*")
    endif
    let url = escape(url, "#?&;|%")
    if url == ""
        let url = expand("<cword>")
        if url != ""
            let url = "https://duckduckgo.com/html/?q=" . url
        endif
    endif
    silent! :execute ":Verbose elinks -dump -dump-width 80 -no-numbering -no-references -no-connect \"" . url . "\" &"
    normal gg
endfunction

