finish
" TODO: test - can make the insert leader fast?
inoremap <expr><silent> <space> Smartcomma()
function! Smartcomma() abort
    let [bufnum, lnum, col, off, curswant] = getcurpos()
    if getline('.') =~ (' \%' . (col+off) . 'c')
        return 'x'
        return "\<C-H>=> "
    else
        return ' '
    endif
endfunction

