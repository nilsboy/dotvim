" Deprecated see all.snippets instead

" Keyboard layout helpers

finish

" augroup insertLeave_ChangeKeymap
"     autocmd!
"     autocmd InsertLeave * :set keymap=us
" augroup END

" Use insert abbreviations to insert german keyboard special characters
function! EatWhitespace(pat) abort
  let c = nr2char(getchar(0))
  normal X
  return a:pat
endfunction

iabbrev ae <c-r>=EatWhitespace('ä')<cr>
iabbrev Ae <c-r>=EatWhitespace('Ä')<cr>

iabbrev oe <c-r>=EatWhitespace('ö')<cr>
iabbrev Oe <c-r>=EatWhitespace('Ö')<cr>
                           
iabbrev ue <c-r>=EatWhitespace('ü')<cr>
iabbrev Ue <c-r>=EatWhitespace('Ü')<cr>
                           
iabbrev ee <c-r>=EatWhitespace('€')<cr>
iabbrev me <c-r>=EatWhitespace('µ')<cr>
iabbrev 2e <c-r>=EatWhitespace('²')<cr>
iabbrev 3e <c-r>=EatWhitespace('³')<cr>
iabbrev 0e <c-r>=EatWhitespace('°')<cr>
iabbrev #e <c-r>=EatWhitespace('§')<cr>

finish

" Allow language specific keys in insert mode with leader prepended

inoremap <leader>k' ä
inoremap <leader>k" Ä

inoremap <leader>k; ö
inoremap <leader>k: Ö

inoremap <leader>k[ ü
inoremap <leader>k{ Ü

inoremap <leader>ke €
inoremap <leader>km µ
inoremap <leader>k2 ²
inoremap <leader>k3 ³
inoremap <leader>k~ °
inoremap <leader>k# §

finish

" Allow language specific keys in insert mode with leader prepended

inoremap <leader>ä ä
inoremap <leader>Ä Ä

inoremap <leader>ö ö
inoremap <leader>Ö Ö

inoremap <leader>ü ü
inoremap <leader>Ü Ü

inoremap <leader>e €
inoremap <leader>m µ
inoremap <leader>2 ²
inoremap <leader>3 ³
inoremap <leader>° °
inoremap <leader>§ §

finish

" Make german keyboard more programmer friendly
noremap ö [
inoremap ö [
noremap [ x
inoremap [ x

noremap Ö {
inoremap Ö {
noremap { x
inoremap { x

noremap ä ]
inoremap ä ]
noremap ] x
inoremap ] x

noremap Ä }
inoremap Ä }
noremap } x
inoremap } x

noremap ü \|
inoremap ü \|
noremap \ x
inoremap \ x

noremap Ü \
inoremap Ü \
noremap \ x
inoremap \ x

noremap ° ~
inoremap ° ~

noremap \| x
inoremap \| x

noremap § @
inoremap § @

noremap @ x
inoremap @ x
