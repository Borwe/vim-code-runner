" Ouput Message {{{
function! CodeRunner#Error(message)
    echohl ErrorMsg | echomsg "[CodeRunner] Error: ".a:message | echohl None
endfunction
function! CodeRunner#Message(message)
    echomsg "[CodeRunner] Message: ".a:message
endfunction
function! CodeRunner#Warning(message)
    echohl WarningMsg | echomsg "[CodeRunner] Warning: ".a:message | echohl None
endfunction
"}}}
" BackToForwardSlash {{{
function! CodeRunner#BackToForwardSlash(arg)
    return substitute(a:arg, '\\', '/', 'g')
endfunction
"}}}
" GetCommand {{{
function! CodeRunner#GetShell() abort
    if has('win32')
        return &shell." /c "
    else
        return &shell." -c"
    endif
endfunction
"}}}
