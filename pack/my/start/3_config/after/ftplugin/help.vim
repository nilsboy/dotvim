" These options only seem to work for the :help command
" but not for the k-mapping
setlocal buflisted
" only

let &l:define = '\v^(\S.+\ *~$|\*[\d+\.]{2,}\*\s+\w+)'
let b:outline = '^\d+\.'

