" A code-completion engine for Vim
NeoBundle 'Valloric/YouCompleteMe', {
    \ 'build': {
    \ 'unix': './install.py --tern-completer'
    \ }
\ }
" sudo does not seem to work with NeoBundle
    " \ 'unix': 'sudo apt-get install cmake python-dev && ./install.py --tern-completer'

" Needs .tern-project file in pwd to use working paths

" - You can use Ctrl+Space to trigger the completion suggestions anywhere, even
"   without a string prefix. This is useful to see which top-level functions
"   are available for use.
  
" let g:ycm_min_num_identifier_candidate_chars = 0
let g:ycm_min_num_of_chars_for_completion = 2

nnoremap <leader>li :YcmCompleter GoToDefinition<CR>
nnoremap <leader>lf :YcmCompleter GoTo<CR>
nnoremap <leader>lr :YcmCompleter GoToReferences<CR>
nnoremap <leader>lt :YcmCompleter GetType<CR>
nnoremap <leader>ld :YcmCompleter GetDoc<CR>
nnoremap <leader>lR :YcmCompleter RefactorRename 

" Let unite handle the quickfix list see unite config
autocmd User YcmQuickFixOpened echo

let g:ycm_allow_changing_updatetime = 0
let g:ycm_complete_in_comments = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
" let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_add_preview_to_completeopt = 1
" let g:ycm_autoclose_preview_window_after_completion = 1
" let g:ycm_autoclose_preview_window_after_insertion = 1
" let g:ycm_key_list_select_completion = ['<TAB>', '<Enter>']
" TODO
" let g:ycm_key_list_previous_completion = ['<S-TAB>', '<space>']

" let g:ycm_key_invoke_completion = ',,'
let g:ycm_key_detailed_diagnostics = ''
" let g:ycm_disable_for_files_larger_than_kb = 1000
