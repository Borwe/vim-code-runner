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

let g:CodeRunnerSourceFile=expand("<sfile>")

if !exists("g:code_runner_save_before_execute")
    let g:code_runner_save_before_execute = 0
endif
if !exists("g:code_runner_output_window_size")
    let g:code_runner_output_window_size = 15
endif



command! CodeRunner :call CodeRunner#CodeRunner()

nnoremap <silent> <plug>CodeRunner :call CodeRunner#CodeRunner()<CR>
if !hasmapto("<Plug>CodeRunner")
    nmap <silent><leader>B <Plug>CodeRunner
endif

