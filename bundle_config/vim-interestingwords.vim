finish
" highlight and navigate through (multiple) different words in a buffer 
NeoBundle 'lfv89/vim-interestingwords' 
" TAGS: search highlight

nnoremap <silent> //k :call InterestingWords('n')<cr>
nnoremap <silent> //K :call UncolorAllWords()<cr>

nnoremap <silent> n :call WordNavigation('forward')<cr>
nnoremap <silent> N :call WordNavigation('backward')<cr>
