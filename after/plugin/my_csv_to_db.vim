" Import a csv file into a default sqlite3 database using the file name
" as table name.
" To dump the entire db use: 'sqlite3 your.db .dump </dev/null'
command! -nargs=* MyCsvToDb call MyCsvToDb()
function! MyCsvToDb(...) abort
  let db = $HOME . '/var/csv.db'
  let table = expand('%:t:r')
  let table = substitute(table, '[^a-zA-Z]', "_", "g")

  echom 'using table name: ' . table

  execute '!sqlite3 -cmd "drop table ' . table 
        \ . '" -cmd ".mode csv" -cmd ".import % '
        \ . table . '" ' . db . '</dev/null'
endfunction
