" Set filetype on vimdocs even when opened directly from file
autocmd BufRead,BufNewFile *vim*/doc/*.txt setlocal filetype=help

autocmd BufRead,BufNewFile *.class setlocal filetype=class

" prevent vim from using javascript as filetype for json
autocmd BufRead,BufNewFile *.{json,handlebars} setlocal filetype=json

autocmd BufRead,BufNewFile .tern-project setlocal filetype=json
autocmd BufRead,BufNewFile *.swagger.{yaml,json} setlocal filetype=swagger

" autocmd BufRead,BufNewFile */bin/* 
"       \ if &filetype == '' | setlocal filetype=sh | endif

autocmd BufRead,BufNewFile *.docopt setlocal filetype=docopt
autocmd BufRead,BufNewFile .babelrc setlocal filetype=babelrc
autocmd BufRead,BufNewFile *.sqlresult setlocal filetype=sqlresult
