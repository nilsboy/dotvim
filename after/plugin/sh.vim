let s:cache_dir = $XDG_CACHE_DIR . "/vim-normal-buffer-man"

call mkdir(s:cache_dir, "p")

function! Man(cmd) abort

    let cmd = a:cmd

    if empty(cmd)
        echomsg "Nothing below cursor - use :Man 'command'"
        return
    endif

    let file_name = s:cache_dir . "/" . cmd . ".man"

    " Needs ! to supress error from /usr/share/nvim/runtime/syntax/man.vim
    silent! execute 'edit ' file_name
    setlocal noreadonly
    setlocal modifiable
    let &l:buftype = ''
    normal ggdG
    silent execute 'r!SHORT=1 man-multi-lookup' cmd
    normal ggdd/^---
    write

    " keywordprg only works for external apps
    nmap <buffer><silent>K :call Man(expand("<cword>"))<cr><cr>
endfunction

command! -nargs=1 Man call Man("<args>")
