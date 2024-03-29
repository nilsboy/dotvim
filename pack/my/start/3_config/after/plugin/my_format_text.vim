" NOTE: autoformat and lists do not seem to work together
" SEE ALSO: https://www.reddit.com/r/vim/comments/4lvaok/supercharge_vim_formatting_for_plain_text/
" :help auto-format
" :help format-comments
" TODO: if the listpat fits in the previous row the listpat is wrapped into the
" previous row

function! MyVimrcShowFormatSettings() abort
  call nb#info('&comments:' . &comments)
  call nb#info('&commentstring:' . &commentstring)
  call nb#info('&formatprg:' . &formatprg)
  call nb#info('&formatoptions:' . &formatoptions)
  call nb#info('&formatlistpat:' . &formatlistpat)
  call nb#info('&autoindent:' . &autoindent)
  call nb#info('&smartindent:' . &smartindent)
  call nb#info('&cindent:' . &cindent)
  call nb#info('&textwidth:' . &textwidth)
  call nb#info('&wrap:' . &wrap)
endfunction

finish

" let &l:commentstring = '> %s'
" let &l:comments = 'nb:#,nb:-,nb:*,nb:1.'
setlocal comments=
let &l:formatoptions = 'roqanj1'
" let &formatlistpat = '\v^\s*([-\+\*]|1\.)\s+'
let &formatlistpat = '\v^\s*[-\+\*]\s+'
" let &formatlistpat .= '|\c\v^\s*(todo|note|tags|see also|fix)\s+'
" setlocal formatlistpat=^\\s*[0-9*]\\+[\\]:.)}\\t\ ]\\s* 

" " Use autocmd because these seem to get overwritten by a lot of plugins
" function! MyVimrcForceFormattingSettings() abort
"   setlocal formatoptions=roqanj1c
"   let &formatlistpat = '\c\v^\s*[-\+\*]\s+'
"   let &formatlistpat .= '|\c\v^\s*(todo|note|tags|see also|fix)\s+'
"   setlocal noautoindent
" endfunction
" augroup MyVimrcAugroupForceFormattingSettings
"   autocmd!
"   autocmd BufWinEnter * call MyVimrcForceFormattingSettings()
" augroup END
