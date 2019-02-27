finish
" Fuzzy file, buffer, mru, tag, etc finder

" ctrlp-funky: Navigate and jump to function defs
PackAdd ctrlpvim/ctrlp.vim', { 'depends': 'tacahiroy/ctrlp-funky }

if neobundle#tap('ctrlp.vim')
  function! neobundle#hooks.on_source(bundle)

let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'dir', 'rtscript',
      \ 'undo', 'line', 'changes', 'mixed', 'bookmarkdir', 'funky']

let g:ctrlp_clear_cache_on_exit=1
let g:ctrlp_max_height=40
let g:ctrlp_show_hidden=0
let g:ctrlp_follow_symlinks=1
let g:ctrlp_max_files=1000
let g:ctrlp_cache_dir=$XDG_CACHE_DIR . '/ctrlp'

" let g:ctrlp_custom_ignore = {
"     \ 'dir': '\v[\/]\.(git|hg|svn|idea)$',
"     \ 'file': '\v\.DS_Store|\.class|\.jar$'
"     \ }

let g:ctrlp_working_path_mode = 'rc'
let g:ctrlp_open_new_file = 'r'
let g:ctrlp_by_filename = 1

if executable('ag')
    let g:ctrlp_user_command='ag %s -l --nocolor -g ""'
endif

let g:ctrlp_line_prefix = ''
let g:ctrlp_match_window = 'top,order:ttb,min:20,max:20,results:1000'
let g:ctrlp_use_caching = 0

let g:ctrlp_map = '<tab>'

  let g:ctrlp_prompt_mappings = {
    \ 'PrtBS()':              ['<bs>', '<c-]>'],
    \ 'PrtDelete()':          ['<del>'],
    \ 'PrtDeleteWord()':      ['<c-w>'],
    \ 'PrtClear()':           ['<c-u>'],
    \ 'PrtSelectMove("j")':   ['<c-j>', '<down>'],
    \ 'PrtSelectMove("k")':   ['<c-k>', '<up>'],
    \ 'PrtSelectMove("t")':   ['<Home>', '<kHome>'],
    \ 'PrtSelectMove("b")':   ['<End>', '<kEnd>'],
    \ 'PrtSelectMove("u")':   ['<PageUp>', '<kPageUp>'],
    \ 'PrtSelectMove("d")':   ['<PageDown>', '<kPageDown>'],
    \ 'PrtHistory(-1)':       ['<c-n>'],
    \ 'PrtHistory(1)':        ['<c-p>'],
    \ 'AcceptSelection("e")': ['<cr>', '<2-LeftMouse>'],
    \ 'AcceptSelection("h")': ['<c-x>', '<c-cr>', '<c-s>'],
    \ 'AcceptSelection("t")': [''],
    \ 'AcceptSelection("v")': ['<RightMouse>'],
    \ 'ToggleFocus()':        ['<c-t>'],
    \ 'ToggleRegex()':        ['<c-r>'],
    \ 'ToggleByFname()':      ['<c-d>'],
    \ 'ToggleType(1)':        ['<c-f>', '<c-up>'],
    \ 'ToggleType(-1)':       ['<c-b>', '<c-down>'],
    \ 'PrtExpandDir()':       [],
    \ 'PrtInsert("c")':       ['<MiddleMouse>', '<insert>'],
    \ 'PrtInsert()':          ['<c-\>'],
    \ 'PrtCurStart()':        ['<c-a>'],
    \ 'PrtCurEnd()':          ['<c-e>'],
    \ 'PrtCurLeft()':         ['<c-h>', '<left>', '<c-^>'],
    \ 'PrtCurRight()':        ['<c-l>', '<right>'],
    \ 'PrtClearCache()':      ['<F5>'],
    \ 'PrtDeleteEnt()':       ['<F7>'],
    \ 'CreateNewFile()':      ['<c-y>'],
    \ 'MarkToOpen()':         ['<c-z>'],
    \ 'OpenMulti()':          ['<c-o>'],
    \ 'PrtExit()':            ['<tab>'],
    \ }

nnoremap <leader>rr :CtrlPMRUFiles<cr>

  endfunction
  call neobundle#untap()
endif
