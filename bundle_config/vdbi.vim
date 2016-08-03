finish
" Database client for Vim.
NeoBundle 'mattn/vdbi-vim', {
  \ 'depends' : 'mattn/webapi-vim',
  \ 'build': {
    \ 'unix': 'cpanm DBI Plack JSON',
  \ },
\ }

nnoremap ,sp :VDBIDatasources<cr>
