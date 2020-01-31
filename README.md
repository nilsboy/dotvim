My vim configuration.

Grep through the source to find more notes.

# Notes

## Tips for vim beginners

* use touch typing
* use the US keyboard layout - mappings will make much more sense this way
* create snippets for latin etc keys if you need them in vim
* map caps lock to esc key and map alt keys to ctrl keys. in Ubuntu:

```shell
    dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:escape','altwin:ctrl_alt_win']"
```

* don't remap any vim keys that you think you wouldn't use anyway
* only use leader key mapping for your own mappings
* use text-objects (buildin and provided by plugins)
* learn vim script - it's not that bad and it makes vim powerfull

## Inline Help

* Help help :h help-summary
* Default mappings and commands :help index
* :h reference_toc

## Online Help

* https://www.reddit.com/r/vim/
* https://github.com/romainl/idiomatic-vimrc
* https://github.com/mhinz/vim-galore

## Debugging

This setting makes Vim echo the autocommands as it executes them.
`:set verbose=9`


### Start with only one plugin enable
`vim -u NORC -N +":set runtimepath+=~/path/to/vim-sneak/" +":runtime plugin/sneak.vim"`

## Naming conventions (WIP)

Goal: Use one consistent style for all identifiers.

Using non-global functions and variables is harder to debug and has no real
benefit. Sometimes it might even be nice for a user to be able to use a
non-offical function as a workaround.

### Vim restrictions

* variable names must not include a # (like functions can) - false?
* function names must not include "-" (so using the plugin filename directly is
  not always possible)
* function names must start with an upper case letter
* commands must start with an uppercase letter. Rest can be uppercase letters,
  lowercase letters or digits.
* augroup names must not contain space
> TODO: autoload is only possible for the script#function naming

### Result

* use camelcase for all identifiers
* make all identifiers global
* use "My"-prefix on all identifiers
* local plugin file names: my\_{{plugin_name}}.vim
* local and public plugin config file names: my\_{{plugin_name}}\_config.vim
* remove "My"-prefix when converting to a public plugin

#### Deprecated

* replace "-" in script names with "\_" for vars etc
* function names: Scriptfile_name_functionName (= global)
* var names: g:Scriptfile_name_varName (= global)
* commands: My{{Scriptfile_name}}CommandName
* forece my prefix in snippets even if file has none (jet)?
* TODO: normalize plugin config file names to exclude vim and '-' etc?

## TODO

* checkout g@
* Backup to git before write?: BufWritePre
* input() history nnoremap q@ :echo input('')<CR><C-F>"
  (https://www.reddit.com/r/vim/comments/4wwkk1/binding_for_input_history/)

### Plugins to checkout

* https://github.com/wellle/context.vim
* JavaScript-Context-Coloring
* "Define your own operator easily" (https://github.com/kana/vim-operator-user)
* "Alter built-in Ex commands by your own ones"
  (https://github.com/kana/vim-altercmd) (TAGS: alias)
