
function! DeleteFile(...)

    exe "normal :ggdG"
    exe ":UpdateTags"

    let theFile=expand('%:p')
    let delStatus=delete(theFile)

    if(delStatus == 0)
        echo "Deleted " . theFile
    else
        echohl WarningMsg
        echo "Failed to delete " . theFile
        echohl None
    endif

    return delStatus

endfunction
