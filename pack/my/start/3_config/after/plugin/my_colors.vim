" :so $VIMRUNTIME/syntax/hitest.vim

set termguicolors

set background=light
set synmaxcol=200

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

match Todo /\ctodo|\ctbd/

function! MyColorsColorschemeCleanup() abort
  highlight Normal ctermbg=NONE guibg=NONE gui=NONE
  " highlight MyExtraWhitespace ctermbg=darkred
  " syntax match MyExtraWhitespace /\s\+$\| \+\ze\t/ containedin=ALL
  " highlight MyColorsEolColor ctermbg=red
endfunction
augroup MyColorsAugroupColorschemeCleanup
  autocmd!
  autocmd ColorScheme,Syntax,FileType * call MyColorsColorschemeCleanup()
augroup END

" augroup MyColorsAugroupCursorline
"   autocmd!
"   autocmd InsertLeave,WinEnter,BufEnter,FocusGained * setlocal cursorline
"   autocmd InsertEnter,FocusLost,BufLeave * setlocal nocursorline
" augroup END

" highlight the whole file not just the window - slower but more accurate.
augroup MyColorsAugroupHighlightWholeBuffer
  autocmd!
  autocmd BufEnter * :if &syn | syntax sync fromstart | endif
augroup END

function! MyColorsShowSyntaxGroups() abort
	echo map(synstack(line('.'), col('.')),
    \ 'synIDattr(v:val, "name")')
endfunction
nnoremap <leader>vS :call MyColorsShowSyntaxGroups()<cr>
command! -nargs=* MyColorsShowSyntaxGroups
    \ call MyColorsShowSyntaxGroups (<f-args>)

command! MyColorsShowCurrentColors :source $VIMRUNTIME/syntax/hitest.vim

augroup MyVimrcAugroupFallbackToTexthighlight
  autocmd!
  autocmd! BufEnter * if &syntax == '' | setlocal syntax=txt | endif
augroup END

if &t_Co > 1
  " if !exists('g:syntax_on')
    syntax enable
  " endif
endif

" load colorscheme last to ensure own settings have priority
colorscheme mine
