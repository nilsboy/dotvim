" call unite#custom#source('outline', 'converters', ['converter_default'])
" call unite#custom#source('outline', 'sorters', ['sorter_word'])

nnoremap <silent> <Leader>o :<C-u>Unite
            \ -buffer-name=outline
            \ -keep-focus
            \ -immediately
            \ -start-insert
            \ -silent
            \ outline<cr>

let g:unite_source_outline_filetype_options = {
      \ '*': {
      \   'auto_update': 1,
      \   'auto_update_event': 'hold',
      \ },
      \ 'java': {
      \   'ignore_types': ['package'],
      \ },
      \ 'perl': {
      \   'ignore_types': ['package'],
      \ },
      \}
