finish
" A light and configurable statusline/tabline
PackAdd itchyny/lightline.vim

" NOTE: dummy is used to make sure an inactive statusline is rendered
let g:lightline = {
      \   'colorscheme': 'mylightline',
      \   'active': {
      \     'left': [['project'] , ['dir'],  ['filename'], ['quickfix_title'],],
      \     'right': [
      \         ['percentwin'],
      \         ['lineinfo'],
      \         ['fileformat', 'fileencoding', 'filetype'],
			\         ['warnings', ],
			\         ['errors', ],
      \         ['empty'],
      \         ['paste', 'tags', ],
      \     ],
      \   },
      \   'inactive': { 'left': [['dummy']] , 'right': [['dummy']] },
      \   'component': {
      \     'location': '%{MyStatuslineLocation()}',
      \     'shortendLocation': '%{pathshorten(expand("%:p"))}',
      \     'projectOld': '%{fnamemodify(FindRootDirectory(), ":t")}',
      \     'project': '%{fnamemodify(getcwd(), ":t")}',
      \     'dir': '%{MyLightlineDir()}',
      \     'filetype': '%{&ft!=#""?&ft:""}', 'percent': '%3p%%', 'percentwin': '%P',
      \     'fileencoding': '%{&fenc != "utf-8" ? &fenc:""}',
      \     'fileformat': '%{&ff != "unix" ? &ff : ""}',
		  \     'lineinfo': '%3l,%-2v',
      \     'dummy': '',
      \     'empty': ' ',
      \     'errors': '%{MyQuickfixGetErrors("qf")}',
      \     'warnings': '%{MyQuickfixGetErrors("loclist")}',
      \     'paste': '%{&paste == 1 ? "paste" : ""}',
      \     'quickfix_title': '%{exists("w:quickfix_title") ? w:quickfix_title : ""}',
      \   },
      \   'component_visible_condition': {
      \     'fileencoding': '&fenc',
      \     'fileformat': '&ff',
      \     'paste': '(&paste == 1)',
      \     'quickfix_title': '(exists("w:quickfix_title") != 0)',
      \   },
      \ }

      " \   'component_expand': {
      " \     'bufferline': 'MyHelpersBufferlist',
      " \   },
      " \   'component_type': {
      " \     'bufferline': 'tabsel',
      " \   },

      " \   'tabline': {
      " \     'left': [['bufferline']],
      " \     'right': [[]],
      " \   },

function! MyQuickfixGetErrors(listType) abort
  if a:listType == 'qf'
    let list = getqflist()
  else
    let list = getloclist(0)
  endif
  let e = len(filter(copy(list), 'v:val.type == "e"'))
  let w = len(filter(copy(list), 'v:val.type == "w"'))
  if w > 0
    let w = '/' . w
  else
    let w = ''
  endif
  let label = e . w
  if label == '0'
    return ""
  endif
  return label
endfunction

function! MyLightlineTags() abort
  return ''
  if exists(':GutentagsUpdate')
    return gutentags#statusline("") != '' ? 'generating tags' : ''
  endif
  return ''
endfunction

function! MyLightlineDir() abort
  let dir = expand("%:p:h:t")
  let project = getcwd()
  let project = fnamemodify(project, ':t')
  if dir == project
    return ''
  endif
  return dir
endfunction

" let s:p.{mode}.{where} = [ [ {guifg}, {guibg}, {cuifg}, {cuibg} ], ... ]
let s:grey = [ '#444444', '#E2E3E5',  240, 249 ]
let s:red =  [ '#444444', '#F8D7DA',  238, 208 ]
let s:blue =  [ '#444444', '#0963B1',  238, 153 ]
let s:blue2 = [ '#444444', '#008787',  238, 81 ]
let s:orange = [ '#444444', '#FFF3CD',  238, 221 ]

let s:info = s:blue
let s:warn = s:orange
let s:error = s:red

" let s:p = {'normal': {}, 'tabline' : {} }
let s:p = {'normal': {}}

let s:p.normal.left = [ s:grey, s:blue, s:blue2 ]
let s:p.normal.middle = [ s:grey ]
let s:p.normal.right = [ s:grey, s:grey, s:grey, s:error, s:info, s:grey, s:error ]

" let s:p.tabline.tabsel = [ s:blue ]
" let s:p.tabline.left = [ s:grey ]
" let s:p.tabline.middle = [ s:grey ]
" let s:p.tabline.right = [ s:grey ]

let g:lightline.enable = {
  \ 'statusline': 1,
  \ 'tabline': 0,
  \ }

let g:lightline#colorscheme#mylightline#palette = s:p
