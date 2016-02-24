if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1

map <buffer> <silent> <Leader>w :call PerlTidy()<CR><CR>

" :au CursorHold <buffer>  echo 'hold'
" augroup perl_tidy
"     autocmd!
"     autocmd InsertLeave <buffer>
"                 \ call PerlTidy()
" augroup END

compiler perl

nnoremap <buffer> <silent> <Enter> :verbose :call PerlModuleCreate()<cr><cr>

" :echo substitute('ha->ha', '\v([\w\:]+)', '\1', 'g')

" runtime! ftplugin/sh.vim
" setlocal keywordprg=!perldoc .expand
nnoremap <buffer> <silent> K :call Man(expand("<cword>"))<cr><cr>

"Allow % to bounce between angles too
setlocal matchpairs+=<:>

let &makeprg="perl -c %"
" let g:perl_compiler_force_warnings = 0

let g:syntastic_perl_perlcritic_post_args = '--exclude=strict'
setlocal errorformat+=\ %m\ at\ %f\ line\ %l
