finish
" Make most motions repeatable
" NOTE: mapps f/F etc by default.
PackAdd vim-scripts/repeatable-motions.vim

map <Up> <Plug>RepeatMotionUp
map <Down> <Plug>RepeatMotionDown
map <Right> <Plug>RepeatMotionRight
map <Left> <Plug>RepeatMotionLeft

"  call RemoveRepeatableMotion("f")
