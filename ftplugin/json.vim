map <silent> W :call JSONTidy()<CR>

function JSONTidy()
    let _view=winsaveview()
    %!json_pp -json_opt pretty,canonical,indent
    call winrestview(_view)
endfunction