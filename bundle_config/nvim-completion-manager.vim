" Fast! Extensible! Async! Completion Framework for Neovim
NeoBundle 'roxma/nvim-completion-manager'

NeoBundle 'roxma/nvim-cm-tern', {
      \ 'build': { 'unix': 'npm install' }}

let g:cm_complete_delay = 200

let g:cm_matcher = {
      \ 'module': "cm_matchers.fuzzy_matcher",
      \ 'case': "smartcase" }

let g:cm_refresh_default_min_word_len = [[1,1]]

" Highest priority for current buffer keyword completion
let g:cm_sources_override = {
    \ 'cm-bufkeyword': {'priority': 9}
    \ }
