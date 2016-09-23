compiler perl

nnoremap <buffer> <silent> <Leader>x :call PerlTidy()<CR><CR>
nnoremap <buffer> <silent> <Enter> :verbose :call PerlModuleCreate()<cr><cr>

" runtime! ftplugin/sh.vim
" setlocal keywordprg=!perldoc .expand
nnoremap <buffer> <silent> K :call Man(expand("<cword>"))<cr><cr>

"Allow % to bounce between angles too
setlocal matchpairs+=<:>

setlocal makeprg=perl\ -c\ %
" let g:perl_compiler_force_warnings = 0

setlocal errorformat+=\ %m\ at\ %f\ line\ %l

if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1

let g:syntastic_perl_perlcritic_post_args = '--exclude=strict'

" :au CursorHold <buffer>  echo 'hold'
" augroup perl_tidy
"     autocmd!
"     autocmd InsertLeave <buffer>
"                 \ call PerlTidy()
" augroup END

