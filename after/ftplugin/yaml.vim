" The default linter for neomake is:
" http://yamllint.readthedocs.io/en/latest/quickstart.html

" npm install -g js-yaml

nnoremap <buffer> <silent> <leader>gc :silent call MyYamlToJson()<cr>
function! MyYamlToJson() abort
  silent wall
  silent !js-yaml % > %:r.json
  silent edit %:r.json
endfunction

" TODO: testing
" setlocal ft=swagger
