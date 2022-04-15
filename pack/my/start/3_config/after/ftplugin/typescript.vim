runtime! after/ftplugin/javascript.vim

let b:myrunprg = 'ts-node'
let b:tester = 'jest'


let b:outline = '('
let b:outline .= '.*jj.*'
let b:outline .= '|^\s*interface\s+\w+'
let b:outline .= '|^\s*declare\s+\w+'
let b:outline .= '|^\s*(async)*\s*function\s+\w+'
let b:outline .= ')'

