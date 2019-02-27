finish
" pum completion menu for EasyClip yanks
" NOTE: problems with multiline pastes
" NOTE: does not add completied item to + register
" NOTE: makes pumenu smaller
PackAdd davidosomething/EasyClipRing.vim

imap <c-v> <Plug>(EasyClipRing)
