finish
" Fuzzy file, buffer, mru, tag, etc finder

" ctrlp-funky: Navigate and jump to function defs
NeoBundle 'ctrlpvim/ctrlp.vim', { 'depends': 'tacahiroy/ctrlp-funky' }

if neobundle#tap('ctrlp.vim')
  function! neobundle#hooks.on_source(bundle)

let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'dir', 'rtscript',
      \ 'undo', 'line', 'changes', 'mixed', 'bookmarkdir', 'funky']

let g:ctrlp_match_window = 'bottom,order:ttb,min:25,max:25,results:25'

let g:ctrlp_clear_cache_on_exit=1
let g:ctrlp_max_height=40
let g:ctrlp_show_hidden=0
let g:ctrlp_follow_symlinks=1
let g:ctrlp_max_files=1000
let g:ctrlp_cache_dir=g:vim.cache.dir . 'ctrlp'

" let g:ctrlp_custom_ignore = {
"     \ 'dir': '\v[\/]\.(git|hg|svn|idea)$',
"     \ 'file': '\v\.DS_Store|\.class|\.jar$'
"     \ }

let g:ctrlp_working_path_mode = 'r'
let g:ctrlp_open_new_file = 'r'

if executable('ag')
    let g:ctrlp_user_command='ag %s -l --nocolor -g ""'
endif

" let g:ctrlp_buftag_types = {
"     \ 'javascript' : {
"       \ 'bin': 'jsctags',
"       \ 'args': '-f -',
"       \ },
" \ }

let g:ctrlp_prompt_mappings = {
    \ 'PrtExpandDir()':       [],
    \ 'PrtExit()':            ['<tab>'],
    \ 'ToggleMRURelative()':  [','],
\ }

let g:ctrlp_line_prefix = ''

  endfunction
  call neobundle#untap()
endif
