" Title:         Vim Code Runner
" Author:        Wang Xianzhong   wxz1120339073@gmail.com
"                Brian Orwe       brian.orwe@gmail.com
"
" Goal:          Run code snippets more conveniently
"
" License:       Public domain, no restrictions whatsoever
" Documentation: type ":help CodeRunner"
"
" Version:       1.0
if get(g:, 'vim_code_runner', 0)
  finish
endif

let g:CodeRunnerSourceFile=expand("<sfile>")

if !exists("g:code_runner_save_before_execute")
    let g:code_runner_save_before_execute = 0
endif
if !exists("g:code_runner_output_window_size")
    let g:code_runner_output_window_size = 15
endif


command! -complete=custom,CodeRunner#GetTypes -nargs=? CodeRunner :call CodeRunner#CodeRunner("<args>")

""nnoremap <silent> <plug>CodeRunner :call CodeRunner#CodeRunner()<CR>
""if !hasmapto("<Plug>CodeRunner")
""    nmap <silent><leader>B <Plug>CodeRunner
""endif


let g:vim_code_runner = 1
