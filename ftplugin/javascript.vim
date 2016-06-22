if exists("b:did_ftplugin_javascript")
    finish
endif
let b:did_ftplugin_javascript = 1

" map <buffer><silent><leader>mw :Esformatter<CR>:SyntasticCheck<CR>
map <buffer><silent><leader>mw :call JSTidy()<CR>:SyntasticCheck<CR>
" map <buffer><silent><leader>mw :Esformatter<CR>:SyntasticCheck<CR>

" Tab spacing
setlocal tabstop=2

" Shift width (moved sideways for the shift command)
setlocal shiftwidth=2

set makeprg=npm\ test

" http://eslint.org/docs/rules/
let g:syntastic_javascript_checkers = ['eslint']

function! JSTidy()
    let _view=winsaveview()

    " stdin currently does not work with --fix :(
    " %!eslint --fix --stdin
    !eslint --quiet --fix % >/dev/null

    " reload file from disc
    edit

    " Retabulate the whole file
    " :%retab!

    call winrestview(_view)
endfunction
