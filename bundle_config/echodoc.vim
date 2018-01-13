finish
" Print documents in echo area. 
NeoBundle 'Shougo/echodoc', '', 'default'
call neobundle#config('echodoc', {
      \ 'lazy' : 1,
      \ 'autoload' : {
      \ 'insert' : 1,
      \ }})

let g:echodoc_enable_at_startup = 1
