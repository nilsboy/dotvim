" Vim syntax file & snippets for Docker's Dockerfile
 NeoBundleLazy 'ekalinin/Dockerfile.vim',
        \ {'autoload': {'filetypes': 'Dockerfile'}}

" Fix the too greedy filetype detection of this plugin
autocmd BufRead,BufNewFile Dockerfile.snippets setfiletype snippets
