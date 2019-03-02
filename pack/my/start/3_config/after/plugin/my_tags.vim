" - https://www.reddit.com/r/vim/comments/7v1nj6/vim_workflow_trouble/dtoukt0/
" - https://www.reddit.com/r/vim/comments/65vnrq/coworkers_criticize_my_workflow_for_lacking/?st=j1n9przw&sh=a9a4a220

" NOTE: see gutentags
" NOTE: alternative to ctags: https://www.gnu.org/software/global/

let &tags = '.git/tags'
set showfulltag
set cpoptions=+d

" find . -type f -iregex ".*\.js$" -not -path "./node_modules/*" -exec jsctags {} -f \; | sed '/^$/d' | sort > .git/tags

" augroup MyTagsAugroupPreviewTag
"   autocmd!
"   autocmd CursorHold * nested execute "silent! ptag " . expand("<cword>")
" augroup END

" augroup MyTagsAugroupPreviewLsp
"   autocmd!
"   autocmd CursorHold * nested execute "silent! LspHover"
" augroup END
