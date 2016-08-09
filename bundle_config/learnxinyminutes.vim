" Code documentation written as code!
NeoBundle 'adambard/learnxinyminutes-docs'

function! HelpLearnXInMinutes(topic) 
    let l:file = &filetype
    if a:topic != ''
        let l:file = a:topic
    endif

    let l:file = g:vim.bundle.dir . '/learnxinyminutes-docs/' 
                \ . l:file . '.html.markdown'

    if !filereadable(l:file)
        let l:file = fnamemodify(l:file, ":h")
        execute "Explore" file
    endif

    execute "edit" file
endfunction

command! -nargs=+ HelpLearnXInMinutes call HelpLearnXInMinutes(<f-args>)
nnoremap <leader>hl :call HelpLearnXInMinutes(&filetype)<cr>
