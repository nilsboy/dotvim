" Fast! Extensible! Async! Completion Framework for Neovim
NeoBundle 'roxma/nvim-completion-manager'

NeoBundle 'roxma/nvim-cm-tern', {
      \ 'build': { 'unix': 'npm install' }}

let g:cm_matcher = {
      \ 'module': "cm_matchers.fuzzy_matcher",
      \ 'case': "smartcase" }
let g:cm_refresh_default_min_word_len = [[1,1]]

let g:UltiSnipsExpandTrigger = "<Plug>(ultisnips_expand)"
inoremap <silent> <c-space> <c-r>=cm#sources#ultisnips#trigger_or_popup(
      \ "\<Plug>(ultisnips_expand)")<cr>
