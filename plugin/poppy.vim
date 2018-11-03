finish
" vim port of highlightparentheses.el
PackAdd bounceme/poppy.vim
" NOTE: https://www.reddit.com/r/vim/comments/5rdxq3/looking_for_an_equivalent_of_emacs/
" TAGS: rainbow hightlight parentheses

if neobundle#tap('poppy.vim') 
  function! neobundle#hooks.on_post_source(bundle) abort
    autocmd! cursormoved * call PoppyInit() 
  endfunction
  call neobundle#untap()
endif

