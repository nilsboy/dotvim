finish
" Database client for Vim.
PackAdd mattn/vdbi-vim, {
  \ 'depends' : 'mattn/webapi-vim',
  \ 'build': {
    \ 'unix': 'cpanm DBI Plack JSON',
  \ },
\ }

nnoremap ,sp :VDBIDatasources<cr>
