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

## Debugging
This setting makes Vim echo the autocommands as it executes them.
  `:set verbose=9`

## Plugins to checkout
- vim-es6
- vimagit
- diffchar.vim
- ctrlsf.vim " Grep with edit in-place
- Vdebug
- vim-qlist show :ilist searches in qickfix window
- JavaScript-Context-Coloring
- incsearch.vim
- "Define your own operator easily" (https://github.com/kana/vim-operator-user)
- "Alter built-in Ex commands by your own ones" (https://github.com/kana/vim-altercmd)
- A lot of interesting stuff: https://github.com/kana
- https://github.com/idbrii/vim-renamer

# Vim bugs
- Messes with preview window: /usr/share/nvim/runtime/syntax/man.vim

## TODO
- :h runtime for directory structure
- Backup to git before write?: BufWritePre
- input() history nnoremap q@ :echo input('')<CR><C-F>" (https://www.reddit.com/r/vim/comments/4wwkk1/binding_for_input_history/)
- spell inside of comments and txt files - camel case / snail case
