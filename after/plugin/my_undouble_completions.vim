finish " #######################################################################
" When autocompleting within an identifier, prevent duplications
" Note: gets in the way - often removes unwanted stuff

augroup MyUndoubleCompletions
    autocmd!
    autocmd CompleteDone *  call MyUndoubleCompletions()
augroup None

function! MyUndoubleCompletions()
    let col  = getpos('.')[2]
    let line = getline('.')
    call setline('.', 
          \ substitute(line, '\(\k\+\)\%'.col.'c\zs\1', '', ''))
endfunction

