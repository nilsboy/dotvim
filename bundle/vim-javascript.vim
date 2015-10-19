" Vastly improved Javascript indentation and syntax support in Vim
NeoBundleLazy 'pangloss/vim-javascript', {'autoload':{'filetypes':['javascript']}}

let g:javascript_enable_domhtmlcss=1

" TODO fold set by default?
" b:javascript_fold=0

let g:javascript_conceal_function   = "ƒ"
let g:javascript_conceal_null       = "ø"
let g:javascript_conceal_this       = "@"
let g:javascript_conceal_return     = "⇚"
let g:javascript_conceal_undefined  = "¿"
let g:javascript_conceal_NaN        = "ℕ"
let g:javascript_conceal_prototype  = "¶"
let g:javascript_conceal_static     = "•"
let g:javascript_conceal_super      = "Ω"
