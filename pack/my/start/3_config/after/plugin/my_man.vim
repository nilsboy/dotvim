let s:cache_dir = stdpath("cache") . "/vim-normal-buffer-man"

call Mkdir(s:cache_dir, "p")

function! Man(cmd) abort
    let cmd = a:cmd

    if empty(cmd)
        echomsg "Nothing below cursor - use :Man 'command'"
        return
    endif

    " Avoid .man extension to not trigger the filetype
    " because it triggers the "misbehaving" build-in man ftplugin.
    " Needs ! to supress error from /usr/share/nvim/runtime/syntax/man.vim
    let file_name = s:cache_dir . "/" . cmd . ".man.txt"

    silent! execute 'edit ' . file_name

    let saved_cursor = getcurpos()
    setlocal noreadonly
    setlocal modifiable
    let &l:buftype = ''
    keepjumps normal gg"_dG
    silent execute 'r!SHORT=1 man-multi-lookup' cmd
    " silent execute 'r!man-multi-lookup' cmd
    keepjumps normal! gg"_dd
    " setlocal buftype=nowrite
    " needs to be written to keep position within file
    silent! update
    call setpos('.', saved_cursor)
endfunction
command! -nargs=1 Man call Man("<args>")

augroup MyManAugroup
  autocmd!
  autocmd BufRead,BufNewFile *.man.txt setlocal filetype=myman
augroup END
