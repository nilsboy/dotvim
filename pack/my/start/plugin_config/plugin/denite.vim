finish
" Dark powered asynchronous unite all interfaces
":h Denite
" Needs after install:
" :UpdateRemotePlugins
PackAdd Shougo/denite.nvim', { 'name' : 'denite }

" TODO check if mappings in command mode can be added

" MRU plugin includes unite.vim MRU sources
PackAdd Shougo/neomru.vim

let g:neomru#file_mru_limit=3000

if neobundle#tap('denite') 
    function! neobundle#hooks.on_post_source(bundle)

    " outline source for unite.vim
    PackAdd Shougo/unite-outline

    let g:unite_source_outline_filetype_options = {
        \ '*': {
        \   'auto_update': 1,
        \   'auto_update_event': 'hold',
        \ },
        \ 'java': {
        \   'ignore_types': ['package'],
        \ },
        \ 'perl': {
        \   'ignore_types': ['package'],
        \ },
    \}

    call denite#custom#option('default', 'prompt', '>')

    nnoremap <silent> <tab> :Denite -resume<cr>

    " call denite#custom#map("normal", "x", "suspend")

nnoremap <silent> <leader>rg :call _Denite('mru', 'file_mru', '', '')<cr>
nnoremap <silent> <leader>rd :call _Denite('mru_dirs', 'unite:neomru/directory', 'project', '')<cr>

nnoremap <silent> <leader>rr :call _Denite('project_mru', 'file_mru/project', '', '')<cr>
call denite#custom#alias('source', 'file_mru/project', 'file_mru')
call denite#custom#source('file_mru/project',
  \ 'matchers', ['matcher_fuzzy', 'matcher_project_files'])

nnoremap <silent> <leader>ff :call _Denite('project_files', 'file_rec', 'project', '')<cr>
nnoremap <silent> <leader>fd :call _Denite('buffer_dir', 'file_rec', 'buffer_dir', '')<cr>
nnoremap <silent> <leader>vp :call _Denite('plugin_dir', 'file_rec', g:vim.bundle.dir, '')<cr>
nnoremap <silent> <leader>fw :call _Denite('project_file_word', 'file_rec', 'project', 'cword')<cr>

nnoremap <silent> <leader>gi :call _Denite('project_grep', 'grep', 'project', '')<cr>
nnoremap <silent> <leader>gg yiw:call _Denite('project_grep_cword', 'grep', 'project', @")<cr>
nnoremap <silent> <leader>gW yiW:call _Denite('project_grep_cWORD', 'grep', 'project', @")<cr>

nnoremap <silent><leader>vb :call _Denite('buffers', 'buffer:!', '', '')<cr>
nnoremap <silent><leader>vh :call _Denite('vim_help', 'help', '', '')<cr>

" nnoremap <silent> <Leader>o :call _Denite('outline', 'unite:outline', '', '')<cr>

" nnoremap <silent><leader>/ :call _Denite('lines', 'line', '', '')<cr>
" nnoremap <silent><leader>// :call _Denite('lines', 'line', '', 'cword')<cr>

nnoremap <silent> <Leader>bb :call _Denite('bookmarks', 'unite:bookmark', '', '')<cr>
nnoremap <silent> <Leader>ba :UniteBookmarkAdd<cr><esc>

  endfunction
  call neobundle#untap()
endif

" ### quickfix ###############################################################

PackAdd sgur/unite-qf

" nnoremap <silent> <leader>qq :call _Denite('quickfix', 'unite:qf', '', '')<cr>

" Needs to be BufWinEnter not BufReadPost for youcompleteme's
" GoToReferences to work
" autocmd BufWinEnter quickfix call s:ReplaceQuickfixWithUnite()
function s:ReplaceQuickfixWithUnite()
    cclose
    call _Denite('quickfix', 'unite:qf', '', '')
endfunction

" ### main unite #############################################################

function! _Denite(name, source, directory, input) abort

    if a:directory == ''
    elseif a:directory == 'project'
      call CdProjectRoot()
    elseif a:directory == 'buffer_dir'
      execute "lcd" expand("%:p:h")
    else
      execute "lcd" a:directory
    endif

    let l:input = a:input
    if a:input == 'cword'
      let l:input = expand('<cword>')
    endif
    let l:input = "-input=" . escape(l:input, ' ')

    " let l:return = ''
    " if a:input
    "   let l:return = '<cr>'
    " endif

    execute "
          \ :Denite
            \ -buffer-name=denite_" . a:name . "
            \ -mode=normal
            \ -resume
            \ " . l:input . "
            \ " . a:source . "
            \ "

            " Does not work: 
            " \ -auto-preview
endfunction

