runtime! after/ftplugin/javascript.vim

" setlocal iskeyword+=-,.

let b:formatter = 'prettier'
let b:linter = 'eslint'

let b:myrunprg = 'vite-node'
" let b:tester = 'jest'
let b:tester = 'vitest'

let b:outline = '('

let b:outline .= '.*jj.*'

let b:outline .= '|^\s*export\s+\w+'
let b:outline .= '|^\s*interface\s+\w+'
let b:outline .= '|^\s*declare\s+\w+'
let b:outline .= '|^\s*constructor\s*\('

" static async notifyScannerOfNewDomains(order: ProductOrder) {
let b:outline .= '|^\s*(static\s)*(async)*\s*function\s+\w+'

let b:outline .= '|^\s*static\s(async)*\s+\w+'

" async method(arg: type): returnType {
" async find(req, query) {
" let b:outline .= '|^\s*(async)*\s*(?!if)\w+\s*\([\w+\:\s]*\)*.*\{'

let b:outline .= '|^\s*(async)*\s*describe\s*\('
let b:outline .= '|^\s*(async)*\s*before\w+\s*\('
let b:outline .= '|^\s*(async)*\s*after\w+\s*\('
let b:outline .= '|^\s*(async)*\s*test\s*\('
let b:outline .= '|^\s*(async)*\s*it\s*\('

" buildService(
let b:outline .= '|^\s\s(async\s+)*\w+\($'

" async api(app) {
  " async findAll(query: FindAllQueryDto){
let b:outline .= '|^\s+(async\s+)*\w+\(.*?\)\s*.*\{$'

" async api(app) : Set<string> {
let b:outline .= '|^\s\s(async\s+)*\w+\(.*?\)[\s\w\<\>\:]+{$'

let b:outline .= ')'

nnoremap <silent> <buffer> <leader>es :silent call MyShrinkShrink({
      \ 'start': 'html`',
      \ 'end': '^\\s*`$',
      \ 'filetype': 'html',
      \ })<cr>

nnoremap <silent> <buffer> <leader>lw :silent call MakeWith({'name': 'tsc', 'compiler': 'tsc'})<cr>
nnoremap <silent> <buffer> <leader>lo :call CocActionAsync('runCommand', 'editor.action.organizeImport')<cr>

function! typescript#cleanMongo()
  %s/ISODate/new Date/g
  g/_id: ObjectId/d 
endfunction
