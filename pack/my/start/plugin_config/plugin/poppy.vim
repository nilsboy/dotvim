finish
" vim port of highlightparentheses.el
PackAdd bounceme/poppy.vim
" NOTE: https://www.reddit.com/r/vim/comments/5rdxq3/looking_for_an_equivalent_of_emacs/
" TAGS: rainbow hightlight parentheses

autocmd! cursormoved * call PoppyInit() 
