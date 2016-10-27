" deoplete.nvim source for javascript
" can also be used with tern_for_vim plugin
NeoBundle 'carlitux/deoplete-ternjs', { 'build': { 'unix': 'npm install -g tern' }}

" Use deoplete.
let g:tern_request_timeout = 1
" This do disable full signature type on autocomplete
let g:tern_show_signature_in_pum = '0'

