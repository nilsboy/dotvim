" faq
:h vim-faq
:h help-summary

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
" - lh-vim-lib: https://github.com/LucHermitte/lh-vim-lib
" - utility functions: tomtom/tlib_vim

"   HELP
" - https://github.com/mhinz/vim-galore

TODO
- always show vimgutter
- BufNewFile    When starting to edit a file that doesn't
                exist.  Can be used to read in a skeleton
                file.
" - use external perl for inline search
" - remove trailing space
" - 'equalprg' 'ep' string (default "")
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
"   :set verbose=9
" This setting makes Vim echo the autocommands as it executes them.
"
" Plugins to checkout:
" - vim-es6
" - vimagit
" - diffchar.vim
" - quick-scope
" - ctrlsf.vim " Grep with edit in-place
" - Vdebug
" - vim-qlist show :ilist searches in qickfix window
" - JavaScript-Context-Coloring
" - incsearch.vim
" - "Define your own operator easily" (https://github.com/kana/vim-operator-user)
" - Alter built-in Ex commands by your own ones" (https://github.com/kana/vim-altercmd)
" - A lot of interesting stuff: https://github.com/kana
