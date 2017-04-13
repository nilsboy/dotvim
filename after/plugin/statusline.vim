" Avoid 'hit enter prompt'
set shortmess=atTIW

" don't give ins-completion-menu messages.
set shortmess+=c

" Increase ruler height
" set cmdheight=2

" always show status line
set laststatus=2

" always show tab page labels
set showtabline=2

" Prevent mode info messages on the last line to prevent 'hit enter prompt'
set noshowmode

" Always show ruler (right part of the command line)
" set ruler

" TODO using an echo in statusline removes old messages - maybe a way to
" suppress stuff?

" set statusline+=%#TabLineSel#
let &statusline .= ' '
set statusline+=%-39.40{Location()}
" set statusline+=%#TabLine#

set statusline+=%=

let &statusline .= ' | '

" Filetype
set statusline+=%{strlen(&filetype)?&filetype:''}

" Region filetype
set statusline+=%{exists(\"b:region_filetype\")?'/'.b:region_filetype.'\ ':''}

" File encoding
set statusline+=%{&enc=='utf-8'?'':&enc.'\ '}

" File format
set statusline+=%{&ff=='unix'?'':&ff.'\ '}

let &statusline .= ' | %3l,%-02c | %P '

function! Location() abort

    let l:fn = "/home/user/src/dotvim/vimrc"
    let l:fn = "/usr/share/vim/vim74/doc/change.txt"
    let l:fn = "/home/user/src/dotvim/plugin/BufferCloseSanely.vim"
    let l:fn = "/home/user/src/dotvim/after/plugin/Ack.vim"
    let l:fn = "/home/user/bashrc"
    let l:fn = expand("%:p")

    let l:prefix = ""
    let l:dirname = ""

    let l:fn = substitute(l:fn, "/home", "", "")

    let l:dirs = split(fnamemodify(l:fn, ":h"), "/")
    let l:basename = fnamemodify(l:fn,':t:h')

    if len(l:dirs) == 0
        let l:dirname= "~"
    elseif len(l:dirs) == 1
        let l:prefix = dirs[0]
    elseif len(l:dirs) == 2
        let l:prefix = dirs[0]
        let l:dirname = dirs[1]
    elseif len(l:dirs) > 2
        let l:prefix = dirs[2]
        if len(dirs) > 3
            let l:dirname = dirs[len(dirs) - 1]
        endif
    endif

    if l:dirname != ""
        let l:dirname .= "/"
    endif

    if l:prefix != ""
        let l:prefix .= ":"
    endif

    let l:fn = l:prefix . l:dirname . l:basename
    return l:fn

endfunction

