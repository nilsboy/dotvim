" A plugin for asynchronous :make using Neovim's job-control functionality
NeoBundle 'neomake/neomake'
" TODO: checkout neomake-vim-autoformat.vim
" Note: focus problem - does not exist in neomake commit 69e080b

" let g:neomake_verbose = 3
" Does not have stdin support:
" https://github.com/neomake/neomake/issues/190

let g:neomake_open_list = 2

let g:neomake_error_sign = {
    \ 'text': '=>',
    \ 'texthl': 'ErrorMsg',
    \ }

" neomake#statusline#LoclistCounts

augroup augroup_neomake
  autocmd!
  autocmd User NeomakeFinished call OnNeomakeFinished()
augroup END

function! OnNeomakeFinished() abort
    if g:neomake_hook_context.file_mode == 1
        call nilsboy_quickfix#setNavigationType('locationlist')
      else
        call nilsboy_quickfix#setNavigationType('quickfix')
    endif
endfunction
