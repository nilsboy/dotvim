finish
" See neomake instead
" Run Async Shell Commands in Vim 8.0 and Output to Quickfix Window
PackAdd skywind3000/asyncrun.vim

noremap <leader>qq :call asyncrun#quickfix_toggle(8)<cr>
