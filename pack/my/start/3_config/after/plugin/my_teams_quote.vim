function! MyTeamsQuote(...) abort
  let cmd = join(a:000)
  %s/\v[\r\n]+/\r/g
  %!fmt --width=78
  %s/\v^(\S+)/> \1/g
  normal gg
endfunction
command! -nargs=* MyTeamsQuote silent! call MyTeamsQuote(<f-args>)
