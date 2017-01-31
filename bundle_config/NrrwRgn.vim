finish
" To focus on a selected region while making the rest inaccessible
" tags: narrow region
NeoBundle 'chrisbra/NrrwRgn'

let g:nrrw_rgn_nohl = 1
let g:nrrw_rgn_update_orig_win = 1

" Disable default mapping
xmap <NOP> <Plug>NrrwrgnDo

" Edit content of a tag in a seperate buffer using the corresponding filetype
" for the tag
function! MyNarrow() abort

  silent normal vit

  " b:region_filetype is set via OnSyntaxChange
  if ! exists('b:region_filetype')
    echo 'Region filetype not set.'
    return
  endif
  let l:region_filetype = b:region_filetype

  " ?\<script\|\<style
  " normal ``
  let b:tag_indent = indent('.') / &shiftwidth + 1
  call DEBUG('Found indent: ' . b:tag_indent)

  let b:nrrw_aucmd_close  = ":normal ggO\<esc>Go"
  let b:nrrw_aucmd_written = ':normal vit' . b:tag_indent . '>'

  " NRV! (single window mode) is currently broken (2017-01-20)
  silent NRV
  execute 'setlocal filetype=' . l:region_filetype
  setlocal winheight=999
  silent normal =ie
  " TODO: does neoformat toggle the extra line?
  Neoformat

endfunction
nnoremap <silent> <leader>ii :call MyNarrow()<cr>

