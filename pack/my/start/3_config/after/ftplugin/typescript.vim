runtime! after/ftplugin/javascript.vim

let b:myrunprg = 'ts-node'
let b:tester = 'jest'

let b:outline = '('

let b:outline .= '.*jj.*'

let b:outline .= '|^\s*export\s+\w+'
let b:outline .= '|^\s*interface\s+\w+'
let b:outline .= '|^\s*declare\s+\w+'
let b:outline .= '|^\s*constructor\s*\('
let b:outline .= '|^\s*(async)*\s*function\s+\w+'

" async method(arg: type): returnType {
" async find(req, query) {
let b:outline .= '|^\s*(async)*\s*(?!if)\w+\s*\([\w+\:\s]*\)*.*\{'

let b:outline .= '|^\s*(async)*\s*describe\s*\('
let b:outline .= '|^\s*(async)*\s*before\w+\s*\('
let b:outline .= '|^\s*(async)*\s*after\w+\s*\('
let b:outline .= '|^\s*(async)*\s*test\s*\('

let b:outline .= ')'

nnoremap <silent> <leader>lw :silent call MakeWith({'name': 'tsc', 'compiler': 'tsc'})<cr>
" TODO: replace with this - faster! (lua):
" fn.CocActionAsync('diagnosticList', '', function(err, res)
"        if err == vim.NIL then
"            local items = {}
"            for _, d in ipairs(res) do
"                local text = ('[%s%s] %s'):format((d.source == '' and 'coc.nvim' or d.source),
"                    (d.code == vim.NIL and '' or ' ' .. d.code), d.message:match('([^\n]+)\n*'))
"                local item = {
"                    filename = d.file,
"                    lnum = d.lnum,
"                    end_lnum = d.end_lnum,
"                    col = d.col,
"                    end_col = d.end_col,
"                    text = text,
"                    type = d.severity
"                }
"                table.insert(items, item)
"            end
"            fn.setqflist({}, ' ', {title = 'CocDiagnosticList', items = items})

