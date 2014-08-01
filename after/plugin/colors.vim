" show colors
" :so $VIMRUNTIME/syntax/hitest.vim

set background=light

" highlight the whole file not just the window - slower but more accurate.
autocmd BufEnter * :syntax sync fromstart

function! ColorschemeCleanup()

    " convert colors down to 256
    " :CSApprox!

    " Remove background set by colorscheme
    " http://stackoverflow.com/questions/12449248
    hi Normal ctermbg=NONE
    " hi Comment ctermbg=NONE
    " hi Constant ctermbg=NONE
    " hi Special ctermbg=NONE
    " hi Identifier ctermbg=NONE
    " hi Statement ctermbg=NONE
    " hi PreProc ctermbg=NONE
    " hi Type ctermbg=NONE
    " hi Underlined ctermbg=NONE
    " hi Todo ctermbg=NONE
    " hi String ctermbg=NONE
    " hi Function ctermbg=NONE
    " hi Conditional ctermbg=NONE
    " hi Repeat ctermbg=NONE
    " hi Operator ctermbg=NONE
    " hi Structure ctermbg=NONE
endfunction
autocmd ColorScheme * exec ColorschemeCleanup()

" let g:csexact_blacklist = 'solarized'

try
    colorscheme lucius
catch /find/
    " nothing
endtry

if &t_Co > 1
    syntax enable
endif

autocmd CursorMoved * exe printf('match todo /\V\<%s\>/', 
    \ escape(expand('<cword>'), '/\'))

