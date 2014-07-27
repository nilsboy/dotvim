" syntax check on write
" au BufWritePost *.p[lm] !perl -wcIlib %

" map E :w<CR>:!r<CR>

"--- perltidy ------------------------------------------------------------------

 map <silent> <Leader>w :call PerlTidy()<CR>

function! PerlTidy()
    let _view=winsaveview()
    "%!perltidy -q
    %!perltidier -q
    " %!tidyall --conf-name ~/.tidyallrc -p ~/.tidyallrc
    call winrestview(_view)
endfunction

"--- :make with error parsing --------------------------------------------------

map <silent> <c-e> :make<cr>
set makeprg=$VIMRUNTIME/tools/efm_perl.pl\ -c\ %\ $*
set errorformat=%f:%l:%m

"--- show documentation for builtins and modules under cursor ------------------
" http://www.perlmonks.org/?node_id=441738

noremap <silent> <c-m> :call PerlDoc()<cr>:set nomod<cr>:set filetype=man<cr>

function! PerlDoc()

  normal yy

  let l:this = @

  if match(l:this, '^ *\(use\|require\) ') >= 0

    exe ':new'
    exe ':resize'

    let l:this = substitute(l:this, '^ *\(use\|require\) *', "", "")
    let l:this = substitute(l:this, ";.*", "", "")
    let l:this = substitute(l:this, " .*", "", "")

    exe ':0r!perldoc -t ' . l:this
    exe ':0'
    noremap <buffer> <esc> <esc>:q!<cr>

    return

  endif

  normal yiw
  exe ':new'
  exe ':resize'
  exe ':0r!perldoc -t -f ' . @
  exe ':0'
  noremap <buffer> <esc> <esc>:q!<cr>

endfunction
