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
nmap    <F12>       :set spell!<CR>
nmap    <SPACE>     ^

" Scroll half page down
no <c-j> <c-d>
" Scroll half page up
no <c-k> <c-u>

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


" Execute selected vim script.
vmap <leader>x y:@"<CR>

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
  let chunk = getline(search("^\\(---\\|\\*\\*\\*\\) .*\\t", "b"))

  " get filename (terminated by tab) in string
  let filename = strpart(chunk, 4, match(chunk, "\\t", 4) - 4)

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
    map <buffer> <F5>    :ImportName <C-R><C-W><CR>
    map <buffer> <C-F5>  :ImportNameHere <C-R><C-W><CR>
    map <buffer> <C-F6>  :SwitchCodeAndTest<CR>
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
            au FileType python  setl list
            au FileType python  setl listchars=tab:>-,trail:.,extends:>
            au FileType python  setl foldmethod=indent
            au FileType python  setl foldnestmax=2

            " I don't want [I to parse import statements and look for modules
            au FileType python  setl include=

            au FileType python  syn sync minlines=100
        endif
        au FileType python  setl formatoptions=croql
        au FileType python  setl shiftwidth=4
        au FileType python  setl expandtab
        au FileType python  setl softtabstop=4 

        " SnipMate
        autocmd FileType python set ft=python.django
        autocmd FileType html set ft=htmldjango.html

        " QuickFix window
        au FileType qf      setl nowrap

        " Makefile
        au FileType make    setl noexpandtab
        au FileType make    setl softtabstop=8
        au FileType make    setl shiftwidth=8

        " SASS
        au FileType sass    setl softtabstop=2
        au FileType sass    setl shiftwidth=2

        " HTML
        au FileType html    setl softtabstop=2
        au FileType html    setl shiftwidth=2
        au FileType html    setl foldmethod=indent
        au FileType html    setl foldnestmax=5

        " XML
        au FileType xml     setl softtabstop=2
        au FileType xml     setl shiftwidth=2

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
