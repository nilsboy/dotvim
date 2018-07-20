finish
" NOTE: succeeded by ncm2

" Fast! Extensible! Async! Completion Framework for Neovim
" NOTE: does not work with vim-lsp
" NOTE: breaks own CursorHoldI autocmds
NeoBundle 'roxma/nvim-completion-manager'

" Note: alternatives: https://www.reddit.com/r/vim/comments/4ufblz/alternatives_to_youcompleteme/

" NeoBundle 'roxma/nvim-cm-tern', {
"       \ 'build': { 'unix': 'npm install' }}

let g:cm_sources_enable = 0

let g:cm_complete_delay = 200
let g:cm_smart_enable = 1
let g:cm_refresh_default_min_word_len = [[1,1]]
let g:cm_matcher = {
      \ 'module': "cm_matchers.fuzzy_matcher",
      \ 'case': "smartcase" }

let g:cm_sources_override = {
    \ 'cm-bufkeyword': {'priority': 0},
    \ 'cm-tmux': {'priority': 0},
    \ 'cm-filepath': {'priority': 0},
    \ 'cm-keyword-continue': {'priority': 0},
    \ 'cm-tags': {'priority': 0},
    \ }

" the popup-menu prevents the first <cr> to work:
" not sure what <c-g>u is - but this seems to work:
" https://stackoverflow.com/questions/16804859/vim-how-to-make-autocomplpop-snipmate-supertab-work-together
inoremap <expr> <cr> pumvisible() ? "\<c-g>u\<cr>" : "\<cr>"
imap <c-space> <Plug>(cm_force_refresh)

" css completion via `csscomplete#CompleteCSS`
" The `'cm_refresh_patterns'` is PCRE.
" Be careful with `'scoping': 1` here, not all sources, especially omnifunc,
" can handle this feature properly.
au User CmSetup call cm#register_source({'name' : 'cm-lsp',
  \ 'priority': 9,
  \ 'scoping': 1,
  \ 'scopes': ['javascript'],
  \ 'abbreviation': 'js',
  \ 'word_pattern': '[\.]+',
  \ 'cm_refresh_patterns':['\.'],
  \ 'cm_refresh': {'omnifunc': 'lsp#complete'},
  \ })
