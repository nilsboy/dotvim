" syntax has to be enabled before using it
if &t_Co > 1
  if !exists('g:syntax_on')
    syntax enable
  endif
endif

set synmaxcol=200

" Prefer light version of a colorscheme
set background=light

" augroup MyColorsAugroupTrailingWhitespace
"   autocmd!
"   autocmd InsertEnter * syn clear MyColorsEolColor
"         \ | syn match MyColorsEolColor excludenl /\s\+\%#\@!$/
"   autocmd InsertLeave * syn clear MyColorsEolColor
"         \ | syn match MyColorsEolColor excludenl /\s\+$/
" augroup END

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

  " highlight MyExtraWhitespace ctermbg=darkred
  " syntax match MyExtraWhitespace /\s\+$\| \+\ze\t/ containedin=ALL

  highlight clear Folded
  highlight Folded ctermfg=249
  highlight FoldColumn cterm=NONE ctermbg=NONE

  highlight MyColorsEolColor ctermbg=red
endfunction
augroup MyColorsAugroupColorschemeCleanup
  autocmd!
  autocmd ColorScheme,Syntax,FileType * call MyColorsColorschemeCleanup()
augroup END

augroup MyColorsAugroupCursorline
  autocmd!
  autocmd InsertLeave,WinEnter,BufEnter,FocusGained * setlocal cursorline
  autocmd InsertEnter,FocusLost,BufLeave * setlocal nocursorline
  " Neomake does not seem to send the BufEnter event:
  autocmd Filetype qf set cursorline
augroup END

" highlight the whole file not just the window - slower but more accurate.
augroup MyColorsAugroupHighlightWholeBuffer
  autocmd!
  autocmd BufEnter * :syntax sync fromstart
augroup END

function! MyColorsShowSyntaxGroups() abort
  echo map(synstack(line('.'), col('.')),
        \ 'synIDattr(v:val, "name")')
endfunction
nnoremap <leader>gs :call MyColorsShowSyntaxGroups()<cr>
command! -nargs=* MyColorsShowSyntaxGroups
      \ call MyColorsShowSyntaxGroups (<f-args>)

command! MyColorsShowCurrentColors :source $VIMRUNTIME/syntax/hitest.vim

augroup MyVimrcAugroupFallbackToTexthighlight
  autocmd!
  autocmd! BufAdd * if &syntax == '' | setlocal syntax=txt | endif
augroup END

" load colorscheme last to ensure own settings have priority
try
  colorscheme lucius
catch /find/
  " nothing
endtry
