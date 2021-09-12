

function! CodeRunner#Error(message) abort
    echohl ErrorMsg | echomsg "[CodeRunner] Error: ".a:message | echohl None
endfunction


function! CodeRunner#Message(message) abort
    echomsg "[CodeRunner] : ".a:message
endfunction


function! CodeRunner#Warning(message) abort
    echohl WarningMsg | echomsg "[CodeRunner] Warning: ".a:message | echohl None
endfunction


function! CodeRunner#BackToForwardSlash(arg) abort
    return substitute(a:arg, '\\', '/', 'g')
endfunction


function! CodeRunner#GetShell() abort
    if has('win32')
        return &shell." /c "
    else
        return &shell." -c"
    endif
endfunction


function! CodeRunner#GetCommand(type) abort
    let cmdMaps = CodeRunner#ParseCommandAssociationList()
    if has_key(cmdMaps, a:type)
        let strCmd = cmdMaps[a:type]
    else
        return ''
    endif

    " Replace variables
    let dirPath = expand('%:h') . '/'
    let fileNameWithoutExt = expand('%:t:r')
    let fileName = expand('%:t')

    " Change to current directory if not given
    if strCmd !~ 'cd $dir'
        let strCmd = 'cd $dir && ' . strCmd
    endif

    let strCmd = substitute(strCmd, '$fileNameWithoutExt',fileNameWithoutExt,'gC')
    let strCmd = substitute(strCmd, '$fileName',fileName,'gC')
    let strCmd = substitute(strCmd, '$dir', dirPath,'gC')

    return strCmd
endfunction


function! CodeRunner#GetCommandConfigFile() abort
    let sawError = 0
    if exists("g:code_runner_command_config_file")
        if filereadable(g:code_runner_command_config_file)
            return g:code_runner_command_config_file
        endif
        let sawError = 1
        call CodeRunner#Error("The file specified by g:code_runner_command_config_file = " .
                    \ g:code_runner_command_config_file . " cannot be read.")
        call CodeRunner#Error("Attempting to look for 'CodeRunnerCommandAssociations' in other locations.")
    endif

    let nextToSource = fnamemodify(g:CodeRunnerSourceFile, ":h")."/CodeRunnerCommandAssociations"
    if filereadable(nextToSource)
        let l:CodeRunnerCommandConfigFile = nextToSource
    else
        let VimfilesDirs = split(&runtimepath, ',')
        for v in VimfilesDirs
            let cfgFilePath = CodeRunner#BackToForwardSlash(v)."/plugin/CodeRunnerCommandAssociations"
            if filereadable(cfgFilePath)
                let l:CodeRunnerCommandConfigFile = cfgFilePath
            endif
        endfor
    endif

    if empty(l:CodeRunnerCommandConfigFile)
        let l:CodeRunnerCommandConfigFile = ""
    elseif sawError
        call CodeRunner#Error("    Found at: ".l:CodeRunnerCommandConfigFile)
        call CodeRunner#Error("    Please fix your configuration to suppress these messages!")
    endif
    return l:CodeRunnerCommandConfigFile
endfunction


function! CodeRunner#ParseCommandAssociationList() abort
    if exists("s:Dict")
        return s:Dict
    endif
    let s:Dict = {}
    if exists('g:CodeRunnerCommandMap')
        for key in keys(g:CodeRunnerCommandMap)
            let s:Dict[key] = trim(g:CodeRunnerCommandMap[key])
        endfor
    endif
    let filePath = CodeRunner#GetCommandConfigFile()

    if empty(filePath)
        call CodeRunenr#Error("Code Runner Command config file not exists!")
        return
    endif

    if !filereadable(filePath)
        call CodeRunner#Error("Code Runner config file can't be read!")
        return
    endif

    let strLines = readfile(filePath)

    let lineCounter = 0
    for strLine in strLines
        let lineCounter += 1
        let strLine = trim(strLine)
        if empty(strLine) || strLine[0] == "\""
            continue
        endif

        let items = split(strLine, "::")
        if len(items) != 2
            call CodeRunner#Warning("Invalid strLine: ".strLine)
            continue
        endif

        let sourceType = trim(items[0])
        let exeCommand = trim(items[1])

        if empty(sourceType) || empty(exeCommand)
            call CodeRunner#Warning("Invalid strLine: ".strLine)
            continue
        endif
        if !has_key(s:Dict, sourceType)
            let s:Dict[sourceType] = exeCommand
        endif
    endfor
    if lineCounter == 0
        call CodeRunner#Warning("Code Runner config is empty!")
        return
    endif

    return s:Dict
endfunction


function! CodeRunner#CodeRunner() abort
    if g:code_runner_save_before_execute == 1
        write
    endif
    let cmd = CodeRunner#GetCommand(&ft)
    if empty(cmd)
        call CodeRunner#Error("Unknow File Type: " . &ft . "!")
        return
    endif

    call CodeRunner#Message("Running ".cmd)

    let winName = "CodeRunner.out"
    let options= {"cwd":getcwd(),"term_rows":g:code_runner_output_window_size, "term_name":winName}
    let term_window = term_start(CodeRunner#GetShell().cmd,options)
endfunction
