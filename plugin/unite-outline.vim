
" nnoremap <leader>o :<C-u>Unite           -buffer-name=outline -start-insert outline<cr>
nnoremap <leader>o :<C-u>Unite           -buffer-name=outline outline<cr>

" let g:unite_source_outline_filetype_options = {
"       \ '*': {
"       \   'auto_update': 1,
"       \   'auto_update_event': 'write',
"       \ },
"       \ 'cpp': {
"       \   'auto_update': 0,
"       \ },
"       \ 'javascript': {
"       \   'ignore_types': ['comment'],
"       \ },
"       \ 'markdown': {
"       \   'auto_update_event': 'hold',
"       \ },
" \}
" 
" let g:unite_source_outline_info.ruby = {
"       \ 'heading': '^\s*\(module\|class\|def\)\>',
"       \ 'skip': {
"       \   'header': '^#',
"       \   'block' : ['^=begin', '^=end'],
"       \ },
" \}
