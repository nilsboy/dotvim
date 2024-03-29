" Set filetype on vimdocs even when opened directly from file
autocmd BufRead,BufNewFile *vim*/doc/*.txt setlocal filetype=help

" prevent vim from using javascript as filetype for json
autocmd BufRead,BufNewFile *.{json} setlocal filetype=jsonc

autocmd BufRead,BufNewFile .tern-project setlocal filetype=jsonc
autocmd BufRead,BufNewFile *.swagger.{yaml,json} setlocal filetype=swagger
autocmd BufRead,BufNewFile *.openapi.{yaml,json} setlocal filetype=openapi

autocmd BufRead,BufNewFile *.docopt setlocal filetype=docopt
autocmd BufRead,BufNewFile .babelrc setlocal filetype=jsonc
autocmd BufRead,BufNewFile *.sqlresult setlocal filetype=sqlresult
autocmd BufRead,BufNewFile *.handlebars setlocal filetype=handlebars
autocmd BufRead,BufNewFile *.rest setlocal filetype=rest
autocmd BufRead,BufNewFile *.ts setlocal filetype=typescript
autocmd BufRead,BufNewFile ctags.conf setlocal filetype=ctags
autocmd BufRead,BufNewFile *proxy*/*.conf* setlocal filetype=nginx
autocmd BufRead,BufNewFile *.class setlocal filetype=class
autocmd BufRead,BufNewFile pm2.json setlocal filetype=javascript

autocmd BufRead,BufNewFile *.bson setlocal filetype=bson

autocmd BufRead,BufNewFile .env* setlocal filetype=dotenv

autocmd BufRead,BufNewFile *.mongodb.js setlocal filetype=mongodb

" autocmd BufRead,BufNewFile *.mongodb.js setlocal filetype=typescript
" if did_filetype()
"   finish
" endif
" if getline(1) =~ '^#!.*\<vite-node\>'
"   setfiletype typescript
" endif
