" The default linter for neomake is:
" http://yamllint.readthedocs.io/en/latest/quickstart.html

nnoremap <buffer> <silent> <leader>gc :silent call MyYamlToJson()<cr>

if exists("b:MyYamlFtpluginLoaded")
    finish
endif
let b:MyYamlFtpluginLoaded = 1

MyInstall js-yaml

function! MyYamlToJson() abort
  silent wall
  silent !js-yaml % > %:r.json
  silent edit %:r.json
endfunction

" TODO: testing
" setlocal ft=swagger
