finish
" Highlights and sets error markers for lines with compile errors

let errormarker_errorgroup = "ErrorMsg"
let errormarker_warninggroup = "WarningMsg"
let errormarker_infogroup = "MoreMsg"

let errormarker_disablemappings = 1

PackAdd nilsboy/errormarker.vim

let g:MySetErrorMarkersPrivate = nb#getScriptFunction('errormarker.vim/plugin/errormarker.vim', 'SetErrorMarkers')

function! MySetErrorMarkers() abort
  " Prevent duplicate signs - makes quickfix slow.
  RemoveErrorMarkers
  call g:MySetErrorMarkersPrivate()
endfunction

augroup errormarker
  autocmd!
  " autocmd QuickFixCmdPost * call MySetErrorMarkers()
augroup END
