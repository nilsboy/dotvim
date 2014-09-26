map <silent> <Leader>w :call PerlTidy()<CR>

function! PerlTidy()
    let _view=winsaveview()
    "%!perltidy -q
    %!perltidier -q
    " %!tidyall --conf-name ~/.tidyallrc -p ~/.tidyallrc
    call winrestview(_view)
endfunction

" :au CursorHold <buffer>  echo 'hold'
" augroup perl_tidy
"     autocmd!
"     autocmd InsertLeave <buffer>
"                 \ call PerlTidy()
" augroup END

compiler perl

" Needs cpanm App::PMUtils
nnoremap <buffer> <silent> <Enter> :execute 'e `pmpath ' . expand("<cword>") . '`'<cr>

" runtime! ftplugin/sh.vim
set keywordprg=!perldoc
" nnoremap <buffer> <silent> K :call Man(expand("<cword>"))<cr><cr>

"Allow % to bounce between angles too
set matchpairs+=<:>
