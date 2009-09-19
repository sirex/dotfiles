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

" mappings
map <F1> :e ~/notes.txt<CR>
map <F2> :e ~/.vim/db<CR>
map <F3> :BufExplorer<CR>
map <F4> :ts <C-R><C-W><CR>
map <F5> :b#<CR>
map <F8> :sp changelog<CR>:
vmap <F9> :call ExecMySQL()<CR>
nmap <F9> V:call ExecMySQL()<CR>
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



" LEKPa langmap, works since Vim 7.2.109:
" http://vim.svn.sourceforge.net/viewvc/vim?view=rev&revision=1366
set langmap=/1,\\2,.3,\,4,f5,!6,w7,ų8,į9,(0,)-,:=,gw,re,lr,dt,čy,ju,ui,ėo,ęp,?[,=],'\\,ks,sd,tf,mg,ph,nj,ek,il,o:,y',žb,šn,bm,ū\,,ą.,h/,\"!,{#,}$,F%,–^,W&,Ų*,Į(,“),“_,\;+,GW,RE,LR,DT,ČY,JU,UI,ĖO,ĘP,[{,]},_\|,KS,SD,TF,MG,PH,NJ,EK,IL,O\;,Y\",ŽB,ŠN,BM,Ū<,Ą>,H?,

nnoremap = o

" Return back where you was.
nnoremap <c-p> <c-o>
" Return forward from where you was returned.
nnoremap <c-i> <c-i>

" Scroll half page down
noremap <c-n> <c-d>
" Scroll half page up
noremap <c-e> <c-u>

" Redo
nnoremap <c-l> <c-r>

" Go to link or tag.
nnoremap <c-=>  <c-]>
" Go from last link or tag.
nnoremap <c-d> <c-t>

" Go from last link or tag.
inoremap <c-e> <c-p>

" Digraph
inoremap <c-d> <c-k>

" Scrolling horizontally.
nmap <C-MouseUp> 5zl
nmap <C-MouseDown> 5zh

nmap <c-k> :update<CR>
imap <c-k> <ESC>:update<CR>a

