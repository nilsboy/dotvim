" syntax has to be enabled before using it
if &t_Co > 1
  if !exists('g:syntax_on')
      syntax enable
  endif
endif

" Disable all blinking
" set guicursor+=a:blinkon0

" Prefer light version of a colorscheme
set background=light

" Show arrows for too long lines / show trailing spaces
" set list
" set listchars=tab:>\ ,trail:.,precedes:<,extends:>,conceal:Δ,nbsp:%
" set listchars=trail:.,precedes:<,extends:>,conceal:Δ,nbsp:%
" set conceallevel=1

" Mark one char after max line width
" call matchadd('Todo',  '\%81v', 100)
" Show when lines extend past column 80
" set colorcolumn=81
" highlight ColorColumn ctermfg=red ctermbg=NONE

match Todo /TODO/

function! MyColorsColorschemeCleanup() abort
  highlight Normal ctermbg=NONE
  highlight SignColumn ctermbg=254

  highlight TabLine      ctermbg=249 ctermfg=240 cterm=NONE
  highlight TabLineFill  ctermbg=249 ctermfg=240 cterm=NONE
  highlight TabLineSel   ctermfg=238 ctermbg=153 cterm=NONE

  highlight CursorLine   ctermbg=254 ctermfg=NONE

  highlight StatusLine   ctermbg=249 ctermfg=240 cterm=NONE
  highlight StatusLineNC ctermbg=249 ctermfg=240 cterm=NONE

  " see also: :help lcs-trail
  " highlight MyExtraWhitespace ctermbg=darkred
  " syntax match MyExtraWhitespace /\s\+$\| \+\ze\t/ containedin=ALL

  highlight MyColorsEolColor ctermbg=red
endfunction
augroup MyColorsAugroupColorschemeCleanup
  autocmd!
  autocmd ColorScheme,Syntax,FileType * call MyColorsColorschemeCleanup()
augroup END

" " Highlight all occurences of word under cursor
" augroup MyColorsAugroupHighlightWordUnderCursor
"   autocmd!
"   autocmd CursorMoved,CursorMovedI * execute printf('match todo /\V\<%s\>/',
"     \ escape(expand('<cword>'), '/\'))
" augroup END

augroup MyColorsAugroupCursorline
  autocmd!
  autocmd InsertLeave,WinEnter,BufEnter * setlocal cursorline
  autocmd InsertEnter * setlocal nocursorline
augroup END

" highlight the whole file not just the window - slower but more accurate.
" augroup MyColorsAugroupHighlightWholeBuffer
"   autocmd!
"   autocmd BufEnter * :syntax sync fromstart
" augroup END

function! MyColorsShowSyntaxGroups(...) abort
  echo map(synstack(line('.'), col('.')),
    \ 'synIDattr(v:val, "name")')
endfunction
nnoremap <leader>gs :call MyColorsShowSyntaxGroups()<cr>
command! -nargs=* MyColorsShowSyntaxGroups
      \ call MyColorsShowSyntaxGroups (<f-args>)

command! MyColorsShowCurrentColors :so $VIMRUNTIME/syntax/hitest.vim

augroup MyVimrcAugroupFallbackToTexthighlight
  autocmd!
  autocmd! BufAdd * if &syntax == '' | setlocal syntax=txt | endif
augroup END

" NOTE: causes missing header in quickfix?
" augroup MyColorsAugroupEndOfLineWhitespace
"   autocmd!
"   autocmd InsertEnter * syn clear MyColorsEolColor
"         \ | syn match MyColorsEolColor excludenl /\s\+\%#\@!$/
"   autocmd InsertLeave * syn clear MyColorsEolColor
"         \ | syn match MyColorsEolColor excludenl /\s\+$/
" augroup END

" load colorscheme last to ensure own settings have priority
try
    colorscheme lucius
catch /find/
    " nothing
endtry
