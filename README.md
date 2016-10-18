My vim configuration.

# Notes

## Inline Help
- Help help
:h help-summary
- Default mappings and commands
:help index
- :h reference_toc

## Online Help
- https://www.reddit.com/r/vim/
- https://github.com/mhinz/vim-galore

## VimL Helper Libraries
- l9.vim
- https://github.com/LucHermitte/lh-vim-lib
- tomtom/tlib_vim

## Debugging
This setting makes Vim echo the autocommands as it executes them.
  `:set verbose=9`

## Plugins to checkout
- vim-es6
- vimagit
- diffchar.vim
- quick-scope
- ctrlsf.vim " Grep with edit in-place
- Vdebug
- vim-qlist show :ilist searches in qickfix window
- JavaScript-Context-Coloring
- incsearch.vim
- "Define your own operator easily" (https://github.com/kana/vim-operator-user)
- "Alter built-in Ex commands by your own ones" (https://github.com/kana/vim-altercmd)
- A lot of interesting stuff: https://github.com/kana
- https://github.com/idbrii/vim-renamer

## TODO
- use external perl for inline search
- set $XDG_CACHE_DIR from remote_home for neomru etc?
- check preview-window
- RNB, a Vim colorscheme template
  (https://gist.github.com/romainl/5cd2f4ec222805f49eca)
- Backup to git before write?: BufWritePre
- input() history nnoremap q@ :echo input('')<CR><C-F>" (https://www.reddit.com/r/vim/comments/4wwkk1/binding_for_input_history/)
- spell inside of comments and txt files - camel case / snail case
