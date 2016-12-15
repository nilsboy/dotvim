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
    hi Normal ctermbg=NONE

    hi StatusLine   ctermbg=249 ctermfg=240 cterm=NONE
    hi StatusLineNC ctermbg=249 ctermfg=240 cterm=NONE

    hi TabLine      ctermbg=249 ctermfg=240 cterm=NONE
    hi TabLineFill  ctermbg=249 ctermfg=240 cterm=NONE
    hi TabLineSel   ctermfg=238 ctermbg=153 cterm=NONE

    hi CursorLine   ctermbg=254 ctermfg=NONE
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
autocmd CursorMoved * execute printf('match todo /\V\<%s\>/',
    \ escape(expand('<cword>'), '/\'))

" Show trailing whitespace as red
" highlight ExtraWhitespace ctermbg=darkred guibg=#382424
" autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
" autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
 
command! ColorsListCurrentHiGroups :so $VIMRUNTIME/syntax/hitest.vim

" Show syntax groups
nnoremap <leader>gh :echo map(synstack(line('.'), col('.')), 
      \ 'synIDattr(v:val, "name")')<cr>

"### Cursor

autocmd InsertLeave,WinEnter,BufEnter * setlocal cursorline
autocmd InsertEnter * setlocal nocursorline

" Disable all blinking
set guicursor+=a:blinkon0
