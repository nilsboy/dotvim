function! BsonToJson() abort
  let orgFile = expand('%')
  let orgBuffer = bufnr('%')
  let json = nb#mktemp("bson2json") . expand('%:t') . '.json'
  silent execute 'edit ' . json
  silent execute 'r!bsondump ' . orgFile
  keepjumps normal! ggdd
  keepjumps normal! Gdd
  keepjumps 1,$-1s/$/,/g
  keepjumps normal! gg
  0put ='['
  $put =']'
  keepjumps execute 'normal! ggP0daWI// '
  keepjumps normal! 0
  setlocal syntax=jsonc
  setlocal filetype=jsonc
  keepjumps call MakeWith({'compiler': b:formatter, 'loclist': 1})
  silent execute 'bdelete ' . orgBuffer
endfunction

call BsonToJson()

if exists("bson#loaded")
  finish
endif
let bson#loaded = 1

MyInstall bsondump pkexec apt install mongodb-database-tools

