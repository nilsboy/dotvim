" A different approach to code highlighting.
NeoBundle 'thiagoalessio/rainbow_levels.vim'

nnoremap <silent> gl :RainbowLevelsToggle<cr>

augroup MyRainbowLevelsActivate
  autocmd!
  autocmd ColorScheme,Syntax,FileType * call MyRainbowLevelsColors()
augroup END

function! MyRainbowLevelsColors() abort
  highlight! link RainbowLevel0 Normal
  highlight! link RainbowLevel1 Type
  highlight! link RainbowLevel2 Function
  highlight! link RainbowLevel3 String
  highlight! link RainbowLevel4 PreProc
  highlight! link RainbowLevel5 Statement
  highlight! link RainbowLevel6 Identifier
  highlight! link RainbowLevel7 Normal
  highlight! link RainbowLevel8 Comment
endfunction

