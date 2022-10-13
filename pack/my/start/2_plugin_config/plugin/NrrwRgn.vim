finish
" To focus on a selected region while making the rest inaccessible
" TAGS: narrow region shrink fenced code block
" SEE ALSO: ./pack/my/start/3_config/after/syntax/markdown/SyntaxInclude.vim
" DEPRECATED: using my_narrow now
PackAdd chrisbra/NrrwRgn

command! -nargs=* -bang -range -complete=filetype MyNrrwRgn
            \ :<line1>,<line2> call nrrwrgn#NrrwRgn('', '!')
            \ | set filetype=<args>

vnoremap <silent> <leader>nrr :MyNrrwRgn text<cr>

" NOTE: does not work
" vnoremap A :execute 'NN ' . &filetype<cr>

" Disable default mapping
xmap <NOP> <Plug>NrrwrgnDo
