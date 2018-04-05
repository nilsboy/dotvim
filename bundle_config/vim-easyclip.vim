" Simplified clipboard functionality for Vim
" NOTE: Also discards deletes when prefixed by a register - like: normal "adgg<esc>
" - need to use normal! instead
" SEE ALSO: https://github.com/kana/vim-operator-replace
" NeoBundle 'svermeulen/vim-easyclip'
NeoBundle 'nilsboy/vim-easyclip'

MyInstall xsel !sudo apt-get install xsel

let g:EasyClipAutoFormat = 1

let g:EasyClipAlwaysMoveCursorToEndOfPaste = 1
let g:EasyClipPreserveCursorPositionAfterYank = 1

let g:EasyClipUseCutDefaults = 0
nmap Y <Plug>MoveMotionPlug
xmap Y <Plug>MoveMotionXPlug
nmap YY <Plug>MoveMotionLinePlug

let g:EasyClipShareYanksDirectory = g:vim.var.dir . "/easyclip"
let g:EasyClipShareYanksFile = "shared-yanks"
call Mkdir(g:EasyClipShareYanksDirectory, 'p')
let g:EasyClipShareYanks = 1
let g:EasyClipYankHistorySize = 500

" cmap <c-v> <plug>EasyClipCommandModePaste

" nmap rl <plug>EasyClipRotateYanksForward
" nmap rh <plug>EasyClipRotateYanksBackward

" let g:EasyClipUsePasteToggleDefaults = 0
" nmap <c-p> <plug>EasyClipSwapPasteForward
" nmap <c-n> <plug>EasyClipSwapPasteBackwards

" let g:EasyClipUseSubstituteDefaults = 0
" nmap <leader>s <plug>SubstituteOverMotionMap
" " gs        <plug>G_SubstituteOverMotionMap
" " ss        <plug>SubstituteLine
" " s         <plug>XEasyClipPaste
" " S         <plug>SubstituteToEndOfLine
" " gS        <plug>G_SubstituteToEndOfLine

inoremap <c-v> <c-x><c-u>

augroup MyEasyclipAugroupCleanNewLines
  autocmd!
  " workaround from EasyClipRing.vim - changes the whole buffer
  " Vars are stored with <00> in vim vars - no way to replace them for
  " completion menu
  " TODO: make this atomic
  autocmd CompleteDone * :%s/\%x00/\r/ge | call MyEasyclipSavePasteToRegister()
augroup END

function! MyEasyclipSavePasteToRegister() abort
  if ! empty(v:completed_item) 
    call setreg('+', v:completed_item.word)
  endif
endfunction

function! MyEasyclipYanks()
  let yanks = []
  for yank in EasyClip#Yank#EasyClipGetAllYanks()
    let line = yank.text
    call add(yanks, line)
  endfor
  return yanks
endfunction

" SEE ALSO: :h NL-used-for-Nul
function! MyEasyclipCompleteYanks(findstart, base)
  if a:findstart
    " locate the start of the word
    let line = getline('.')
    let start = col('.') - 1
    while start > 0 && line[start - 1] =~ '\a'
      let start -= 1
    endwhile
    return start
  else
    let res = []
    for m in MyEasyclipYanks()
      if m =~ '' . a:base
        call add(res, m)
      endif
    endfor
    return res
  endif
endfun
set completefunc=MyEasyclipCompleteYanks
