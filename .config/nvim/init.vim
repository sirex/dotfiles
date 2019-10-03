" If you add new plugins, install them with::
"
"     make vimpire
"
" using https://bitbucket.org/sirex/home Makefile

" Pathogen is responsible for vim's runtimepath management.
"" call pathogen#infect()

set nocompatible


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

function! ToggleNERDTree()
    " Detect which plugins are open
    if exists('t:NERDTreeBufName')
        NERDTreeFind
    else
        NERDTreeToggle
    endif
endfunction

function! OpenFileInPrevWindow()
    let cfile = expand("<cfile>")
    wincmd p
    execute "edit " . cfile
endfunction

function! TmapSelected()
    " get_visual_selection is borrowed from https://stackoverflow.com/a/6271254/475477
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    execute "Tmap " . lines[0]
endfunction

function! ExecutePythonFile()
    let python = findfile('python', 'env/bin/python,venv/bin/python,' . substitute($PATH, ':', ',', 'g'))
    let output = '/tmp/pyexoutput.rst'
    let pyfile = bufname('%')

    if pyfile == output
        return
    endif

    update

    if empty(bufname(output))
        wincmd s
        execute 'edit! ' . output
        write
    endif

    let winnr = bufwinnr(output)
    if winnr < 0
        wincmd s
        execute 'edit! ' . output
    else
        execute winnr . 'wincmd  w'
    endif

    call writefile(
        \ [strftime('%Y-%m-%d %H:%M:%S'), '-------------------', '', '.. code-block:: python', ''] +
        \ map(readfile(pyfile), {i, v -> substitute('  ' . v, ' \+$', '', '')}) +
        \ ['', 'OUTPUT::', ''] +
        \ map(systemlist(python . ' ' . $HOME . '/.config/nvim/pyexecute.py' . ' ' . pyfile), 
        \     {i, v -> substitute('  ' . v, ' \+$', '', '')}) +
        \ ['', ''], output, 'a')

    execute 'edit! ' . output
    normal G
    call search('^OUTPUT::', 'b')
    normal zz
    wincmd p
endfunction


" Mappings
let mapleader = ","
nmap    <F1>        :Gstatus<CR>
nmap    <F2>        :update \| Neomake<CR>
imap    <F2>        <C-O><F2>
nmap    <F3>        :BufExplorer<CR>
nmap    <F4>        :call ToggleNERDTree()<CR>
nmap    <F5>        :cnext<CR>
nmap    <S-F5>      :cprevious<CR>
nmap    <C-F5>      :cc<CR>
vmap    <F6>        <ESC>:exec "'<,'>w !vpaste ".&ft<CR>
nmap    <F7>        :call ToggleList("Quickfix List", 'c')<CR>
nmap    <F8>        :update \| Neomake!<CR>
nmap    <F9>        :SyntasticCheck<CR>
nmap    <C-F8>      :make<CR>
nmap    <F10>       :call ExecutePythonFile()<CR>
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
nmap    <leader>f   :GoToFile<CR>
vmap    <leader>m   :call TmapSelected()<CR>
nmap    <leader>d   :call FullDiff()<CR>
nmap    <leader>g   :T rg -w <c-r><c-w><CR>
vmap    <leader>x   y:@"<CR>
nmap    <leader>w   :call Browser()<CR>

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
" set title       " Set terminal title to 'titlestring'

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
set tags=tags,../tags,../../tags

" Ignores
set suffixes+=.pyc,.pyo
set wildignore+=*.pyc,*.pyo
let g:netrw_list_hide='\.\(pyc\|pyo\)$'

" Enable mouse in terminal
set mouse=a

" Backups
if v:version >= 730
    " Backups are not needed, since persistent undo is enabled. Also, these days
    " everyone uses version control systems.
    set nobackup
    set writebackup
    set undodir=~/.local/share/nvim/undo
    set undofile
else
    set backup
    set backupdir=~/.local/share/nvim/backup
endif
set directory=~/.local/share/nvim/swap

" Python tracebacks (unittest + doctest output)
set errorformat=\ %#File\ \"%f\"\\,\ line\ %l%m
set errorformat+=\@File\:\ %f

" Set python input/output encoding to UTF-8.
let $PYTHONIOENCODING = 'utf_8'

" Get ride of annoying parenthesis matching, I prefer to use %.
let loaded_matchparen = 1

" Disable A tag underlining
let html_no_rendering = 1

" Grep
" Do recursive grep by default and do not grep binary files.
set grepprg=rg\ --vimgrep\ --smart-case
set grepformat^=%f:%l:%c:%m
function! SilentGrep(args)
    execute "silent! grep! " . a:args
    botright copen
endfunction
command! -nargs=* -complete=file G call SilentGrep(<q-args>)

" Find
function! Find(args)
    execute "cgetexpr system('rg --smart-case -g " . a:args . " --files \\\| sed ''s/^/@File: /''')"
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


" Diff
" Open diff window with diff for all files in current directory.
function! FullDiff()
  execute "edit " . getcwd()
  execute "VCSDiff"
endfunction

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

        " Makefile
        au FileType make    setl noexpandtab
        au FileType make    setl softtabstop=8
        au FileType make    setl shiftwidth=8

        " UltiSnips
        au FileType snippets setl noexpandtab
        au FileType snippets setl softtabstop=8
        au FileType snippets setl shiftwidth=8

        " SASS
        au FileType sass    setl softtabstop=2
        au FileType sass    setl shiftwidth=2

        " LESS
        au FileType less    setl softtabstop=2
        au FileType less    setl shiftwidth=2

        " reStructuredText
        au FileType rst     setl softtabstop=2
        au FileType rst     setl shiftwidth=2
        au FileType rst     syn sync minlines=300

        " HTML
        au FileType html    setl softtabstop=4
        au FileType html    setl shiftwidth=4
        au FileType html    setl foldmethod=indent
        au FileType html    setl foldnestmax=5
        au FileType html    UltiSnipsAddFiletypes htmldjango

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

        " Markdown
        au BufRead,BufNewFile *.md setl ft=markdown

        " json-ld
        au BufRead,BufNewFile *.jsonld setl ft=javascript

        " Gradle
        au BufRead,BufNewFile *.gradle setl ft=groovy

        " SaltStack
        au BufRead,BufNewFile *.sls setl ft=yaml

        " YAML
        au FileType yaml    setl softtabstop=2
        au FileType yaml    setl shiftwidth=2

        " Yarn's: http://blog.liw.fi/posts/yarn/
        au BufRead,BufNewFile *.yarn setl ft=markdown

        " autocmd BufRead,BufNewFile *.cfg set ft=cisco
    endif
endif


" Plugins
" =======

" How to install vim-plug:
"
"     curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 
"
" https://github.com/junegunn/vim-plug
" set the runtime path to include Vundle and initialize

call plug#begin('~/.config/nvim/plugged')

Plug 'gmarik/Vundle.vim'

Plug 'jlanzarotta/bufexplorer'
"   Do not show buffers from other tabs.
let g:bufExplorerFindActive=0
let g:bufExplorerShowTabBuffer=0
let g:bufExplorerShowRelativePath=1

Plug 'hdima/python-syntax'
let g:python_highlight_all = 1

Plug 'python-mode/python-mode'
" let g:pymode_python = 'python3'
let g:pymode_lint_checkers = ['pyflakes']
let g:pymode_lint_cwindow = 0
let g:pymode_lint_on_write = 0
let g:pymode_rope_complete_on_dot = 0
let g:pymode_rope = 0
let g:pyflakes_use_quickfix = 0

Plug 'tpope/vim-surround'

Plug 'sirver/UltiSnips'
" let g:UltiSnipsUsePythonVersion = 3

Plug 'honza/vim-snippets'

" Former zen coding, now renamed to emmet.
" Key to expand: <c-y>,
Plug 'mattn/emmet-vim'
let g:user_zen_settings = {
\  'indentation' : '    '
\}

Plug 'Raimondi/delimitMate'

Plug 'scrooloose/nerdtree'
let g:NERDTreeQuitOnOpen = 0
let g:NERDTreeWinPos = "right"
let g:NERDTreeWinSize = 30
let g:NERDTreeIgnore = ['^__pycache__$', '\.egg-info$', '\~$', '\.pyc$']

Plug 'vim-voom/VOoM'

Plug 'ludovicchabant/vim-lawrencium'
let g:lawrencium_trace = 0

Plug 'mustache/vim-mustache-handlebars'

Plug 'lepture/vim-jinja'
if !exists("vim_jinja_loaded")
    let vim_jinja_loaded = 1
    au BufNewFile,BufRead *.html,*.htm,*.shtml,*.stm set ft=jinja
endif

Plug 'tpope/vim-fugitive'

" Plug 'airblade/vim-gitgutter'

Plug 'neomake/neomake'
let g:neomake_python_enabled_makers = ['python', 'flake8']


Plug 'editorconfig/editorconfig-vim'

Plug 'gabrielelana/vim-markdown'
let g:markdown_enable_mappings = 0
let g:markdown_enable_input_abbreviations = 0

Plug 'digitaltoad/vim-jade'

Plug 'mfukar/robotframework-vim'

" JSX support
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'

Plug 'cespare/vim-toml'

" Vue.js
Plug 'posva/vim-vue'

" GhostTest
Plug 'raghur/vim-ghost', {'do': ':GhostInstall'}

" vim-spellsync
Plug 'micarmst/vim-spellsync'

" Plug 'davidhalter/jedi-vim'
" let g:jedi#popup_on_dot = 0
" let g:jedi#force_py_version = 3
" let g:jedi#smart_auto_mappings = 0
" let g:jedi#show_call_signatures = 2
" set completeopt=menuone,longest

Plug 'wsdjeg/vim-fetch'

Plug 'kassio/neoterm'
let g:neoterm_shell = "zsh"
let g:neoterm_autoinsert = 0
let g:neoterm_autoscroll = 1

Plug 'janko/vim-test'
let test#strategy = "neovim"

Plug 'mrtazz/simplenote.vim'
let g:SimplenoteFiletype = "rst"
let g:SimplenoteSingleWindow = 1

Plug 'JuliaEditorSupport/julia-vim'

" Add plugins to &runtimepath
call plug#end()


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
set backspace=2

" Movement in terminal mode
if has('nvim')
    tnoremap <Esc> <C-\><C-n>
    tnoremap <M-k> <C-\><C-n><C-W>k
    tnoremap <M-j> <C-\><C-n><C-W>j
    tnoremap <M-l> <C-\><C-n><C-W>l
    tnoremap <M-h> <C-\><C-n><C-W>h
    tnoremap <M-1> <C-\><C-n>1gt
    tnoremap <M-2> <C-\><C-n>2gt
    tnoremap <M-3> <C-\><C-n>3gt
    tnoremap <M-4> <C-\><C-n>4gt
    tnoremap <M-5> <C-\><C-n>5gt
    tnoremap <M-6> <C-\><C-n>6gt
    tnoremap <M-7> <C-\><C-n>7gt
    tnoremap <M-8> <C-\><C-n>8gt
    tnoremap <M-9> <C-\><C-n>9gt

    " Turn on true color support
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    set termguicolors

    " Enable blinking cursor shape
    let $NVIM_TUI_ENABLE_CURSOR_SHAPE=2  " This was replace with guicursor since 0.2
    set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:blinkon250

    " Solarized theme for terminal
    " https://github.com/altercation/solarized/blob/master/vim-colors-solarized/colors/solarized.vim#L244-L261
    let s:base03      = "#002b36"
    let s:base02      = "#073642"
    let s:base01      = "#586e75"
    let s:base00      = "#657b83"
    let s:base0       = "#839496"
    let s:base1       = "#93a1a1"
    let s:base2       = "#eee8d5"
    let s:base3       = "#fdf6e3"
    let s:yellow      = "#b58900"
    let s:orange      = "#cb4b16"
    let s:red         = "#dc322f"
    let s:magenta     = "#d33682"
    let s:violet      = "#6c71c4"
    let s:blue        = "#268bd2"
    let s:cyan        = "#2aa198"
    let s:green       = "#859900"

    let g:terminal_color_0 = s:base02
    let g:terminal_color_1 = s:red
    let g:terminal_color_2 = s:green
    let g:terminal_color_3 = s:yellow
    let g:terminal_color_4 = s:blue
    let g:terminal_color_5 = s:magenta
    let g:terminal_color_6 = s:cyan
    let g:terminal_color_7 = s:base2
    let g:terminal_color_8 = s:base03
    let g:terminal_color_9 = s:orange
    let g:terminal_color_10 = s:base01
    let g:terminal_color_11 = s:base00
    let g:terminal_color_12 = s:base0
    let g:terminal_color_13 = s:violet
    let g:terminal_color_14 = s:base1
    let g:terminal_color_15 = s:base3

    let g:terminal_scrollback_buffer_size = 50000

    " https://neovim.io/doc/user/provider.html
    let g:python3_host_prog = '/usr/bin/python3'

    " transparent background
    hi Normal guibg=NONE
    hi NonText guibg=NONE

    au TermOpen * setlocal nonumber
    au TermOpen * setlocal hidden
endif

" Neomake settings
let g:neomake_makeprg_buffer_output = 0

set statusline=
set statusline+=\ %n\ %*            "buffer number
set statusline+=\ %<%f%*            "full path
set statusline+=%m%*                "modified flag
set statusline+=\ [%{fugitive#head()}]%*    
set statusline+=%=%5l%*             "current line
set statusline+=/%L%*               "total lines
set statusline+=%4v\ %*             "virtual column number
set statusline+=0x%04B\ %*          "character under cursor
