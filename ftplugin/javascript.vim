map <silent> W :call JSTidy()<CR><CR>:SyntasticCheck<cr>

let &makeprg="npm run"

" install npm install standard -g
let g:syntastic_javascript_checkers=['standard']

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

    "%!js-beautify
                \ -w 80
                \ --preserve-newlines
                \ --max-preserve-newlines 2
                \ --break-chained-methods
                \ --jslint
                \ -f -

    " Retabulate the whole file
    " :%retab!

    " %!standard --format --stdin | grep -v 'standard: '
    %!standard --format --stdin 2>/dev/null

    call winrestview(_view)
endfunction

