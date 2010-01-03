set nocompatible    " no compatible
if has("syntax")
  syntax on
endif

set autoindent
set background=dark
set backspace=indent,start
set backup
set backupdir=~/.vim/backup
set directory=~/.vim/swap
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,windows-1257
set expandtab
set foldmethod=marker
set guifont=Terminus\ 8
set guioptions=aegirLt
set ignorecase
set incsearch
set nohlsearch
set number
set shell=zsh
set shiftwidth=4
set smartindent
set softtabstop=4
set tabstop=4
set tags=./tags,./../tags,./../../tags,tags,$VIM/tags,$VIM/phptags
set textwidth=0
set visualbell
set linebreak
set showcmd     " Show count of selected lines or characters
let loaded_matchparen = 1

set spell
set spelllang=lt,en


let g:zenburn_high_Contrast = 1
if has("gui_running")
    colors zenburn
else
    set t_Co=256
    colors zen
endif


" mapings
map <F1> oe ~/notes.txt<CR>
map <F2> oe ~/.vim/db<CR>
map <F3> oBufExplorer<CR>
map <F4> ots <C-R><C-W><CR>
map <F5> ob#<CR>
map <F8> :sp changelog<CR>:
vmap <F9> ocall ExecMySQL()<CR>
nmap <F9> Vocall ExecMySQL()<CR>
nmap <F11> (xxn(
nmap <F12> (u//<ESC>n(
vmap <F11> og/./normal (xx<CR>
vmap <F12> og/./normal (u//<CR>
map <SPACE> ^
imap <C-SPACE> <C-R>"
cmap <C-SPACE> <C-R><C-W>
map <C-TAB> <C-W>w


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



autocmd BufNewFile  *.html	0r ~/.vim/templates/xhtml.html

source ~/.vim/keymap/lekpa.vim

