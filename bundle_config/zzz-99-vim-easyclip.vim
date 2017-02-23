" Simplified clipboard functionality for Vim
NeoBundle 'svermeulen/vim-easyclip', {
    \ 'build': 'sudo apt-get install xsel'
    \ }

" Does not seam to have any effect
let g:EasyClipUseSubstituteDefaults = 0

let g:EasyClipAutoFormat = 0

" let g:EasyClipAlwaysMoveCursorToEndOfPaste = 1
let g:EasyClipPreserveCursorPositionAfterYank = 1

" Store yanks to file
let g:EasyClipShareYanksDirectory = g:vim.var.dir . "/easyclip"
let g:EasyClipShareYanksFile = "shared-yanks"
call Mkdir(g:EasyClipShareYanksDirectory, 'p')
let g:EasyClipShareYanks = 1

let g:EasyClipYankHistorySize = 500

finish

" Notes
" Also discards deletes when prefixed by a register - like: normal "adgg<esc>
" - need to use normal! instead

" Needs to be loaded after vim-sneak to not clobber s-mappings:
" https://github.com/svermeulen/vim-easyclip/issues/60

" Sometimes produces error on start:
" Error detected while processing function EasyClip#Init[10]..EasyClip#Shared#Init[14]..EasyClip#Yank#GetYankstackHead[1]..EasyClip#Yank#GetYankInfoForReg[1]..provider#clipboard#Call[1]..20[4]..<SNR>225_try_cmd:
" line    2:
" E5677: Error writing input to shell-command: EPIPE
" Press ENTER or type command to continue
