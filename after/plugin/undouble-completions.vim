finish
" When autocompleting within an identifier, prevent duplications
" Note: gets in the way - often removes unwanted stuff
augroup Undouble_Completions
    autocmd!
    autocmd CompleteDone *  call Undouble_Completions()
augroup None

function! Undouble_Completions ()
    let col  = getpos('.')[2]
    let line = getline('.')
    call setline('.', 
          \ substitute(line, '\(\k\+\)\%'.col.'c\zs\1', '', ''))
endfunction

