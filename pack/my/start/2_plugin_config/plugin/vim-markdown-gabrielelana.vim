finish
" NOTE: slow with long lines
PackAdd gabrielelana/vim-markdown

" to disable support for Jekyll files (enabled by default with: 1)
let g:markdown_include_jekyll_support = 0
" to enable the fold expression markdown#FoldLevelOfLine to fold markdown
" files. This is disabled by default because it's a huge performance hit even
" when folding is disabled with the nofoldenable option (disabled by default
" with: 0)
let g:markdown_enable_folding = 1
" to disable default mappings (enabled by default with: 1)
let g:markdown_enable_mappings = 1
" to disable insert mode mappings (enabled by default with: 1)
let g:markdown_enable_insert_mode_mappings = 1
" to enable insert mode leader mappings (disabled by default with: 0)
let g:markdown_enable_insert_mode_leader_mappings = 0
" to disable spell checking (enabled by default with: 1)
let g:markdown_enable_spell_checking = 0
" to disable abbreviations for punctuation and emoticons (enabled by default with: 1)
let g:markdown_enable_input_abbreviations = 1
" to enable conceal for italic, bold, inline-code and link text (disabled by default with: 0) 
let g:markdown_enable_conceal = 1

