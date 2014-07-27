
function! IsBufferEmpty()
    if line('$') == 1 && getline(1) == ''
        return 1
    else
        return 0
    endif
endfunction

if IsBufferEmpty()
    " exe "normal :MRU<CR>"
endif
