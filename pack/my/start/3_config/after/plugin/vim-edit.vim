if exists("vimedit#ftpluginLoaded")
  finish
endif
let vimedit#ftpluginLoaded = 1

augroup vim-edit#augroup
  autocmd!
  autocmd BufRead,BufNewFile /tmp/*vim-edit.txt :set nohlsearch
  autocmd BufRead,BufNewFile /tmp/*vim-edit.txt :nnoremap <buffer> <esc> :x<cr>
augroup END
