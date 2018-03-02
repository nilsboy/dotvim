" A light and configurable statusline/tabline
NeoBundle 'itchyny/lightline.vim'

let g:lightline = {
      \   'colorscheme': 'mylightline',
      \   'inactive': { 'left': [[]] , 'right': [[]] },
      \   'active': {
      \     'left': [['paste', 'readonly'], 
      \       ['project'] , ['dir'],  ['filename']],
      \     'right': [['percentwin'], ['lineinfo'], ['fileformat', 'fileencoding', 'filetype']]
      \   },
      \   'tabline': {
      \     'left': [['bufferline']],
		  \     'right': [[]],
      \   },
      \   'component_expand': {
      \     'bufferline': 'MyLightlineBufferline',
      \   },
      \   'component_type': {
      \     'bufferline': 'tabsel',
      \   },
      \   'component': {
      \     'location': '%{MyStatuslineLocation()}',
      \     'shortendLocation': '%{pathshorten(expand("%:p"))}',
      \     'project': '%{fnamemodify(FindRootDirectory(), ":t")}',
      \     'dir': '%{MyLightlineDir()}',
      \     'filetype': '%{&ft!=#""?&ft:""}', 'percent': '%3p%%', 'percentwin': '%P',
      \     'fileencoding': '%{&fenc != "utf-8" ? &fenc:""}',
      \     'fileformat': '%{&ff != "unix" ? &ff : ""}',
		  \     'lineinfo': '%3l,%-2v',
      \   },
      \   'component_visible_condition': {
      \     'fileencoding': '&fenc',
      \     'fileformat': '&ff',
      \   },
      \ }


function! MyLightlineDir() abort
  let dir = expand("%:p:h:t")
  let project = FindRootDirectory()
  let project = fnamemodify(project, ':t')
  if dir == project
    return ''
  endif
  return dir
endfunction

" for vim-bufferline plugin
function! MyLightlineBufferline()
  call bufferline#refresh_status()
  return [ g:bufferline_status_info.before,
        \ g:bufferline_status_info.current,
        \ g:bufferline_status_info.after]
endfunction

" let s:p.{mode}.{where} = [ [ {guifg}, {guibg}, {cuifg}, {cuibg} ], ... ]
let s:grey = [ '', '',  240, 249 ]
let s:red =  [ '', '',  238, 208 ]
let s:blue =  [ '', '',  238, 153 ]
let s:blue2 = [ '', '',  238, 39 ]
let s:blue3 = [ '', '',  238, 45 ]

let s:p = {'normal': {}, 'tabline' : {} }

let s:p.normal.left = [ s:red, s:grey, s:blue, s:blue3 ]
let s:p.normal.middle = [ s:grey ]
" let s:p.normal.right = [ s:blue, s:grey, s:blue ]
let s:p.normal.right = [ s:grey, s:grey, s:grey ]

let s:p.tabline.tabsel = [ s:blue ]
let s:p.tabline.left = [ s:grey ]
let s:p.tabline.middle = [ s:grey ]
let s:p.tabline.right = [ s:grey ]

let g:lightline#colorscheme#mylightline#palette = s:p
