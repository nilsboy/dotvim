" A plugin for asynchronous :make using Neovim's job-control functionality
NeoBundle 'neomake/neomake'

autocmd BufWritePost * :Neomake
