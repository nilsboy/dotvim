" Vim Markdown runtime files
" NOTE: Has syntax highlighting in fenced code blocks:
" SEE ALSO: https://www.reddit.com/r/vim/comments/2x5yav/markdown_with_fenced_code_blocks_is_great/
" NOTE: overrides own formatoptions settings
" NOTE: slow with long lines
PackAdd plasticboy/vim-markdown

let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_new_list_item_indent = 0
