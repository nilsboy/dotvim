function! JSTidy()
    let _view=winsaveview()

    " installed by cpanm JavaScript::Beautifier
    " breaks code
    " %!js_beautify.pl -

    " npm install pretty-js
    " no line wrap
    " %!pretty-js -

    " npm install -g uglify-js
    " only two options
    " %!uglifyjs --beautify -

    " npm install -g prettydiff
    " %!prettydiff --beautify -

    " npm install -g js-beautify
    " cannot correct missing curlies or semicolons
    "%!js-format-using-prettydiff

    " %!standard --format --stdin | grep -v 'standard: '
    %!standard --format --stdin 2>/dev/null

    %!js-beautify
                 \ -w 80
                 \ --preserve-newlines
                 \ --max-preserve-newlines 2
                 \ --break-chained-methods
                 \ --jslint
                 \ -f -

    " Retabulate the whole file
    :%retab!

    call winrestview(_view)
endfunction

" Nodejs dictionary, used by neocomplete through omnicomplete
autocmd FileType javascript set dictionary+=${g:vim.bundle.dir}/vim-node/dict/node.dict
