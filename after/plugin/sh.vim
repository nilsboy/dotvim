function! Man(cmd)

    let cmd = a:cmd

    if empty(cmd)
        echomsg "Nothing below cursor - use :Man 'command'"
        return
    endif

    let cache_dir = $XDG_CACHE_DIR
    if empty(cache_dir)
        let cache_dir = $HOME . "/.cache"
    endif
    let cache_dir .= "/vim-normal-buffer-man"

    if empty(glob(cache_dir))
        call mkdir(cache_dir, "p")
    endif

    let file_name = cache_dir . "/" . cmd . ".man"

    silent execute 'edit' file_name
    silent execute 'normal ggdG'
    " silent execute 'r!man' cmd
    silent execute 'r!SHORT=1 man-multi-lookup' cmd
    silent execute 'normal ggdd/^---'
    silent execute ':w'

    " silent :setlocal filetype=man
    " silent :setlocal buftype=nofile

    " keywordprg only works for external apps
    nmap <buffer><silent>K :call Man(expand("<cword>"))<cr><cr>

    nmap <buffer> <SPACE> <C-F>
    nmap <buffer> b <C-B>
endfunction

command! -nargs=1 Man call Man("<args>")
