" exclude colon
" setlocal iskeyword=1-57,59-255

setlocal suffixesadd=.js,.node,.json,.ts

let b:outline = '('
" let b:outline .= '^\w+.*\:|^  \w+.*\:|^\s+\/|^\s+(post|get|patch|delete|put)\:'
" let b:outline .= '^\w+.*\:$'
" let b:outline .= '|^    \S+.*\:$'
let b:outline .= '^\s{0,4}\S+.*\:(\s*\||)\s*$'
let b:outline .= '|^\S+.*:'
let b:outline .= '|^---$'
let b:outline .= ')'


let b:formatter = 'prettier-yaml'

if exists("b:MyYamlFtpluginLoaded")
    finish
endif
let b:MyYamlFtpluginLoaded = 1

MyInstall js-yaml
MyInstall prettier

function! MyYamlToJson() abort
  silent wall
  silent !js-yaml % > %:r.json
  silent edit %:r.json
endfunction
command! -nargs=* MyYamlToJson call MyYamlToJson ()

command! MyYamlSortKeys :silent wall | :silent %!yaml-sort-keys %
