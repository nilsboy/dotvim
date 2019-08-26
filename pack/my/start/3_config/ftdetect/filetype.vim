" Set filetype on vimdocs even when opened directly from file
autocmd BufRead,BufNewFile *vim*/doc/*.txt setlocal filetype=help

" prevent vim from using javascript as filetype for json
autocmd BufRead,BufNewFile *.{json} setlocal filetype=json

autocmd BufRead,BufNewFile .tern-project setlocal filetype=json
autocmd BufRead,BufNewFile *.swagger.{yaml,json} setlocal filetype=swagger

autocmd BufRead,BufNewFile *.docopt setlocal filetype=docopt
autocmd BufRead,BufNewFile .babelrc setlocal filetype=json
autocmd BufRead,BufNewFile *.sqlresult setlocal filetype=sqlresult
autocmd BufRead,BufNewFile *.handlebars setlocal filetype=handlebars
autocmd BufRead,BufNewFile *.rest setlocal filetype=rest
autocmd BufRead,BufNewFile *.ts setlocal filetype=typescript
autocmd BufRead,BufNewFile ctags.conf setlocal filetype=ctags
autocmd BufRead,BufNewFile *proxy*/*.conf setlocal filetype=nginx
autocmd BufRead,BufNewFile pm2.json setlocal filetype=pm2
autocmd BufRead,BufNewFile *.class setlocal filetype=class

