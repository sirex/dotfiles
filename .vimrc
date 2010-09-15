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
set guifont=Terminus\ 8
set guioptions=aegirLt
set ignorecase
set incsearch
set nohlsearch
set number
set shell=zsh

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

"set spell
set spelllang=lt,en

" Copy to clipboard
vmap <INSERT> o!xclip -f -sel clip<CR>
" Paste to clipboard
nmap <INSERT> or!xclip -o -sel clip<CR>


set t_Co=256
colors wombat256


" mapings
map     <F2> :update<CR>
imap    <F2> <ESC>:update<CR>a
map     <F3> :BufExplorer<CR>
map     <F4> :ts <C-R><C-W><CR>
map     <F5> :b#<CR>
vmap    <F9> :call ExecMySQL()<CR>
nmap    <F9> V:call ExecMySQL()<CR>
nmap    <F11> (xxn(
nmap    <F12> (u//<ESC>n(
vmap    <F11> :g/./normal (xx<CR>
vmap    <F12> :g/./normal (u//<CR>
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


" setting compiler (PHP)
compiler cphp

" Abbreavtions
if !exists("*Eatchar_")
    func Eatchar_(pat)
      let c = nr2char(getchar())
      return (c =~ a:pat) ? '' : c
    endfunc
endif
iabbr <silent> vd var_dump();<Left><Left><C-R>=Eatchar_('\s')<CR>
iabbr <silent> pt <?php ?><Left><Left><Left>
iabbr <silent> pp pp();<Left><Left><C-R>=Eatchar_('\s')<CR>

" Replaces ymd with curren date in insert mode
iabbr ymd <C-R>=strftime("%Y-%m-%d")<CR>

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


inoremap ( ()<ESC>i
inoremap [ []<ESC>i
inoremap { <c-r>=OpenBracket()<CR>
inoremap ) <c-r>=ClosePair(')')<CR>
inoremap ] <c-r>=ClosePair(']')<CR>
inoremap } <c-r>=CloseBracket()<CR>
inoremap " <c-r>=QuoteDelim('"')<CR>
inoremap ' <c-r>=QuoteDelim("'")<CR>

if !exists("*ClosePair")
    function ClosePair(char)
      if getline('.')[col('.') - 1] == a:char
        return "\<Right>"
      else
        return a:char
      endif
    endf
endif

if !exists("*OpenBracket")
    function OpenBracket()
      if len(getline('.')) == col('.') - 1
        return "{\<CR>}\<ESC>k$"
      else
        return "{}\<ESC>i"
      endif
    endf
endif
if !exists("*CloseBracket")
    function CloseBracket()
      if len(getline('.')) == col('.') - 1
        return "\<CR>}\<ESC>k$"
      else
        return "}"
      endif
    endf
endif

if !exists("*QuoteDelim")
    function QuoteDelim(char)
      let line = getline('.')
      let col = col('.')
      if line[col - 2] == "\\"
        "Inserting a quoted quotation mark into the string
        return a:char
      elseif line[col - 1] == a:char
        "Escaping out of the string
        return "\<Right>"
      else
        "Starting a string
        return a:char.a:char."\<ESC>i"
      endif
    endf
endif


let g:user_zen_expandabbr_key = '<F1>'
let g:user_zen_settings = {
\  'indentation' : '    ',
\    'html': {
\        'snippets': {
\            'djb': "{% block %}\n\t${child}|\n{% endblock %}\n\n",
\        },
\        'block_elements': 'djb',
\    },
\    'sql': {
\        'snippets': {
\            'sel': "SELECT *\nFROM `|`\n${child}",
\            'selw': "SELECT *\nFROM `|`\nWHERE `` = ?\n${child}",
\            'selwl': "SELECT *\nFROM `|`\nWHERE `` = ?\nLIMIT 1${child}",
\        },
\    },
\    'php': {
\        'extends': 'sql',
\        'snippets': {
\            'echo': "<?php echo |; ?>${child}",
\            'foreach': "\n\n<?php foreach ($| as ): ?>\n\t${child}<?php endforeach; ?>\n\n",
\        },
\        'aliases': {
\            'feach': 'foreach',
\        },
\        'block_elements': 'foreach',
\    },
\}


" Mark lines if they are longer than 100 symbols
if !exists("*MarkLines")
    func MarkLines()
        let g:marklines_1 = matchadd('ErrorMsg', '  \+$', -1)
        let g:marklines_2 = matchadd('ErrorMsg', '\%>100v.\+', -1)
        set list
        set listchars=tab:>-,trail:·
    endfunc
    func UnMarkLines()
        if g:marklines_1 && g:marklines_2
            call matchdelete(g:marklines_1)
            call matchdelete(g:marklines_2)
            set nolist
            set listchars=tab:>-
        endif
    endfunc
endif

autocmd BufEnter  *.php,*.py call MarkLines()
"autocmd BufLeave  *.php,*.py call UnMarkLines()
autocmd BufNewFile  *.html 0r ~/.vim/templates/xhtml.html
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
