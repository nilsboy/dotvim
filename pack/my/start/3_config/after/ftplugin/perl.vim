compiler perl

" setlocal keywordprg=!perldoc .expand
nnoremap <buffer> <silent> K :call Man(expand("<cword>"))<cr><cr>

"Allow % to bounce between angles too
setlocal matchpairs+=<:>

setlocal makeprg=perl\ -c\ %
" let g:perl_compiler_force_warnings = 0

setlocal errorformat+=\ %m\ at\ %f\ line\ %l

let b:outline = '^\s*sub'
let b:formatter = 'perltidy'

if exists("b:did_ftplugin_perl")
  finish
endif
let b:did_ftplugin_perl = 1

MyInstall perltidy pkexec apt install perltidy
