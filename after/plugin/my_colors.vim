" - RNB, a Vim colorscheme template
"   (https://gist.github.com/romainl/5cd2f4ec222805f49eca)

" NOTE: https://github.com/atelierbram/syntax-highlighting

" syntax has to be enabled before using it
if &t_Co > 1
  if !exists('g:syntax_on')
      syntax enable
  endif
endif


" Show when lines extend past column 80
" set colorcolumn=81
" highlight ColorColumn ctermfg=red ctermbg=NONE

" Disable all blinking
" set guicursor+=a:blinkon0

" Prefer light version of a colorscheme
set background=light

set cursorline

function! MyColorsColorschemeCleanup() abort
  highlight Normal ctermbg=NONE
  highlight SignColumn ctermbg=254

  highlight TabLine      ctermbg=249 ctermfg=240 cterm=NONE
  highlight TabLineFill  ctermbg=249 ctermfg=240 cterm=NONE
  highlight TabLineSel   ctermfg=238 ctermbg=153 cterm=NONE

  highlight CursorLine   ctermbg=254 ctermfg=NONE

  highlight StatusLine   ctermbg=249 ctermfg=240 cterm=NONE
  highlight StatusLineNC ctermbg=249 ctermfg=240 cterm=NONE

  " Make diffs less glaringly ugly...
  highlight DiffAdd     cterm=bold ctermfg=green     ctermbg=black
  highlight DiffChange  cterm=bold ctermfg=grey      ctermbg=black
  highlight DiffDelete  cterm=bold ctermfg=black     ctermbg=black
  highlight DiffText cterm=bold ctermfg=magenta ctermbg=black

  " see also: :help lcs-trail
  " highlight MyExtraWhitespace ctermbg=darkred
  " syntax match MyExtraWhitespace /\s\+$\| \+\ze\t/ containedin=ALL

  " TODO: makes vim help look awful
  " highlight MyTabstops ctermbg=darkred
  " syntax match MyTabstops /\t/

  highlight MyLongLines ctermfg=darkred
  " TODO: messes with vimdoc
  " execute 'syntax match MyLongLines /\%>' . &textwidth . 'v.\+/ containedin=ALL'
endfunction
augroup MyColorsAugroupColorschemeCleanup
  autocmd!
  autocmd ColorScheme,Syntax * call MyColorsColorschemeCleanup()
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

" " highlight the whole file not just the window - slower but more accurate.
" no augroup MyColorsAugroupHighlightWholeBuffer
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

" ### LAST ####################################################################

" load colorscheme last to ensure own settings have priority
try
    colorscheme lucius
catch /find/
    " nothing
endtry
