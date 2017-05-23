My vim configuration.

Grep through the source to find more notes.

# Notes

## Tips for vim beginners
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

## Naming conventions (WIP)

Use one consistent style for everything.

Using non-global functions and vars is harder to debug and has no real benefit.
Sometimes it might even be nice for a user to be able to use a non-offical function as a workaround.

### Vim restrictions

- vars can not include a # like functions - so not using this for functions ether
- functions must not contain "-" and other characters - so using the script filename directly is not always possible
- functions must start with a upper case letter - so using this for vars too
- TODO: commands / autocmds?

### Result

- prefix own files with my_
- plugin config file names: my_{{plugin_name}}_config.vim
- own plugin file names: my_{{plugin_name}}.vim
- only one my_-prefix for own plugin configs
- replace "-" in script names with "_"

- function names: Scriptfile_function (= global)
- var names: g:Scriptfile_varname (= global)

- TODO: normalize plugin config file names to exclude vim and '-' etc?

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
- "async language server protocol plugin for vim and neovim"
  (https://github.com/prabirshrestha/vim-lsp)
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

