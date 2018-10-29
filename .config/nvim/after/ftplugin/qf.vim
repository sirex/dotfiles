" Borrowed from https://github.com/blueyed/dotfiles/blob/master/vim/after/ftplugin/qf.vim

function! s:open_in_prev_win()
  " does not contain line number
  let cfile = expand('<cfile>')
  let f = findfile(cfile)
  if !len(f)
    echom 'Could not find file at cursor ('.cfile.')'
    return
  endif

  " Delegate to vim-fetch.  Could need better API
  " (https://github.com/kopischke/vim-fetch/issues/13).
  let f = expand('<cWORD>')
  wincmd p
  silent exe 'e' f
endfunction

nmap <buffer> o :call <SID>open_in_prev_win()<cr>
