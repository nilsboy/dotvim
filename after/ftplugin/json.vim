
" npm install -g json2yaml

nnoremap <buffer> <silent> <leader>gc :silent call JsonToYaml()<cr>
function! JsonToYaml() abort
  silent wall
  silent !cat % | json2yaml > %:r.yaml
  silent edit %:r.yaml

  " Fix broken output
  :RemoveTrailingSpaces
  :RemoveNewlineBlocks

  " Sometimes returns with a root indentation
  if search('\v^---\n  \w+\:') != 0
    normal <ie
  endif
endfunction

" TODO: testing
" setlocal ft=swagger
