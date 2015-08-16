" Fuzzy file, buffer, mru, tag, etc finder
NeoBundle 'ctrlpvim/ctrlp.vim', { 'depends': 'tacahiroy/ctrlp-funky' }

if neobundle#tap('ctrlp.vim')
  function! neobundle#hooks.on_source(bundle)

let g:ctrlp_clear_cache_on_exit=1
let g:ctrlp_max_height=40
let g:ctrlp_show_hidden=0
let g:ctrlp_follow_symlinks=1
let g:ctrlp_max_files=20000
let g:ctrlp_cache_dir=g:vim.cache.dir . 'ctrlp'
let g:ctrlp_reuse_window='startify'
let g:ctrlp_extensions=['funky']
let g:ctrlp_custom_ignore = {
    \ 'dir': '\v[\/]\.(git|hg|svn|idea)$',
    \ 'file': '\v\.DS_Store$'
    \ }

if executable('ag')
    let g:ctrlp_user_command='ag %s -l --nocolor -g ""'
endif

nmap \ [ctrlp]
nnoremap [ctrlp] <nop>

nnoremap [ctrlp]t :CtrlPBufTag<cr>
nnoremap [ctrlp]T :CtrlPTag<cr>
nnoremap [ctrlp]l :CtrlPLine<cr>
nnoremap [ctrlp]o :CtrlPFunky<cr>
nnoremap [ctrlp]b :CtrlPBuffer<cr>

  endfunction
  call neobundle#untap()
endif
