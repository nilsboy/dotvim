" A plugin for asynchronous :make using Neovim's job-control functionality
NeoBundle 'neomake/neomake'
" TODO: checkout neomake-vim-autoformat.vim
" TODO: see statusline support from neomake
" Note: Does not support stdin:
" https://github.com/neomake/neomake/issues/190

" let g:neomake_verbose = 3
call delete('/tmp/neomake.log')
let g:neomake_logfile = '/tmp/neomake.log'

let g:neomake_serialize = 1
let g:neomake_echo_current_error = 0

" TODO: disable for linting?
let g:neomake_open_list = 0

let g:neomake_highlight_columns = 1
" let g:neomake_highlight_lines = 1

augroup My_neomake_config_augroup_onNeomakeFinished
  autocmd!
  autocmd User NeomakeFinished call My_neomake_config_onNeomakeFinished()
augroup END

function! My_neomake_config_onNeomakeFinished() abort
  if g:neomake_hook_context.jobinfo.file_mode == 1
    call My_quickfix_setNavigationType('locationlist')
    lopen
  else
    call My_quickfix_setNavigationType('quickfix')
    copen
  endif
endfunction

nnoremap <silent><leader>ee :Neomake! run<cr>
nnoremap <silent><leader>el :Neomake lint<cr>
nnoremap <silent><leader>ef :Neomake format<cr>

nnoremap <silent><leader>ed :edit /tmp/neomake.log <cr>

nnoremap <silent><leader>eh :Verbose call My_neomake_config_make_infos()<cr>
function! My_neomake_config_make_infos() abort
  echo '&makeprg: ' . &makeprg
  echo '&errorformat: ' . &errorformat
  echo 'g:neomake_' . &filetype . '_run_maker: '
  execute 'echo g:neomake_' . &filetype . '_run_maker'
endfunction
