" Show hightlight groups in their current colors
" :so $VIMRUNTIME/syntax/hitest.vim

" Prefer light version of a colorscheme
set background=light

" highlight the whole file not just the window - slower but more accurate.
autocmd BufEnter * :syntax sync fromstart

" Remove background set by colorscheme
" http://stackoverflow.com/questions/12449248
function! ColorschemeCleanup()

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

try
    colorscheme lucius
catch /find/
    " nothing
endtry

if &t_Co > 1
    syntax enable
endif

" Highlight all occurences of word under cursor
autocmd CursorMoved * exe printf('match todo /\V\<%s\>/', 
    \ escape(expand('<cword>'), '/\'))

" Prevent CSExact from resetting the colors to the normal palette to avoid
" disturbing other vims in the same terminal window (when using tmux etc)
" This overwrites CSExacts reset function with a dummy function.
command! -bar CSExactResetColors echo "Avoiding CSExact reset"
