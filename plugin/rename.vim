if exists("g:loaded_rename") || &cp || v:version < 800
    finish
endif
let g:loaded_rename = 1

function! rename#move(dest, bang) abort
  " Check the source
  let l:src = expand('%:p') " absolute path
  if &modified
    echohl ErrorMsg | echo 'Modified, save changes first' | echohl None
    return
  endif
  if empty(l:src) || !filereadable(l:src)
    echohl ErrorMsg | echo 'No file on disk' | echohl None
    return
  endif

  " Check the destination
  if empty(a:dest)
    echohl ErrorMsg | echo 'Destination name is empty' | echohl None
  endif
  let l:dst = fnamemodify(a:dest, ':p') " absolute path
  if !a:bang && filereadable(l:dst)
    echohl ErrorMsg | echo 'Destination exists (use ! to overwrite)' | echohl None
    return
  endif

  " Make the destination directory if needed
  let l:dir = fnamemodify(l:dst, ':h')
  if !isdirectory(l:dir)
    call mkdir(l:dir, 'p')
  endif

  " Rename!
  if rename(l:src, l:dst) != 0
    echohl ErrorMsg | echo 'Move failed' | echohl None
    return
  endif

  " Close the old and open the new file (with a relative path)
  execute 'silent edit' fnameescape(fnamemodify(l:dst, ':.'))
  silent! execute 'bwipeout' bufnr(l:src)
endfunction

function! rename#rename(dest, bang) abort
  if a:dest =~# '[/\\]'
    echohl ErrorMsg | echo 'FRename only takes filenames, not paths' | echohl None
    return
  endif
  let l:dst = expand('%:h') . '/' . a:dest
  call rename#move(l:dst, a:bang)
endfunction

command! -nargs=1 -bang -complete=file FMove call rename#move(<q-args>, <bang>0)
command! -nargs=1 -bang -complete=file FRename call rename#rename(<q-args>, <bang>0)

