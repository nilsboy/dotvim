map <silent> W :call JSTidy()<CR><CR>:SyntasticCheck<cr>

" Tab spacing
set tabstop=2

" Shift width (moved sideways for the shift command)
set sw=2

let &makeprg="npm run"

" install npm install standard -g
" https://github.com/feross/standard
let g:syntastic_javascript_checkers=['standard']

nnoremap <buffer> <silent> K :TernDoc<CR>

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

