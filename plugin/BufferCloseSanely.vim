" Close a buffer writing its content and closing vim if appropriate.
function! BufferClose()

    if BufferIsEmpty() == 1
    elseif BufferIsUnnamed() == 1
    elseif &modified
        :w
    endif

    if BufferIsLast() == 1
        :q!
    else
        :bdelete!
    endif

endfunction

function! BufferIsUnnamed()

    if empty(bufname("%"))
        return 1
    else
        return 2
    endif

endfunction

function! BufferIsEmpty()
    if line('$') == 1 && getline(1) == '' 
        return 1
    else
        return 0
    endif
endfunction

function! BufferIsLast()

    let last_buffer = bufnr('$')

    let listed = 0
    let i = 1
    while i <= last_buffer

        if buflisted(i) == 1
            let listed = listed + 1
        endif

        if listed > 1
            return 0
        endif

        let i = i + 1

    endwhile

    return 1

endfunction

nnoremap <silent> <ESC> :call BufferClose()<cr>
