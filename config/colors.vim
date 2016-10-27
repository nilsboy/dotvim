" Show hightlight groups in their current colors
" :source $VIMRUNTIME/syntax/hitest.vim

" - RNB, a Vim colorscheme template
"   (https://gist.github.com/romainl/5cd2f4ec222805f49eca)

" Force 256 colors for terminals that call themselfs TERM=xterm
" set t_Co=256

" Prefer light version of a colorscheme
set background=light

" highlight the whole file not just the window - slower but more accurate.
autocmd BufEnter * :syntax sync fromstart

" Remove background set by colorscheme
" http://stackoverflow.com/questions/12449248
function! ColorschemeCleanup()
    hi Normal ctermbg=NONE guibg=NONE
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
autocmd ColorScheme * call ColorschemeCleanup()

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

" Show trailing whitespace as red
" highlight ExtraWhitespace ctermbg=darkred guibg=#382424
" autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
" autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
 
command! ColorsListCurrentHiGroups :so $VIMRUNTIME/syntax/hitest.vim

" Show syntax groups
nnoremap <leader>gs :echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')<cr>
