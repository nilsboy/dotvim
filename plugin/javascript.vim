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

    " %!js-beautify
    "              \ -w 80
    "              \ --no-preserve-newlines
    "              \ --break-chained-methods
    "              \ --jslint
    "              \ -f -
    
                 " \ --preserve-newlines
                 " \ --break-chained-methods
                 " \ --max-preserve-newlines 2
                 " \ --jslint
    
    " %!uglifyjs --comments all
    " %!uglifyjs -b max-line-len=80 --comments all

    
    " %!js-beautify
    "              \ -w 80
    "              \ --break-chained-methods
    "              \ -f -

    " has no line wrapping
    " %!standard --format --stdin 2>/dev/null | grep -v '^standard: '

    " Retabulate the whole file
    ":%retab!

    " Can not fix much - only check
    " :%!jscs --preset node-style-guide --fix

    :%!esformatter

    " :SyntasticCheck

    call winrestview(_view)
endfunction

" autocmd bufwritepost *.js silent !standard-format -w %

" Nodejs dictionary, used by neocomplete through omnicomplete
" autocmd FileType javascript set dictionary+=${g:vim.bundle.dir}/vim-node/dict/node.dict

let g:syntastic_javascript_checkers = ['standard']
