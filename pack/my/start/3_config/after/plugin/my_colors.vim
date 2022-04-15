" :so $VIMRUNTIME/syntax/hitest.vim

if &t_Co <= 1
  finish
endif

set termguicolors

set background=light
" don't highlight long lines completely - for performance
" for some reason <=65 keeps if fast
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

function! MyColorsColorschemeCleanup() abort
  highlight Normal ctermbg=NONE guibg=NONE gui=NONE
  " highlight MyExtraWhitespace ctermbg=darkred
  " syntax match MyExtraWhitespace /\s\+$\| \+\ze\t/ containedin=ALL
  " highlight MyColorsEolColor ctermbg=red

  " match Todo /\v\ctodo|tbd|note/
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

augroup MyColorsAugroupCursorline
  autocmd!
  autocmd WinLeave * setlocal cursorline
  autocmd WinEnter * setlocal nocursorline
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

" syntax enable

" load colorscheme last to ensure own settings have priority
colorscheme my_colors
