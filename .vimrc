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

" Mappings
let mapleader = ","
nmap    <F2>        :update<CR>
imap    <F2>        <ESC>:update<CR>a
nmap    <F3>        :BufExplorer<CR>
nmap    <F4>        :NERDTreeFind<CR>
nmap    <F5>        :cnext<CR>
nmap    <S-F5>      :cprevious<CR>
nmap    <C-F5>      :cc<CR>
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

vmap    <F6>        <ESC>:exec "'<,'>w !vpaste ".&ft<CR>

nmap    c/          /\<class 
nmap    m/          /\<def 

" Scroll half page down
no <c-j> <c-d>
" Scroll half page up
no <c-k> <c-u>

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

" Jump to tag in split window
nmap        g}              :stselect <c-r><c-w><cr>

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


" Execute selected vim script.
vmap <leader>x y:@"<CR>


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
            au FileType python,html  setl foldnestmax=2

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
        au FileType html    setl softtabstop=2
        au FileType html    setl shiftwidth=2
        au FileType html    setl foldmethod=indent
        au FileType html    setl foldnestmax=5
        au FileType htmldjango setl softtabstop=2
        au FileType htmldjango setl shiftwidth=2
        au FileType htmldjango setl foldmethod=indent
        au FileType htmldjango setl foldnestmax=5

        " *.template files.
        au BufRead,BufNewFile *.template setl ft=html

        " XML
        au FileType xml     setl softtabstop=2
        au FileType xml     setl shiftwidth=2

        " Mercurial
        autocmd BufRead,BufNewFile *.mercurial  setl spell

        autocmd BufRead,BufNewFile *.hglog  setl syntax=diff
        autocmd BufRead,BufNewFile *.hglog  setl foldmethod=expr
        autocmd BufRead,BufNewFile *.hglog  setl foldexpr=(getline(v:lnum)=~'^HGLOG:\ '\|\|getline(v:lnum)=~'^diff\ ')?'>1':'1'

        augroup Zope
          autocmd!
          autocmd BufRead,BufNewFile *.zcml   call FT_XML()
          autocmd BufRead,BufNewFile *.pt     call FT_XML()
          autocmd BufRead,BufNewFile *.tt     setlocal et tw=44 wiw=44
          autocmd BufRead,BufNewFile *.txt    call FT_Maybe_ReST()
        augroup END

    endif
endif


" Plugins
" =======

" BufExplorer
" plugin: bufexplorer vim http://www.vim.org/scripts/script.php?script_id=42
"   Do not show buffers from other tabs.
let g:bufExplorerShowTabBuffer=1

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
" plugin: snipmate-snippets git git://github.com/honza/snipmate-snippets.git
let g:snips_author = "sirex"

" plugin: zen-coding git git://github.com/mattn/zencoding-vim.git
let g:user_zen_settings = {
\  'indentation' : '    '
\}

" plugin: delimit-mate git git://github.com/Raimondi/delimitMate.git

" plugin: nerdtree vim http://www.vim.org/scripts/script.php?script_id=1658
let g:NERDTreeQuitOnOpen = 0

" plugin: vim-less git git://github.com/groenewege/vim-less.git

" plugin: voom vim|strip http://www.vim.org/scripts/script.php?script_id=2657

" plugin: lawrencium hg https://bitbucket.org/ludovicchabant/vim-lawrencium

" plugin: frawor hg https://bitbucket.org/ZyX_I/frawor


>>>>>>> other
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
let s:names = []
call add(s:names, fnamemodify(getcwd(), ":t"))
call add(s:names, fnamemodify(getcwd(), ":h:t"))
for s:name in s:names
    if filereadable(expand('~/.vim/projects/' . s:name . '.vim'))
        exe "source " . expand('~/.vim/projects/' . s:name . '.vim')
    endif
endfor
