" faq
:h vim-faq

" Own mappings
:execute ':e ' . MY_VIM . "/plugin/tinykeymap.vim"

" Helpers
:execute ':e ' . MY_VIM . "/plugin/helpers.vim"

" Vim environment
:call VimEnvironment()

" View default mappings and commands
:help index

" Edit vimrc
:execute ':e ' . MY_VIM_RC

" Reload vimrc
:execute 'source ' . MY_VIM_RC

:h functions
:h file-searching

:h reference_toc

" command-line.  You can use "%<" to insert the current file name without
" IMPROVING BROWSING			
:h netrw-ssh-hack

" Scripting helpers
:edit /home/nilsb/.vim/bundle/l9/autoload/l9.vim
" lh-vim-lib: https://github.com/LucHermitte/lh-vim-lib

" TODO
" - remove trailing space
" - 'equalprg' 'ep' string (default "")
" - https://metacpan.org/release/Perl-Tags
" - https://github.com/tomtom/trag_vim
" - Snipmate: http://www.vim.org/scripts/script.php?script_id=2540
" - setl - show all 
"   Without argument: Display local values for all local
"   options which are different from the default.
" - set $XDG_CACHE_DIR from remote_home for neomru etc?
" - check preview-window
" - RNB, a Vim colorscheme template
"   (https://gist.github.com/romainl/5cd2f4ec222805f49eca)
"   Backup to git before write?: BufWritePre

" While testing autocommands, you might find the 'verbose' option to be useful: >
" 	:set verbose=9
" This setting makes Vim echo the autocommands as it executes them.
