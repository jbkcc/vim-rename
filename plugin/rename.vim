if exists("g:loaded_rename") || &cp || v:version < 800
    finish
endif
let g:loaded_rename = 1

function! rename#move(dest, bang) abort
  let l:src = expand('%:p')
  if empty(l:dest)
    echohl ErrorMsg | echo 'Destination name is empty' | echohl None
  endif

  if empty(l:src) || !filereadable(l:src)
    echohl ErrorMsg | echo 'No file on disk' | echohl None
    return
  endif
  if &modified
    echohl ErrorMsg | echo 'Save changes first' | echohl None
    return
  endif

  let l:dst = fnamemodify(a:dest, ':p')

  if !a:bang && filereadable(l:dst)
    echohl ErrorMsg | echo 'Destination exists (use ! to overwrite)' | echohl None
    return
  endif

  let l:dir = fnamemodify(l:dst, ':h')
  if !isdirectory(l:dir)
    call mkdir(l:dir, 'p')
  endif

  if rename(l:src, l:dst) != 0
    echohl ErrorMsg | echo 'Move failed' | echohl None
    return
  endif

  execute 'silent edit' fnameescape(l:dst)
  silent! execute 'bwipeout' bufnr(l:src)
endfunction

function! rename#rename(dest, bang) abort
  let l:dst = a:dest
  if l:dst !~# '^[/~]' && l:dst !~# '^\a:'
    let l:dst = expand('%:p:h') . '/' . l:dst
  endif
  call rename(l:dst, a:bang)
endfunction

command! -nargs=1 -bang -complete=file Move call rename#move(<q-args>, <bang>0)
command! -nargs=1 -bang -complete=file Rename call rename#rename(<q-args>, <bang>0)

