finish
" conflicts with neomake etc
" only useful for git changes? - Use other plugin for that?
" Mark quickfix & location list items with signs
NeoBundle 'quickfixsigns'

let g:quickfixsigns_protect_sign_rx = '^neomake_'
