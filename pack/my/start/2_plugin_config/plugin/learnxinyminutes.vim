finish
" Code documentation written as code!
PackAdd adambard/learnxinyminutes-docs

function! HelpLearnXInMinutes(topic) abort
    let l:file = &filetype
    if a:topic != ''
        let l:file = a:topic
    endif

    let l:file = 'FIXME' . '/learnxinyminutes-docs/' 
                \ . l:file . '.html.markdown'

    if !filereadable(l:file)
        let l:file = fnamemodify(l:file, ":h")
        execute "Explore" file
    endif

    execute "edit" file
endfunction

command! -nargs=+ HelpLearnXInMinutes call HelpLearnXInMinutes(<f-args>)
nnoremap <leader>hf :call HelpLearnXInMinutes(&filetype)<cr>
