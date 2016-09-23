" Import a csv file into a default sqlite3 database using the file name as
" table name.
" To dump the entire db use: 'sqlite3 your.db .dump </dev/null'
command! -nargs=* CsvToDb call CsvToDb()
function! CsvToDb(...) abort
  let l:db = $HOME . '/var/csv.db'
  let l:table = expand('%:t:r')
  let l:table = substitute(l:table, '[^a-zA-Z]', "_", "g")

  echom 'using table name: ' . l:table

  execute '!sqlite3 -cmd "drop table ' . l:table . '" -cmd ".mode csv" -cmd ".import % ' . l:table . '" ' . l:db . '</dev/null'

endfunction
