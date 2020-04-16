My vim configuration.

Grep through the source to find more notes.

# Vim tips for beginners

- use touch typing
- use the US keyboard layout - mappings will make much more sense this way
- create snippets for latin etc keys if you need them in vim
- map caps lock to esc key and map alt keys to ctrl keys. in Ubuntu:

```shell
    dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:escape','altwin:ctrl_alt_win']"
```

- don't remap any vim keys that you think you wouldn't use anyway
- only use leader key mapping for your own mappings
- use text-objects (buildin and provided by plugins)
- learn vim script - it's not that bad and it makes vim powerfull

## Inline Help

- Help help :h help-summary
- Default mappings and commands :help index
- :h reference_toc

## Online Help

- https://www.reddit.com/r/vim/
- https://github.com/romainl/idiomatic-vimrc
- https://github.com/mhinz/vim-galore

# Debugging

This setting makes Vim echo the autocommands as it executes them.
`:set verbose=9`

# TODO

- checkout g@
- Backup to git before write?: BufWritePre
- input() history nnoremap q@ :echo input('')<CR><C-F>"
  (https://www.reddit.com/r/vim/comments/4wwkk1/binding_for_input_history/)

# Plugins to checkout

- JavaScript-Context-Coloring
- "Define your own operator easily" (https://github.com/kana/vim-operator-user)
- "Alter built-in Ex commands by your own ones"
  (https://github.com/kana/vim-altercmd) (TAGS: alias)
