" If you add new plugins, install them with::
"
"     make vimpire
"
" using https://bitbucket.org/sirex/home Makefile

" Pathogen is responsible for vim's runtimepath management.
call pathogen#infect()

" Allow custom settings for different file types.
if v:version >= 600
  filetype plugin on            " load filetype plugins
  filetype indent on            " load indent plugins
endif


function! ToggleNERDTreeAndTagbar()
    " Detect which plugins are open
    if exists('t:NERDTreeBufName')
        let nerdtree_open = bufwinnr(t:NERDTreeBufName) != -1
        let nerdtree_window = bufwinnr(t:NERDTreeBufName)
    else
        let nerdtree_open = 0
        let nerdtree_window = -1
    endif
    let tagbar_open = bufwinnr('__Tagbar__') != -1
    let tagbar_window = bufwinnr('__Tagbar__')
    let current_window = winnr()

    " Perform the appropriate action
    if nerdtree_open && tagbar_open
        NERDTreeFind
    elseif nerdtree_open && current_window == nerdtree_window
        NERDTreeToggle
        TagbarOpen
        execute bufwinnr('__Tagbar__') . 'wincmd w'
    elseif nerdtree_open
        NERDTreeFind
    elseif tagbar_open && current_window == tagbar_window
        TagbarClose
        NERDTreeToggle
        execute bufwinnr(t:NERDTreeBufName) . 'wincmd w'
    elseif tagbar_open
        TagbarShowTag
        execute bufwinnr('__Tagbar__') . 'wincmd w'
    else
        NERDTreeFind
    endif
endfunction

function! GetBufferList()
  redir =>buflist
  silent! ls
  redir END
  return buflist
endfunction

function! ToggleList(bufname, pfx)
  let buflist = GetBufferList()
  for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(bufnum) != -1
      exec(a:pfx.'close')
      return
    endif
  endfor
  if a:pfx == 'l' && len(getloclist(0)) == 0
      echohl ErrorMsg
      echo "Location List is Empty."
      return
  endif
  let winnr = winnr()
  exec('botright '.a:pfx.'open')
  if winnr() != winnr
    wincmd p
  endif
endfunction


" Mappings
let mapleader = ","
nmap    <F1>        :Gstatus<CR>
nmap    <F2>        :update<CR>
imap    <F2>        <ESC>:update<CR>a
nmap    <F3>        :BufExplorer<CR>
nmap    <F4>        :call ToggleNERDTreeAndTagbar()<CR>
nmap    <F5>        :cnext<CR>
nmap    <S-F5>      :cprevious<CR>
nmap    <C-F5>      :cc<CR>
vmap    <F6>        <ESC>:exec "'<,'>w !vpaste ".&ft<CR>
nmap    <F7>        :call ToggleList("Quickfix List", 'c')<CR>
nmap    <F8>        :silent make!<CR>
nmap    <F11>       :set hlsearch!<CR>
nmap    <F12>       :setlocal spell!<CR>
nmap    <SPACE>     ^

" Jump between windows and tabs.
nmap    <TAB>       <C-W>p
nmap    <S-TAB>     <C-W>w
nmap    <M-k>       <C-W>k
nmap    <M-j>       <C-W>j
nmap    <M-l>       <C-W>l
nmap    <M-h>       <C-W>h
nmap    <M-1>       1gt
nmap    <M-2>       2gt
nmap    <M-3>       3gt
nmap    <M-4>       4gt
nmap    <M-5>       5gt
nmap    <M-6>       6gt
nmap    <M-7>       7gt
nmap    <M-8>       8gt
nmap    <M-9>       9gt
nmap    to          :tabedit %<CR>
nmap    tc          :tabclose %<CR>
nmap    tt          :tabnew \| tjump <C-R><C-W><CR>
nmap    tj          gT
nmap    tk          gt
nmap    th          :tabfirst<CR>
nmap    tl          :tablast<CR>

" Quick search for python class and def statments.
nmap    c/          /\<class 
nmap    m/          /\<def 

" Jump to tag in split window
nmap    g}              :stselect <c-r><c-w><cr>

" Scroll half page down
nn <c-j> <c-d>
" Scroll half page up
nn <c-k> <c-u>

" Scroll half screen to left and right vertically
no <s-h> zH
no <s-l> zL

" Autocomplete
ino <c-k> <c-p>
ino <c-j> <c-n>
" Scan only opened buffers and current file, makes autocompletion faster.
set complete=.,w,b,u

" Digraphs
ino <c-d> <c-k>

" Helpers to open files in same directory as current or previous file, more
" quickly
nmap <leader>r :e <c-r>=expand("%:h")<CR>/<c-d>
nmap <leader>R :e <c-r>=expand("#:h")<CR>/<c-d>

" Emacs style command line
cnoremap        <C-G>           <C-C>
cnoremap        <C-A>           <Home>
cnoremap        <Esc>b          <S-Left>
cnoremap        <Esc>f          <S-Right>

" Alt-Backspace deletes word backwards
cnoremap        <M-BS>          <C-W>

" Look and feel.
colorscheme desert
set background=dark
set guifont=Terminus\ 12
set guioptions=irL
set number
set wildmenu
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,windows-1257
set foldmethod=marker
set foldlevel=20
set showcmd     " Show count of selected lines or characters
set shell=/bin/sh

" Text wrapping
set textwidth=79
set linebreak

" Spelling
set spelllang=lt,en

" Cursor movement behaviour
set scrolloff=2
set nostartofline

" Search
set ignorecase
set incsearch
set nohlsearch

" Tabs
set expandtab
set tabstop=8
set softtabstop=4
set shiftwidth=4

" Indenting
set autoindent
set nosmartindent

" Tags
set tags=./tags,./../tags,./../../tags,tags

" Ignores
set suffixes+=.pyc,.pyo
set wildignore+=*.pyc,*.pyo
let g:netrw_list_hide='\.\(pyc\|pyo\)$'

" Backups
if v:version >= 730
    " Backups are not needed, since persistent undo is enabled. Also, these days
    " everyone uses version control systems.
    set nobackup
    set writebackup
    set undodir=~/.vim/var/undo
    set undofile
else
    set backup
    set backupdir=~/.vim/var/backup
endif
set directory=~/.vim/var/swap

" Python tracebacks (unittest + doctest output)
set errorformat=\ %#File\ \"%f\"\\,\ line\ %l\\,\ %m
set errorformat+=\@File\:\ %f
set errorformat+=%f:%l:\ [%t]%m,%f:%l:%m

" Set python input/output encoding to UTF-8.
let $PYTHONIOENCODING = 'utf_8'

" Get ride of annoying parenthesis matching, I prefer to use %.
let loaded_matchparen = 1

" Disable A tag underlining
let html_no_rendering = 1

" Grep
" Do recursive grep by default and do not grep binary files.
set grepprg=~/bin/ack-grep\ -H\ --nocolor\ --nogroup\ --smart-case
function! SilentGrep(args)
    execute "silent! grep! " . a:args
    botright copen
endfunction
command! -nargs=* -complete=file G call SilentGrep(<q-args>)
nmap <leader>gg :G 
nmap <leader>gG :G <c-r><c-w>
vmap <leader>gg y:G "<c-r>""<left>
nmap <leader>gf :G <c-r>%<home><c-right> 
nmap <leader>gF :G <c-r>%<home><c-right> <c-r><c-w>
vmap <leader>gf y:G <c-r>%<home><c-right> "<c-r>""<left>

" Find
function! Find(args)
    execute "cgetexpr system('ack-grep --nocolor --nogroup --smart-case -g " . a:args . " \\\| sed ''s/^/@File: /''')"
    botright copen
endfunction
command! -nargs=* -complete=file F call Find(<q-args>)

" GNU id-utils
function! IDSearch(args)
    let grepprg = &grepprg
    set grepprg=gid
    execute "silent! grep! " . a:args
    botright copen
    execute "set grepprg=" . escape(grepprg, " ")
endfun
command! -nargs=* -complete=file ID call IDSearch(<q-args>)
nmap <leader>gi :ID
nmap <leader>gI :ID <c-r><c-w>


" Execute selected vim script.
vmap <leader>x y:@"<CR>


function! Browser()
"    let line = getline(".")
"    let line = matchstr(line, "\%(http://\|www\.\)[^ ,;\t\n\r]*")

    let uri = matchstr(getline("."), '[a-z]*:\/\/[^ >,;]*')
    echo uri
    if uri != ""
        exec ":silent !firefox \"" . uri . "\""
    else
        echo "No URI found in line."
    endif
endfunction
map <Leader>w :call Browser()<CR>


" Diff
" Open diff window with diff for all files in current directory.
function! FullDiff()
  execute "edit " . getcwd()
  execute "VCSDiff"
endfunction
map <leader>d :call FullDiff()<CR>

" Jump to line in source code from diff output.
"
" This script is found in:
" http://vim.wikia.com/wiki/Jump_to_file_from_CVSDiff_output
"
" Also check this script:
" http://www.vim.org/scripts/script.php?script_id=3892
function! DiffJumpToFile()
 " current line number
  let current_line = line(".")

 " search for line like @@ 478,489 @@
  let diff_line = search('^\(---\|\*\*\*\|@@\) ', 'b')

 " get first number from line like @@ -478,8 +489,12 @@
  let chunk = getline(diff_line)

  " get the first line number (478) from that string
  let source_line = split(chunk, '[-+, ]\+')[3]

  " calculate real source line with offset taken from cursor position
  let source_line = source_line + current_line - diff_line - 1

  " search for and get line like *** fileincvs.c ....
  let chunk = getline(search("^\\(---\\|\\*\\*\\*\\) [^\\S]\\+", "b"))

  " get filename (terminated by tab) in string
  let filename = strpart(chunk, 4, match(chunk, "\\(\\s\\|$\\)", 4) - 4)

  " restore cursor position
  execute "normal ". current_line . "G"

  " go to upper window
  execute "normal \<c-w>k"

  " open
  execute "edit " . filename
  execute "normal " . source_line . "G"
endfunction
au FileType diff nmap <buffer> <CR> :call DiffJumpToFile()<CR>


" File type dependent settings
" ============================

" Zope
function! FT_XML()
  setf xml
  if v:version >= 700
    setlocal shiftwidth=2 softtabstop=2 expandtab
  elseif v:version >= 600
    setlocal shiftwidth=2 softtabstop=2 expandtab
    setlocal indentexpr=
  else
    set shiftwidth=2 softtabstop=2 expandtab
  endif
endf

function! FT_Maybe_ReST()
  if glob(expand("%:p:h") . "/*.py") != ""
        \ || glob(expand("%:p:h:h") . "/*.py") != ""
    set ft=rest
    setlocal shiftwidth=4 softtabstop=4 expandtab
    setlocal textwidth=72
    setlocal spell
    map <buffer> <F5>    :ImportName <C-R><C-W><CR>
    map <buffer> <C-F5>  :ImportNameHere <C-R><C-W><CR>
    map <buffer> <C-F6>  :SwitchCodeAndTest<CR>

    " doctest
    syntax region doctest_value start=+^\s\{2,4}+ end=+$+
    syntax region doctest_code start=+\s\+[>.]\{3}+ end=+$+
    syntax region doctest_literal start=+`\++ end=+`\++

    syntax region doctest_header start=+=\+\n\w\++ start=+\w.\+\n=\++ end=+=$+
    syntax region doctest_header start=+-\+\n\w\++ start=+\w.\+\n-\++ end=+-$+
    syntax region doctest_header start=+\*\+\n\w\++ start=+\w.\+\n\*\++ end=+\*$+

    syntax region doctest_note start=+\.\{2} \[+ end=+(\n\n)\|\%$+

    hi link doctest_header Statement
    hi link doctest_code Special
    hi link doctest_value Define
    hi link doctest_literal Comment
    hi link doctest_note Comment
    " end of doctest
  endif
endf

" This checking allows to source .vimrc again, withoud defining autocmd's
" dwice.
if !exists("autocommands_loaded")
    let autocommands_loaded = 1
    if has("autocmd")

        " Python
        if v:version >= 703
            au BufEnter *.py    setl  colorcolumn=+1
            au BufLeave *.py    setl  colorcolumn=
        endif
        if v:version >= 600
            " Mark trailing spaces and highlight tabs
            au FileType python,html  setl list
            au FileType python,html  setl listchars=tab:>-,trail:.,extends:>
            au FileType python,html  setl foldmethod=indent
            au FileType python,html  setl foldnestmax=3

            " I don't want [I to parse import statements and look for modules
            au FileType python  setl include=

            " au FileType python  syn sync minlines=100
        endif
        au FileType python  setl formatoptions=croql
        au FileType python  setl shiftwidth=4
        au FileType python  setl expandtab
        au FileType python  setl softtabstop=4 

        " SnipMate
        autocmd FileType python set ft=python.django
        autocmd FileType html set ft=htmldjango.html

        " Makefile
        au FileType make    setl noexpandtab
        au FileType make    setl softtabstop=8
        au FileType make    setl shiftwidth=8

        " SASS
        au FileType sass    setl softtabstop=2
        au FileType sass    setl shiftwidth=2

        " LESS
        au FileType less    setl softtabstop=2
        au FileType less    setl shiftwidth=2

        " HTML
        au FileType html    setl softtabstop=4
        au FileType html    setl shiftwidth=4
        au FileType html    setl foldmethod=indent
        au FileType html    setl foldnestmax=5
        au FileType htmldjango setl softtabstop=4
        au FileType htmldjango setl shiftwidth=4
        au FileType htmldjango setl foldmethod=indent
        au FileType htmldjango setl foldnestmax=5

        " XML
        au FileType xml     setl softtabstop=4
        au FileType xml     setl shiftwidth=4

        " Mercurial
        au BufRead,BufNewFile *.mercurial  setl spell
        au BufRead,BufNewFile *.hglog  setl syntax=diff
        au BufRead,BufNewFile *.hglog  setl foldmethod=expr
        au BufRead,BufNewFile *.hglog  setl foldexpr=(getline(v:lnum)=~'^HGLOG:\ '\|\|getline(v:lnum)=~'^diff\ ')?'>1':'1

        " Sage Math
        au BufRead,BufNewFile *.sage,*.spyx,*.pyx set ft=python

        augroup Zope
          au!
          au BufRead,BufNewFile *.zcml   call FT_XML()
          au BufRead,BufNewFile *.pt     call FT_XML()
          au BufRead,BufNewFile *.tt     setlocal et tw=44 wiw=44
          au BufRead,BufNewFile *.txt    call FT_Maybe_ReST()
        augroup END

        " SPARQL
        au BufRead,BufNewFile *.rq setl ft=sparql

        " JSON
        au BufRead,BufNewFile *.json setl ft=javascript

        " ARFF
        au BufRead,BufNewFile *.arff setl ft=arff

        " TTL
        au BufRead,BufNewFile *.ttl setl ft=ttl

        " Mail
        au BufRead,BufNewFile alot.* setl ft=mail
        au FileType mail setl spell
        au FileType mail setl comments=n:>,n:#,nf:-,nf:*
        au FileType mail setl formatoptions=tcroqn
        au FileType mail setl textwidth=72

        " Jinja
        autocmd BufRead,BufNewFile *.jinja setl ft=htmldjango.jinja

        " Markdown
        au BufRead,BufNewFile *.md setl ft=markdown


        " Gradle
        au BufRead,BufNewFile *.gradle setl ft=groovy

        " SaltStack
        au BufRead,BufNewFile *.sls setl ft=yaml


        " autocmd BufRead,BufNewFile *.cfg set ft=cisco
    endif
endif


" Plugins
" =======

" BufExplorer
" plugin: bufexplorer vim http://www.vim.org/scripts/script.php?script_id=42
"   Do not show buffers from other tabs.
let g:bufExplorerFindActive=0
let g:bufExplorerShowTabBuffer=0
let g:bufExplorerShowRelativePath=1

" VCSCommand
" plugin: vcscommand git git://repo.or.cz/vcscommand.git

" PyFlakes
" plugin: pyflakes vim http://www.vim.org/scripts/script.php?script_id=2441
"   If pyflakes uses quickfix to list errors in current files, quickfix window
"   becomes not usable for anything except quickfix it self.
"   See: https://github.com/kevinw/pyflakes-vim/issues/13
let g:pyflakes_use_quickfix = 0

" Surround
" plugin: surround vim http://www.vim.org/scripts/script.php?script_id=1697

" Syntastic
" plugin: syntastic git git://github.com/scrooloose/syntastic.git 
let g:syntastic_enable_signs = 1
let g:syntastic_disabled_filetypes = ['html']

" SnipMate
" plugin: snipmate git git://github.com/garbas/vim-snipmate.git
"   SnipMate dependencies:
" plugin: tlib git git://github.com/tomtom/tlib_vim.git
" plugin: vim-addon-mw-utils git git://github.com/MarcWeber/vim-addon-mw-utils.git
" plugin: vim-snippets git git://github.com/honza/vim-snippets.git
let g:snips_author = "sirex"

" plugin: zen-coding git git://github.com/mattn/zencoding-vim.git
let g:user_zen_settings = {
\  'indentation' : '    '
\}

" plugin: delimit-mate git git://github.com/Raimondi/delimitMate.git

" plugin: nerdtree vim http://www.vim.org/scripts/script.php?script_id=1658
let g:NERDTreeQuitOnOpen = 0
let g:NERDTreeWinPos = "right"
let g:NERDTreeWinSize = 30

" plugin: tagbar git git://github.com/majutsushi/tagbar
let g:tagbar_width = 30
let g:tagbar_sort = 0

" plugin: vim-less git git://github.com/groenewege/vim-less.git

" plugin: voom vim|strip http://www.vim.org/scripts/script.php?script_id=2657

" plugin: lawrencium hg https://bitbucket.org/ludovicchabant/vim-lawrencium
let g:lawrencium_trace = 0

" plugin: wikipedia git git://github.com/vim-scripts/wikipedia.vim.git

" plugin: maynard vim http://www.vim.org/scripts/script.php?script_id=3053

" plugin: coffescript git git://github.com/kchmck/vim-coffee-script.git

" plugin: sparql git git://github.com/vim-scripts/sparql.vim.git

" plugin: mustache git git://github.com/mustache/vim-mustache-handlebars.git

" plugin: jinja git git://github.com/Glench/Vim-Jinja2-Syntax.git

" plugin: openscad git git@github.com:sirtaj/vim-openscad.git

" plugin: handlebars git git://github.com/nono/vim-handlebars.git

" plugin: fugitive git git@github.com:tpope/vim-fugitive.git

" plugin: multiple-cursors git git@github.com:terryma/vim-multiple-cursors.git

" plugin: ctrlp git git@github.com:kien/ctrlp.vim.git

" plugin: pydoc git git@github.com:fs111/pydoc.vim.git
let g:pydoc_window_lines = 24
let g:pydoc_use_drop = 1

" plugin: nginx git git@github.com:evanmiller/nginx-vim-syntax.git


function! QuickFixBookmark()
  let bookmarks_file = expand("~/.vim/bookmarks.txt")
  let item  = "  File \"".expand("%")."\", line ".line('.').", in unknown\n"
  let item .= "    ".getline('.')
  exec 'cgetfile '.bookmarks_file
  caddexpr item
  exec 'redir >> '.bookmarks_file
  silent echo item
  redir END
  clast!
endfunction
map <leader>, :call QuickFixBookmark()<CR>


" visual incrementing
if !exists("*Incr")
    fun! Incr()
        let l  = line(".")
        let c  = virtcol("'<")
        let l1 = line("'<")
        let l2 = line("'>")
        if l1 > l2
            let a = l - l2
        else
            let a = l - l1
        endif
        if a != 0
            exe 'normal '.c.'|'
            exe 'normal '.a."\<c-a>"
        endif
        normal `<
    endfunction
endif
vnoremap <c-a> :call Incr()<cr>


" Load project specific settings.
for s:name in [
\ expand('./rc.vim'),
\ expand('../rc.vim'),
\ expand('~/.vim/projects/' . fnamemodify(getcwd(), ":t") . '.vim'),
\ expand('~/.vim/projects/' . fnamemodify(getcwd(), ":h:t") . '.vim'),
\]
    if filereadable(expand(s:name))
        exe "source " . expand(s:name)
    endif
endfor
