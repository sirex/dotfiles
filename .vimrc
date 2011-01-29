set nocompatible    " no compatible
if has("syntax")
  syntax on
endif

" Filetype plugins
if v:version >= 600
  filetype plugin on            " load filetype plugins
  filetype indent on            " load indent plugins
endif

set background=dark
set backspace=indent,start
set backup
set backupdir=~/.vim/backup
set directory=~/.vim/swap
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,windows-1257
set foldmethod=marker
set guifont=Terminus\ 12
set ignorecase
set incsearch
set nohlsearch
set number

set expandtab
set textwidth=79
set tabstop=8
set softtabstop=4
set shiftwidth=4
set autoindent
set nosmartindent
set tags=./tags,./../tags,./../../tags,tags,$VIM/tags,$VIM/phptags
set visualbell
set linebreak
set showcmd     " Show count of selected lines or characters
set dictionary=~/.vim/dictionaries/phpfunclist
let loaded_matchparen = 1
set hidden
set wildignore+=*.pyc,*.pyo
set suffixes+=.pyc,.pyo         " ignore compiled Python files
set mouse=
set scrolloff=2                 " always keep cursor 2 lines from screen edge
set nostartofline               " don't jump to start of line

"set spell
set spelllang=lt,en

set t_Co=256
colors wombat256

let mapleader = ","

let g:pyflakes_use_quickfix = 0

" mappings
map     <F2>        :update<CR>
imap    <F2>        <ESC>:update<CR>a
map     <F3>        :BufExplorer<CR>
map     <F4>        :NERDTreeToggle<CR>
map     <S-F4>      :NERDTreeFind<CR>
map     <F5>        <C-^>
nmap    <F8>        :python RunUnitTestsUnderCursor()<CR>
nmap    <C-F8>      :silent! python RunInteractivePythonUnderCursor()<CR>
nmap    <S-F8>      :QFix<CR>
vmap    <F9>        :call ExecMySQL()<CR>
nmap    <F9>        V:call ExecMySQL()<CR>
map     <F12>       :set spell!<CR>
map     <SPACE>     ^
imap    <C-SPACE>   <C-R>"
cmap    <C-SPACE>   <C-R><C-W>
map     <C-TAB>     <C-W>w

" Return back where you was.
nn <c-h> <c-o>
" Return forward from where you was returned.
nn <c-l> <c-i>

" Scroll half page down
no <c-j> <c-d>
" Scroll half page up
no <c-k> <c-u>

" Autocomplete
ino <c-k> <c-p>
ino <c-j> <c-n>

" nmap <silent> <Leader>f :LustyFilesystemExplorer<CR>
" nmap <silent> <Leader>r :LustyFilesystemExplorerFromHere<CR>
" nmap <silent> <Leader>d :LustyBufferExplorer<CR>
" nmap <silent> <Leader>g :LustyBufferGrep<CR>

let g:fuf_modesDisable = ['mrucmd']
let g:fuf_keyOpen = '<TAB>'
let g:fuf_keyOpenSplit = '<C-n>'
let g:fuf_keyOpenVsplit = '<C-p>'
let g:fuf_keyPrevPattern = '<C-h>'
let g:fuf_keyNextPattern = '<C-l>'
nmap <silent> <Leader>f :FufFile<CR>
nmap <silent> <Leader>r :FufFileWithCurrentBufferDir<CR>
nmap <silent> <Leader>d :FufBuffer<CR>
nmap <silent> <Leader>e :FufMruFile<CR>
nmap <silent> <Leader>g :LustyBufferGrep<CR>

" open a file in the same dir as the current one
map <expr>      ,E              ":e ".expand("%:h")."/"
map <expr>      ,,E             ":e ".expand("%:h:h")."/"
map <expr>      ,,,E            ":e ".expand("%:h:h:h")."/"
map <expr>      ,R              ":e ".expand("%:r")."."


" Emacs style command line
cnoremap        <C-G>           <C-C>
cnoremap        <C-A>           <Home>
cnoremap        <Esc>b          <S-Left>
cnoremap        <Esc>f          <S-Right>

" Alt-Backspace deletes word backwards
cnoremap        <M-BS>          <C-W>

" Do not lose "complete all"
cnoremap        <C-S-A>         <C-A>

let g:user_zen_expandabbr_key = '<F1>'

let g:surround_{char2nr("i")} = "{% if\1 \r..*\r &\1 %}\r{% endif %}"
let g:surround_{char2nr("c")} = "{% comment\1 \r..*\r &\1 %}\r{% endcomment %}"
let g:surround_{char2nr("k")} = "{% block\1 \r..*\r &\1 %}\r{% endblock %}"

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

if has("autocmd")
    autocmd BufNewFile  *.html 0r ~/.vim/templates/xhtml.html

    " Omnicomplete
    autocmd FileType python set omnifunc=pythoncomplete#Complete
    autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
    autocmd FileType css set omnifunc=csscomplete#CompleteCSS

    " SnipMate
    autocmd FileType python set ft=python.django
    autocmd FileType html set ft=htmldjango.html

    augroup Python_prog
      autocmd!
      autocmd FileType python call FT_Python()
    augroup END
endif

function! FT_Python()
  if v:version >= 600
    setlocal formatoptions=croql
    setlocal shiftwidth=4
    setlocal softtabstop=4 
    setlocal expandtab

    " I don't want [I to parse import statements and look for modules
    setlocal include=

    " Mark trailing spaces and highlight tabs
    setlocal list
    setlocal listchars=tab:>-,trail:.,extends:>

    syn sync minlines=100

    match Error /\%>79v.\+/
    map <buffer> <Leader>i  :ImportName <C-R><C-W><CR>
    map <buffer> <Leader>I  :ImportNameHere <C-R><C-W><CR>
  else
    set formatoptions=croql
    set shiftwidth=4
    set expandtab
  endif
endf


" Plugins
runtime ftplugin/man.vim        " Manual pages (:Man foo)
" NERD_tree.vim
let g:NERDTreeHijackNetrw = 0
let g:NERDTreeQuitOnOpen = 1
" syntastic.vim
let g:syntastic_enable_signs=1
