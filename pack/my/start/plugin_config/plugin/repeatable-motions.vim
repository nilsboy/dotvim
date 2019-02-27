finish
" Make most motions repeatable
" NOTE: mapps f/F etc by default.
PackAdd vim-scripts/repeatable-motions.vim

map <Up> <Plug>RepeatMotionUp
map <Down> <Plug>RepeatMotionDown
map <Right> <Plug>RepeatMotionRight
map <Left> <Plug>RepeatMotionLeft

" if neobundle#tap('repeatable-motions.vim') 
"   function! neobundle#hooks.on_post_source(bundle) abort
"     call INFO('### HERE11 repeatable-motions.vim:11 ' . strftime("%F %T"))
"     call RemoveRepeatableMotion("f")
"   endfunction
"   call neobundle#untap()
" endif

