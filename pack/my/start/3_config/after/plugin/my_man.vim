let s:cache_dir = stdpath("cache") . "/vim-normal-buffer-man"

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

    " keywordprg only works for external apps
    nmap <buffer><silent>K :call Man(expand("<cword>"))<cr>

    let saved_cursor = getcurpos()
    setlocal noreadonly
    setlocal modifiable
    let &l:buftype = ''
    keepjumps normal gg"_dG
    " silent execute 'r!SHORT=1 man-multi-lookup' cmd
    silent execute 'r!man-multi-lookup' cmd
    keepjumps normal! gg"_dd
    " setlocal buftype=nowrite
    " needs to be written to keep position within file
    update
    call setpos('.', saved_cursor)

    " Not using filetype=man here because it triggers the
    " "misbehaving" build-in man ftplugin
    setlocal filetype=myman
    setlocal syntax=man
endfunction
command! -nargs=1 Man call Man("<args>")
