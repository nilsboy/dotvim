" async completion in pure vim script
" NOTE: endless loop when used with formatoptions and UltiSnips.
" NOTE: delay not working?
" NOTE: does not fuzzy complete?
NeoBundle 'prabirshrestha/asyncomplete.vim'
NeoBundle 'prabirshrestha/async.vim'
NeoBundle 'prabirshrestha/asyncomplete-lsp.vim'

" let g:lsp_async_completion = 1

" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" inoremap <expr> <cr> pumvisible() ? "\<C-y>\<cr>" : "\<cr>"

" autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" let g:asyncomplete_remove_duplicates = 1
set completeopt+=preview

" let g:asyncomplete_force_refresh_on_context_changed = 1

imap <c-space> <Plug>(asyncomplete_force_refresh)

" NeoBundle 'prabirshrestha/asyncomplete-buffer.vim'
" au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
" 	\ 'name': 'buffer',
" 	\ 'priority': 9,
" 	\ 'whitelist': ['*'],
" 	\ 'blacklist': ['go'],
" 	\ 'completor': function('asyncomplete#sources#buffer#completor'),
" 	\ }))

" NeoBundle 'prabirshrestha/asyncomplete-ultisnips.vim'
" " let g:UltiSnipsExpandTrigger="<c-e>"
" au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
" 	\ 'name': 'ultisnips',
" 	\ 'whitelist': ['*'],
" 	\ 'priority': 7,
" 	\ 'completor': function('asyncomplete#sources#ultisnips#completor'),
" 	\ }))

" NeoBundle 'wellle/tmux-complete.vim'
" let g:tmuxcomplete#asyncomplete_source_options = {
" 	\ 'name':      'tmux',
" 	\ 'priority':  1,
" 	\ 'whitelist': ['*'],
" 	\ 'config': {
" 	\     'splitmode':      'words',
" 	\     'filter_prefix':   1,
" 	\     'show_incomplete': 1,
" 	\     'sort_candidates': 0,
" 	\     'scrollback':      0,
" 	\     'truncate':        0,
" 	\     }
" 	\ }

" NeoBundle 'prabirshrestha/asyncomplete-file.vim'
" au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
" 	\ 'name': 'file',
" 	\ 'whitelist': ['*'],
" 	\ 'priority': 2,
" 	\ 'completor': function('asyncomplete#sources#file#completor')
" 	\ }))

" NeoBundle 'yami-beta/asyncomplete-omni.vim'
" au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#omni#get_source_options({
" 	\ 'name': 'omni',
" 	\ 'priority': 1,
" 	\ 'whitelist': ['javascript'],
" 	\ 'blacklist': [],
" 	\ 'completor': function('asyncomplete#sources#omni#completor')
" 	\  }))

