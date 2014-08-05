let g:EasyMotion_leader_key = '<Leader>'
let g:EasyMotion_grouping = 1
" let EasyMotion_keys = "abcdefghijklmnopqrstuvwxyz0123456789"

let g:EasyMotion_use_upper = 1
" let g:EasyMotion_keys = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
let g:EasyMotion_keys='hjklöä#zuiopü+7890ßnm,.-gfdsatrewq654321bvcxyHJKLÖÄ#ZUIOPÜ7890ßNMGFDSATREWQ654321BVCXY'

let g:EasyMotion_enter_jump_first = 1
let g:EasyMotion_disable_two_key_combo = 0

let g:EasyMotion_do_shade = 1

" hi link EasyMotionTarget ErrorMsg
" hi link EasyMotionShade  Comment

hi link EasyMotionTarget ErrorMsg
hi link EasyMotionShade  Comment

hi link EasyMotionTarget2First ErrorMsg
hi link EasyMotionTarget2Second Comment
" hi link EasyMotionTarget2Second MatchParen

" todo xxx term=standout ctermfg=20 ctermbg=21 guifg=#875f00 guibg=#ffffaf

nmap w <Plug>(easymotion-w)
nmap W <Plug>(easymotion-W)

