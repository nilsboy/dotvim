if exists("b:did_ftplugin_html")
    finish
endif
let b:did_ftplugin_html = 1

" let g:neomake_html_enabled_makers = ['html-beautify']

" finish
" !html-beautify --help
let g:formatdef_htmlbeautify = '"html-beautify -f - --indent-size 2 --indent-inner-html --wrap-line-length 80 --preserve-newlines --max-preserve-newlines 2"'

        " \ --wrap-attributes force

finish

" Ignore all unknown tags to support web components
" let g:syntastic_quiet_messages = {
"     \ "regex":   '\(is not recognized\|discarding unexpected\)' }
