" A plugin for asynchronous :make using Neovim's job-control functionality
NeoBundle 'neomake/neomake'
" TODO: checkout neomake-vim-autoformat.vim
" Note: focus problem - does not exist in neomake commit 69e080b

" let g:neomake_verbose = 3
call delete('/tmp/neomake.log')
let g:neomake_logfile = '/tmp/neomake.log'

let g:neomake_serialize = 1

" let g:neomake_echo_current_error = 0

" Does not have stdin support:
" https://github.com/neomake/neomake/issues/190

" TODO: disable for linting?
let g:neomake_open_list = 1

" TODO: highlight lines differently than columns
let g:neomake_highlight_columns = 1
" let g:neomake_highlight_lines = 1

    " augroup my_neomake_highlights
    "     au!
    "     autocmd ColorScheme *
    "       \ hi link NeomakeError SpellBad
    "       \ hi link NeomakeWarning SpellCap
    " augroup END

" TODO: statusline
" set statusline+=\ %#ErrorMsg#%{neomake#statusline#QflistStatus('qf:\ ',\ 0)}
" *neomake#statusline#LoclistStatus*

" let g:neomake_error_sign = {
"     \ 'text': '=>',
"     \ 'texthl': 'ErrorMsg',
"     \ }

" neomake#statusline#LoclistCounts

" augroup augroup_neomake
"   autocmd!
"   autocmd User NeomakeFinished call OnNeomakeFinished()
" augroup END

" function! OnNeomakeFinished() abort
"     if g:neomake_hook_context.file_mode == 1
"         call nilsboy_quickfix#setNavigationType('locationlist')
"       else
"         call nilsboy_quickfix#setNavigationType('quickfix')
"     endif
" endfunction

nnoremap <silent><leader>ee :Neomake run<cr>
nnoremap <silent><leader>el :Neomake lint<cr>
nnoremap <silent><leader>ef :Neomake format<cr>

nnoremap <silent><leader>ed :edit /tmp/neomake.log <cr>

nnoremap <silent><leader>eh :Verbose call Neomake_make_infos()<cr>
function! Neomake_make_infos() abort
  echo '&makeprg: ' . &makeprg
  echo '&errorformat: ' . &errorformat
  echo 'g:neomake_' . &filetype . '_run_maker: '
  execute 'echo g:neomake_' . &filetype . '_run_maker'
endfunction
