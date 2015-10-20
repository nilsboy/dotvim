map <buffer> <leader> w :call JSONTidy()<CR>

" for syntax check to work run: npm -g install jsonlint

autocmd FileType json setlocal syntax=txt
autocmd FileType json setlocal foldmethod=manual

if exists("b:did_ftplugin_json")
    finish
endif
let b:did_ftplugin_json = 1

function! JSONTidy()
    let _view=winsaveview()
    %!json_pp -json_opt pretty,canonical,indent
    call winrestview(_view)
endfunction
