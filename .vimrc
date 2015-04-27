" If you add new plugins, install them with::
"
"     make vimpire
"
" using https://bitbucket.org/sirex/home Makefile

" Pathogen is responsible for vim's runtimepath management.
"" call pathogen#infect()

set nocompatible


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
nmap    <F8>        :silent Neomake!<CR>
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
set grepprg=ack-grep\ -H\ --nocolor\ --nogroup\ --smart-case
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

            " I don't want [I to parse import statements and look for modules
            au FileType python  setl include=

            au FileType python  syn sync minlines=300
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
        au BufRead,BufNewFile *.ttl setl ft=n3

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

" How to install Vundle:
"
"     git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
"
" https://github.com/gmarik/Vundle.vim
" set the runtime path to include Vundle and initialize
"
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin("~/.vim/vundle")

Plugin 'gmarik/Vundle.vim'

Plugin 'bufexplorer.zip'
"   Do not show buffers from other tabs.
let g:bufExplorerFindActive=0
let g:bufExplorerShowTabBuffer=0
let g:bufExplorerShowRelativePath=1

Plugin 'Python-mode-klen'
let g:pymode_lint_checkers = ['pyflakes']
let g:pymode_lint_cwindow = 0
let g:pymode_lint_on_write = 0
let g:pymode_rope_complete_on_dot = 0

Plugin 'surround.vim'

Plugin 'Syntastic'
let g:syntastic_enable_signs = 1
let g:syntastic_disabled_filetypes = ['html']
let g:syntastic_python_python_exec = '/usr/bin/python3'
let g:syntastic_python_checkers = ['python', 'flake8']
let g:syntastic_filetype_map = {'python.django': 'python'}
let g:syntastic_python_pep8_args = '--ignore=E501'

Plugin 'UltiSnips'
Plugin 'honza/vim-snippets'

Plugin 'ZenCoding.vim'
let g:user_zen_settings = {
\  'indentation' : '    '
\}

Plugin 'delimitMate.vim'

Plugin 'The-NERD-tree'
let g:NERDTreeQuitOnOpen = 0
let g:NERDTreeWinPos = "right"
let g:NERDTreeWinSize = 30
let g:NERDTreeIgnore = ['^__pycache__$', '\.egg-info$', '\~$']

Plugin 'Tagbar'
let g:tagbar_width = 30
let g:tagbar_sort = 0

Plugin 'less-syntax'

Plugin 'VOoM'

Plugin 'ludovicchabant/vim-lawrencium'
let g:lawrencium_trace = 0

Plugin 'vim-coffee-script'

Plugin 'sparql.vim'

Plugin 'mustache/vim-mustache-handlebars'

Plugin 'Jinja'

Plugin 'openscad.vim'

Plugin 'Handlebars'

Plugin 'fugitive.vim'

Plugin 'ctrlp.vim'

Plugin 'n3.vim'

Plugin 'benekastah/neomake'

Plugin 'editorconfig/editorconfig-vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

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


" Neovim settings
syntax on
nmap <C-6> :buffer #<CR>
set mouse=a
set backspace=2
