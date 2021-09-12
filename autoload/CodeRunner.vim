" Ouput Message {{{
function! CodeRunner#Error(message)
    echohl ErrorMsg | echomsg "[CodeRunner] Error: ".a:message | echohl None
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
