" A plugin for asynchronous :make using Neovim's job-control functionality
NeoBundle 'neomake/neomake'
" TODO: checkout neomake-vim-autoformat.vim
" TODO: see statusline support from neomake
" Note: Does not support stdin:
" https://github.com/neomake/neomake/issues/190

" let g:neomake_verbose = 3
" call delete('/tmp/neomake.log')
" let g:neomake_logfile = '/tmp/neomake.log'

let g:neomake_ft_maker_remove_invalid_entries = 0

" TODO: change for speedup? / screws with separator between file search and
" let g:neomake_serialize = 1
let g:neomake_echo_current_error = 1

" TODO: disable for linting?
let g:neomake_open_list = 0

let g:neomake_highlight_columns = 1
" let g:neomake_highlight_lines = 1

augroup MyNeomakeConfigAugroupOnNeomakeFinished
  autocmd!
  autocmd User NeomakeFinished copen
augroup END

" nnoremap <silent><leader>ee :silent wall \| Neomake! run<cr>
nnoremap <silent><leader>ee ma:call MyNeomakeConfigRun()<cr>
nnoremap <silent><leader>el :silent wall \| Neomake lint<cr>
nnoremap <silent><leader>ef :silent wall \| Neomake format<cr>

function! MyNeomakeConfigRun() abort
  let logLevel = $LOG_LEVEL
  " for log-dwim
  let $LOG_LEVEL = 'TRACE'
  silent wall
  silent! `a
  Neomake! run
  let $LOG_LEVEL = logLevel
endfunction

nnoremap <silent><leader>ed :edit /tmp/neomake.log <cr>

nnoremap <silent><leader>eh :Verbose call MyNeomakeConfigInfos()<cr>
function! MyNeomakeConfigInfos() abort
  echo '&makeprg: ' . &makeprg
  echo '&errorformat: ' . &errorformat
  echo 'g:neomake_' . &filetype . '_run_maker: '
  execute 'echo g:neomake_' . &filetype . '_run_maker'
endfunction
