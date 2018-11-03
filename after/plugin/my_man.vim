let s:cache_dir = $XDG_CACHE_DIR . "/vim-normal-buffer-man"

call Mkdir(s:cache_dir, "p")

function! Man(cmd) abort

    let cmd = a:cmd

    if empty(cmd)
        echomsg "Nothing below cursor - use :Man 'command'"
        return
    endif

    " Avoid .man extension to not trigger the filetype
    let file_name = s:cache_dir . "/" . cmd . ".man.txt"

    " Cannot setlocal filetype=man because it messes with the filename
    " Needs ! to supress error from /usr/share/nvim/runtime/syntax/man.vim
    silent! execute 'edit ' . file_name
    let saved_cursor = getcurpos()
    setlocal noreadonly
    setlocal modifiable
    let &l:buftype = ''
    keepjumps normal ggdG
    silent execute 'r!SHORT=1 man-multi-lookup' cmd
    keepjumps normal! ggdd
    " normal! /^---
    update
    call setpos('.', saved_cursor)

    syntax case  ignore
    syntax match manReference      display '[^()[:space:]]\+([0-9nx][a-z]*)'
    syntax match manSectionHeading display '^\S.*$'
    syntax match manTitle          display '^\%1l.*$'
    syntax match manSubHeading     display '^ \{3\}\S.*$'
    syntax match manOptionDesc     display '^\s\+\%(+\|-\)\S\+'

    highlight default link manTitle          Title
    highlight default link manSectionHeading Statement
    highlight default link manOptionDesc     Constant
    highlight default link manReference      PreProc
    highlight default link manSubHeading     Function

    " keywordprg only works for external apps
    nmap <buffer><silent>K :call Man(expand("<cword>"))<cr><cr>
    " Triggers the build-in man ftplugin
    " setlocal filetype=man
endfunction
command! -nargs=1 Man call Man("<args>")
