map <buffer> <leader>mw :call JSONTidy()<CR>

" for syntax check to work run: npm -g install jsonlint

autocmd FileType json setlocal syntax=txt
autocmd FileType json setlocal foldmethod=manual

" Tab spacing
setlocal tabstop=2

" Shift width (moved sideways for the shift command)
setlocal shiftwidth=2

if exists("b:did_ftplugin_json")
    finish
endif
let b:did_ftplugin_json = 1

function! JSONTidy()
    let _view=winsaveview()
    " %!json_pp -json_opt pretty,canonical,indent
    " %!json-tidy
    " %!jq '.'

    " npm install -g jsonlint
    " does not sort keys by default!
    " use -s for sorted keys
    %!jsonlint -p
    call winrestview(_view)
endfunction
