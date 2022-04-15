" Yoink will automatically maintain a history of yanks that you can choose between when pasting.
let g:yoinkIncludeDeleteOperations = 1

let g:yoinkSavePersistently = 1
set shada+=!

PackAdd svermeulen/vim-yoink

" TODO: interferes when pressing j or k right after?
" nmap p <plug>(YoinkPaste_p)
" nmap P <plug>(YoinkPaste_P) 

nmap [y <plug>(YoinkPostPasteSwapBack)
nmap ]y <plug>(YoinkPostPasteSwapForward)

" nmap [y <plug>(YoinkRotateBack)
" nmap ]y <plug>(YoinkRotateForward)

" Prefer xsel over xclip to avoid "Clipboard error : Target STRING not available"
" https://github.com/svermeulen/vim-yoink/issues/16#issuecomment-632234373
let g:clipboard = {
  \   'name': 'xsel_override',
  \   'copy': {
  \      '+': 'xsel --input --clipboard',
  \      '*': 'xsel --input --primary',
  \    },
  \   'paste': {
  \      '+': 'xsel --output --clipboard',
  \      '*': 'xsel --output --primary',
  \   },
  \   'cache_enabled': 1,
  \ }
