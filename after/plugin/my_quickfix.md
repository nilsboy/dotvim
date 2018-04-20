# Use for: linting, makeing, testing, formatting, finding stuff

## TODO

* parse command output by regex
* require runners to supply a standard output? (move parsing logic to runner
  script)
* use jobs api - implies not using makeprg?
* word with boundaries search
* and search ignoring order of search words
* checkout quickfixsigns for resetting the signes on :colder etc
* use winsaveview to prevent window resizing on copen
* always close buffer of preview window - is there a plugin for that?
* add description to quickfix window title
* don't jump if the current quickfix entry is invalid
* operator for searching
* stacktrace vs error message line

## Help

* :Man scanf
* :h quickfix
* :h errorformat
* :h :signs for the gutter

## Why not :make, &errorformat, :compiler

* makeprg and errorformat together are flawed
  (https://github.com/vim-syntastic/syntastic/issues/699#issuecomment-248517315)
* :compiler is only meant to be used for one tool per buffer at a time - it is
  not possible to have several commands e.g. linter, finder, formatter
* :compiler doesn't scale:
  https://github.com/LucHermitte/vim-build-tools-wrapper/blob/master/doc/filter.md
* :make has trouble quoting filenames. (read some where... - Syntactic creater?)
* makeprg and errorformat are ether local or global but if you want to run
  something different than the default with make those vars have to be saved and
  restored

## Generic Runners

* make (builtin)
  * synchronous
  * TODO: set makeef
* neomake
  * stdin possible with neomake-autolint?
  * does mess with &makeprg / &errorformat and does not respect buffer local
  * only used it as regular make - makes no difference to buildin :make versions
    of those?
  * SEE ALSO: neomake-multiprocess
* vim-erroneous (https://github.com/idanarye/vim-erroneous)
  * chooses errorformat by run command
  * needs Ruby to suppress command output
  * no jobs support?
* vim-makejob
  * no stdin support - add maybe?
  * uses makeprg and errorformat
* asyncrun 500+ github stars
  * has no sensible solution for setting &errorformat (2018-03-13)
* vimmake
  * https://github.com/skywind3000/vimmake
  * no errorformat support (2018-03-13)

## Quickfix helpers

* async.vim - normalize async job control api for vim and neovim:
  * https://github.com/prabirshrestha/async.vim
* vim-qf
* vim-dispatch
  * no job-api support
* https://github.com/mh21/errormarker.vim
* vim-makery for managing your makeprgs:
  * https://github.com/igemnace/vim-makery
* edit files in quickfix window:
  https://github.com/stefandtw/quickfix-reflector.vim
* Highlight quickfix errors https://github.com/jceb/vim-hier
* format quickfix output: https://github.com/MarcWeber/vim-addon-qf-layout

## Single purpose plugins

* vim-test
  * uses vim-dispatch
* ale
  * not a generic runner (linting and formatting?)
* autoformat
  * does not have a lot of preconfigured formatters
* vim-grepper
  * GOOD: has an operator

## Quickfix list tips

* every line of output from makeprg is listed as an error
* lines that match errorformat get a valid = 1 in the getqflist()
* get count of actual errors: len(filter(getqflist(), 'v:val.valid'))
* List all defined signs and their attributes: `:sign list`
* List placed signs in all files: `:sign place`
* Clear quickfix: `:cex[]`

## For errorformat debugging

* :h neomake: section: 6.3 How to develop/debug the errorformat setting?
* To send to stdin see: :h jobsend()
