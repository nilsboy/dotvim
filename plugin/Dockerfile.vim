" Vim syntax file & snippets for Docker's Dockerfile
PackAdd ekalinin/Dockerfile.vim

" Fix the too greedy filetype detection of this plugin
autocmd BufRead,BufNewFile Dockerfile.snippets setfiletype snippets
