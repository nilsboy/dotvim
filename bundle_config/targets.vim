" Provides additional text objects
NeoBundle 'wellle/targets.vim' 
" TAGS: textobj motion

let g:targets_pairs = '()b {}B [] <>'
let g:targets_quotes = '"d ''q `'

" Never seek backwards:
let g:targets_seekRanges = 'cr cb cB lc ac Ac lr rr lb ar ab lB Ar aB Ab AB rb rB bb bB BB'
