" Cutlass overrides the delete operations to actually just delete and not affect the current yank.

MyInstall xsel pkexec apt install xsel

PackAdd svermeulen/vim-cutlass 

nnoremap Y d
xnoremap Y d
nnoremap YY dd
