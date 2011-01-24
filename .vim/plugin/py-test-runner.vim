" File: py-test-runner.vim
" Author: Marius Gedminas <marius@gedmin.as>
" Version: 0.4
" Last Modified: 2010-10-22
"
" Overview
" --------
" Vim script to run a unit test you're currently editing.
"
" Probably very specific to the way I work (Zope 3 style unit tests).
"
" Installation
" ------------
" Make sure you have pythonhelper.vim installed.  Then copy this file to
" the $HOME/.vim/plugin directory
"
" This plugin most likely requires vim 7.0 (for the string[idx1:idx2] syntax)
"
" Usage
" -----
" :RunTestUnderCursor -- launches the test runner (configured via
" g:pyTestRunner) with :make
"
" :CopyTestUnderCursor -- copies the command line to run the test into the
" X11 selection
"

" These settings are heavily tailored towards zope.testrunner.
" I've also used it with nose and py.test, after changing the settings as
" appropriate.
let g:pyTestRunner = "bin/test"
let g:pyTestRunnerTestFiltering = "-t"
let g:pyTestRunnerTestFilteringClassAndMethodFormat = "{method}"
let g:pyTestRunnerDirectoryFiltering = ""
let g:pyTestRunnerFilenameFiltering = ""
let g:pyTestRunnerPackageFiltering = "-s"
let g:pyTestRunnerModuleFiltering = "-m"
let g:pyTestRunnerClipboardExtras = "-pvc"
let g:pyTestRunnerClipboardExtrasSuffix = "2>&1 |less -R"

runtime plugin/pythonhelper.vim
if !exists("*TagInStatusLine")
    finish
endif

function! GetTestUnderCursor()
    let l:test = ""
    if expand("%:e") == "txt"
        let l:test = g:pyTestRunnerTestFiltering . " " . expand("%:t")
    else
        let l:tag = TagInStatusLine()
        if l:tag != ""
            let l:name = l:tag[1:-2]
            if l:name =~ '[.]'
                let [l:class, l:name] = split(l:name, '[.]')
                let l:name = substitute(substitute(g:pyTestRunnerTestFilteringClassAndMethodFormat, '{class}', l:class, 'g'), '{method}', l:name, 'g')
            endif
            if g:pyTestRunnerTestFiltering != ""
                  \ && l:name != "__init__"
                  \ && l:name != "setUp"
                  \ && l:name != "tearDown"
                  \ && l:name != "testSuite"
                " we assume here that l:test is ""
                let l:test = g:pyTestRunnerTestFiltering . " " . l:name
            endif
        endif
        if g:pyTestRunnerModuleFiltering != ""
            let l:module = expand("%:t:r")
            let l:test = g:pyTestRunnerModuleFiltering . " " . l:module . " " . l:test
        endif
    endif
    if g:pyTestRunnerFilenameFiltering != ""
        let l:filename = expand("%")
        let l:test = g:pyTestRunnerFilenameFiltering . " " . l:filename . " " . l:test
    endif
    if l:test != ""
        if g:pyTestRunnerDirectoryFiltering != ""
            let l:directory = expand("%:h")
            let l:test = g:pyTestRunnerDirectoryFiltering . " " . l:directory . " " . l:test
        endif
        if g:pyTestRunnerPackageFiltering != ""
            let pkg = expand("%:p:h")
            let root = pkg
            while strlen(root)
                if !filereadable(root . "/__init__.py")
                    break
                endif
                let root = fnamemodify(root, ":h")
            endwhile
            let pkg = strpart(pkg, strlen(root))
            let pkg = substitute(pkg, ".py$", "", "")
            let pkg = substitute(pkg, ".__init__$", "", "")
            let pkg = substitute(pkg, "^/", "", "g")
            let pkg = substitute(pkg, "/", ".", "g")
            if pkg != ""
                let l:test = g:pyTestRunnerPackageFiltering . " " . l:pkg . " " . l:test
            endif
        endif
    endif
    let l:test = substitute(l:test, '   *', ' ', 'g')
    let l:test = substitute(l:test, '^  *', '', 'g')
    let l:test = substitute(l:test, '  *$', '', 'g')
    return l:test
endfunction

function! RunTestUnderCursor()
    let l:test = GetTestUnderCursor()
    if l:test != ""
        let l:oldmakeprg = &makeprg
        let &makeprg = g:pyTestRunner
        exec "wall|make " . l:test
        let &makeprg = l:oldmakeprg
    endif
endfunction

command! RunTestUnderCursor	call RunTestUnderCursor()

function! CopyTestUnderCursor()
    let l:test = GetTestUnderCursor()
    if l:test != ""
        let l:cmd = g:pyTestRunner
        if g:pyTestRunnerClipboardExtras != ""
            let l:cmd = l:cmd . " " . g:pyTestRunnerClipboardExtras
        endif
        let l:cmd = l:cmd . " " . l:test
        if g:pyTestRunnerClipboardExtrasSuffix != ""
            let l:cmd = l:cmd . " " . g:pyTestRunnerClipboardExtrasSuffix
        endif
        echo l:cmd
        let @* = l:cmd
    endif
endfunction

command! CopyTestUnderCursor	call CopyTestUnderCursor()
