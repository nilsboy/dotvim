syntax clear

" set syntax=text
" syntax clear txtError

syntax case ignore

syntax match Error "error\:"
syntax match Error "error>"
syntax match Error "exception\:"

" " syntax match WarningMsg /\S* jj\d\+.*/
" syntax match MoreMsg /#\+.*/
" syntax match MoreMsg /info >.*/

syntax match WarningMsg /warn\s*>.*/

syntax match Comment /debug>.*/
syntax match Comment /['`"].*['`"]/

" TODO: integrate into errorformatregex to output prefix for non interesting lines
syntax match Comment /at.*\(node\:.*\)/
syntax match Comment /at.*\(.*node_modules.*\)/
syntax match Comment /at.*\(<anonymous>\)/

" " A bunch of useful C keywords
" syn match	qfFileName	"^[^|]*" nextgroup=qfSeparator
" syn match	qfSeparator	"|" nextgroup=qfLineNr contained
" syn match	qfLineNr	"[^|]*" contained contains=qfError
" syn match	qfError		"error" contained

" " The default highlighting.
" hi def link qfFileName	Directory
" hi def link qfLineNr	LineNr
" hi def link qfError	Error

let b:current_syntax = "qf"
