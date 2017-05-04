My vim configuration.

Grep through the source to find more notes.

# Notes

## Tips for vim beginners
- use touch typing
- use the US keyboard layout - mappings will make much more sense this way
- create snippets for latin etc keys if you need them in vim
- map caps lock to esc key
- map alt keys to ctrl keys
- don't remap any vim keys that you think you wouldn't use anyway
- only use leader key mapping for your own mappings
- use text-objects (buildin and provided by plugins)
- learn vim script - it's ugly but makes vim powerfull

## Inline Help
- Help help :h help-summary
- Default mappings and commands
  :help index
- :h reference_toc

## Online Help
- https://www.reddit.com/r/vim/
- https://github.com/mhinz/vim-galore

## Debugging
This setting makes Vim echo the autocommands as it executes them.
  `:set verbose=9`

## TODO
- give tags another try?: https://www.reddit.com/r/vim/comments/65vnrq/coworkers_criticize_my_workflow_for_lacking/?st=j1n9przw&sh=a9a4a220
- checkout g@
- checkout Titlecase plugin
- see `:h runtime` for directory structure
- Backup to git before write?: BufWritePre
- input() history nnoremap q@ :echo input('')<CR><C-F>"
  (https://www.reddit.com/r/vim/comments/4wwkk1/binding_for_input_history/)
- spell inside of comments and txt files - camel case / snail case

### Plugins to checkout
- https://github.com/mattboehm/vim-unstack
  (for the parsing code see: https://github.com/mattboehm/vim-unstack/blob/master/autoload/unstack/extractors.vim)
- vim-es6
- vimagit
- diffchar.vim
- ctrlsf.vim " Grep with edit in-place
- Vdebug
- JavaScript-Context-Coloring
- "Define your own operator easily" (https://github.com/kana/vim-operator-user)
- "Alter built-in Ex commands by your own ones" (https://github.com/kana/vim-altercmd) (TAGS: alias)
- A lot of interesting stuff: https://github.com/kana
- https://github.com/idbrii/vim-renamer

