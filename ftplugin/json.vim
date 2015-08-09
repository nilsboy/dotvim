if exists("b:did_ftplugin_json")
    finish
endif
let b:did_ftplugin_json = 1

map <silent> W :call JSONTidy()<CR>

" for syntax check to work run: npm -g install jsonlint
set syntax=txt

function! JSONTidy()
    let _view=winsaveview()
    %!json_pp -json_opt pretty,canonical,indent
    call winrestview(_view)
endfunction
