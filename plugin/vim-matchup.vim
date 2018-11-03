finish
" even better % navigate and highlight
" NOTE: breaks status line
" NOTE: needs to be loaded before matchit plugin which neovim loads by default
" NOTE: does not work with javascript
PackAdd andymass/vim-matchup', { 'name': 'vim-matchup }

" does not work with neovim:
" if neobundle#tap('vim-matchup') 
"   function! neobundle#hooks.on_source(bundle) abort
"     let g:loaded_matchit = 0
"   endfunction
"   call neobundle#untap()
" endif
