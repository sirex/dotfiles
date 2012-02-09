" Pathogen is responsible for vim's runtimepath management.
call pathogen#infect()

" Allow custom settings for different file types.
filetype on
filetype plugin on

" Mappings
let mapleader = ","
map     <F2>        :update<CR>
map     <F3>        :BufExplorer<CR>
map     <F4>        :Explore<CR>
map     <F5>        :cnext<CR>
map     <S-F5>      :cprevious<CR>
map     <C-F5>      :cc<CR>
map     <F6>        <c-^>
map     <F8>        :silent make!<CR>
map     <F12>       :set spell!<CR>
noremap <c-j>       <c-d>
noremap <c-k>       <c-u>
noremap <space>     ^

" Look and feel.
colorscheme desert
set guifont=Terminus\ 12
set guioptions=irL
set number
set wildmenu

" Text wrapping
set textwidth=79
set linebreak

" Spelling
set spelllang=en,lt

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
" Backups are not needed, since persistent undo is enabled. Also, these days
" everyone uses version control systems.
set nobackup
set writebackup
set directory=~/.vim/var/swap
set undodir=~/.vim/var/undo
set undofile

" Python tracebacks (unittest + doctest output)
set errorformat+=\ %#File\ \"%f\"\\,\ line\ %l\\,\ %m
set errorformat+=\ %#File\ \"%f\"\\,\ line\ %l\\,\ in\ %m

" Grep
" Do recursive grep by default and do not grep binary files.
set grepprg=ack-grep\ -H\ --nocolor\ --nogroup\ --smart-case
function! SilentGrep(args)
  execute "silent! grep! " . a:args
  botright copen
endfunction
command! -nargs=* -complete=file G call SilentGrep(<q-args>)
map <leader>g :G 

" Diff
" Open diff window with diff for all files in current directory.
function! FullDiff()
  execute "Explore ."
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
  let diff_line = search("^\\(---\\|\\*\\*\\*\\|@@\\) ", "b")

 " get first number from line like @@ -478,8 +489,12 @@
  let chunk = getline(diff_line)

  " get the first line number (478) from that string
  let source_line = strpart(chunk, 4, match(chunk, ",") - 4)

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

" Get ride of annoying parenthesis matching, I prefer to use %.
let loaded_matchparen = 1

" File type dependent settings
" ============================

" This checking allows to source .vimrc again, withoud defining autocmd's
" dwice.
if !exists("autocommands_loaded")
    let autocommands_loaded = 1

    " Python
    if v:version >= 703
        au BufEnter *.py    setl  colorcolumn=+1
        au BufLeave *.py    setl  colorcolumn=
    endif
    au FileType python  setl list
    au FileType python  setl listchars=tab:>-,trail:.,extends:>

    " QuickFix window
    au FileType qf      setl nowrap

    " Makefile
    au FileType make    setl noexpandtab
    au FileType make    setl softtabstop=8
    au FileType make    setl shiftwidth=8

    " SASS
    au FileType sass    setl softtabstop=2
    au FileType sass    setl shiftwidth=2

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

" SnipMate
" plugin: snipmate git git://github.com/garbas/vim-snipmate.git
"   SnipMate dependencies:
" plugin: tlib git git://github.com/tomtom/tlib_vim.git
" plugin: vim-addon-mw-utils git git://github.com/MarcWeber/vim-addon-mw-utils.git
" plugin: snipmate-snippets git git://github.com/honza/snipmate-snippets.git

" plugin: zen-coding git git://github.com/mattn/zencoding-vim.git
let g:user_zen_settings = {
\  'indentation' : '    '
\}

" plugin: delimit-mate git git://github.com/Raimondi/delimitMate.git
