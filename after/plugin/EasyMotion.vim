" nmap x <Plug>(easymotion-prefix)

let g:EasyMotion_grouping = 1

let g:EasyMotion_use_upper = 1

let g:EasyMotion_keys=''

" right hand
let g:EasyMotion_keys.='HJKLUIOPNM'

let g:EasyMotion_keys.='7890'

" left hand
" let g:EasyMotion_keys.='GFDSATREWQBVCXY'

let g:EasyMotion_enter_jump_first = 1
let g:EasyMotion_disable_two_key_combo = 0

let g:EasyMotion_do_shade = 1

let g:EasyMotion_force_csapprox = 1

hi link EasyMotionTarget ErrorMsg
hi link EasyMotionShade  Comment

hi link EasyMotionTarget2First ErrorMsg
hi link EasyMotionTarget2Second MoreMsg

" hi EasyMotionTarget ctermbg=none ctermfg=green
" hi EasyMotionShade  ctermbg=none ctermfg=blue
" 
" hi EasyMotionTarget2First ctermbg=none ctermfg=red
" hi EasyMotionTarget2Second ctermbg=none ctermfg=red

"  nmap w <Plug>(easymotion-w)
" nmap W <Plug>(easymotion-W)
nmap <leader><space> <Plug>(easymotion-jumptoanywhere)

let g:EasyMotion_re_anywhere=''

" Unescaped non ASCII chars are operators
let g:EasyMotion_re_anywhere.='\v'

" Beginning of word
let g:EasyMotion_re_anywhere.='(<.|^$)|'

" End of word
" let g:EasyMotion_re_anywhere.='(.>|^$)|'

" Camelcase
let g:EasyMotion_re_anywhere.='(\l)\zs(\u)|'

" After '_'
let g:EasyMotion_re_anywhere.='(_\zs.)|'

" After '#'
let g:EasyMotion_re_anywhere.='(#\zs.)|'

" After '::'
let g:EasyMotion_re_anywhere.='(::\zs.)'

" " 3 letter words
" " let g:EasyMotion_re_anywhere='\v(_|\s)\zs([0-9A-Za-z]{3,})'
" 
" " let g:EasyMotion_re_anywhere='\v\s(\{|\})'
" "
" " let g:EasyMotion_re_anywhere='\v'
