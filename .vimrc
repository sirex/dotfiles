set nocompatible    " no compatible
if has("syntax")
  syntax on
endif

filetype on
filetype plugin on

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
set smartindent
set tags=./tags,./../tags,./../../tags,tags,$VIM/tags,$VIM/phptags
set visualbell
set linebreak
set showcmd     " Show count of selected lines or characters
set dictionary=~/.vim/dictionaries/phpfunclist
let loaded_matchparen = 1
set formatoptions+=ro " Auto add * to /**  ... */ comments.
set hidden
set wildignore=*.pyc,CVS
set mouse=

"set spell
set spelllang=lt,en

set t_Co=256
colors wombat256

let mapleader = ","

let g:pyflakes_use_quickfix = 0
compiler pyunit

" mappings
map     <F2> :update<CR>
imap    <F2> <ESC>:update<CR>a
map     <F3> :BufExplorer<CR>
map     <F4> :ts <C-R><C-W><CR>
map     <F5> :b#<CR>
map     <F8> :python RunDjangoTestUnderCursor()<CR>
vmap    <F9> :call ExecMySQL()<CR>
nmap    <F9> V:call ExecMySQL()<CR>
map    <F12> :set spell!<CR>
map     <SPACE> ^
imap    <C-SPACE> <C-R>"
cmap    <C-SPACE> <C-R><C-W>
map     <C-TAB> <C-W>w

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

nmap <silent> <Leader>f :LustyFilesystemExplorer<CR>
nmap <silent> <Leader>r :LustyFilesystemExplorerFromHere<CR>
nmap <silent> <Leader>d :LustyBufferExplorer<CR>
nmap <silent> <Leader>g :LustyBufferGrep<CR>

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

    " Mark lines if they are longer than 100 symbols
    autocmd FileType python,php call matchadd('ErrorMsg', '  \+$', -1)
    autocmd FileType python,php call matchadd('ErrorMsg', '\%>100v.\+', -1)

    " Mark trailing spaces and highlight tabs
    autocmd FileType python,php set list
    autocmd FileType python,php set listchars=tab:>-,trail:·

    " Omnicomplete
    autocmd FileType python set omnifunc=pythoncomplete#Complete
    autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
    autocmd FileType css set omnifunc=csscomplete#CompleteCSS

    " SnipMate
    autocmd FileType python set ft=python.django
    autocmd FileType html set ft=htmldjango.html

    " Python
    autocmd FileType python setlocal makeprg=bin/python\ %
    autocmd FileType python call PyFT()
endif

function! PyFT()
    let g:pyTestRunner = 'bin/django test'
    let g:pyTestRunnerModuleFiltering = " "
endf
