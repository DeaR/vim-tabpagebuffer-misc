" Commands for the buffer belonging to the tab page.
"
" Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
" Last Change:  27-Aug-2015.
" License:      MIT License {{{
"     Copyright (c) 2015 DeaR <nayuri@kuonn.mydns.jp>
"
"     Permission is hereby granted, free of charge, to any person obtaining a
"     copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to permit
"     persons to whom the Software is furnished to do so, subject to the
"     following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT
"     OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR
"     THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}

let s:save_cpo = &cpo
set cpo&vim

let g:tabpagebuffer#command#bdelete_keeptabpage =
  \ get(g:, 'tabpagebuffer#command#bdelete_keeptabpage', 0)

function! s:echoerr(...)
  echohl ErrorMsg
  echomsg join(a:000)
  echohl None
endfunction

function! s:_numerical_sort(i1, i2)
  return a:i1 - a:i2
endfunction
function! s:numerical_sort(list)
  return sort(copy(a:list), has('patch-7.4.341') ? 'n' : 's:_numerical_sort')
endfunction

function! s:doautocmd(...)
  if has('patch-7.3.438') || v:version > 703 ||
    \ (v:version == 703 && has('patch438'))
    execute 'doautocmd' '<nomodeline>' join(a:000)
  else
    execute 'doautocmd' join(a:000)
  endif
endfunction

" tabpagebuffer#command#ls({command})
function! tabpagebuffer#command#ls(command)
  redir => out
  silent execute a:command
  redir END
  for buf in filter(split(out, '\n'),
    \ 'tabpagebuffer#function#bufexists(str2nr(matchstr(v:val, "\\d\\+")))')
    echo buf
  endfor
endfunction
function! tabpagebuffer#command#do_ls(command)
  try
    call tabpagebuffer#command#ls(a:command)
  catch /.*/
    call s:echoerr(v:exception)
  endtry
endfunction

" tabpagebuffer#command#bdelete({command} [, {list}])
" E515: No buffers were unloaded
" E516: No buffers were deleted
" E517: No buffers were wiped out
function! tabpagebuffer#command#bdelete(command, ...)
  let tabnr = tabpagenr()
  let bufs = !len(get(a:000, 0, [])) ? [bufnr('%')] :
    \ map(a:1, 'tabpagebuffer#function#bufnr(v:val, 0, tabnr, 1)')
  " echo 'bufs:' bufs
  if !len(bufs)
    if a:command =~# '\<bun'
      throw join(['tabpagebuffer-misc:E515',
        \ 'No buffers were unloaded'])
    elseif a:command =~# '\<bw'
      throw join(['tabpagebuffer-misc:E517',
        \ 'No buffers were wiped out'])
    else
      throw join(['tabpagebuffer-misc:E516',
        \ 'No buffers were deleted'])
    endif
  endif

  let cancel = ''
  if g:tabpagebuffer#command#bdelete_keeptabpage && tabpagenr('$') > 1
    let pop = get(s:numerical_sort(filter(tabpagebuffer#function#buflist(),
      \ 'buflisted(v:val)')), -1)
    " echo 'pop:' pop
    if pop
      execute 'sbuffer' pop
      let cancel = 'close!'
    else
      new
      let cancel = 'bwipeout!'
    endif
  endif

  try
    execute a:command join(bufs)
  finally
    " echo 'cancel:' cancel
    if winnr('$') > 1
      execute cancel
    endif
  endtry
endfunction
function! tabpagebuffer#command#do_bdelete(command, count, line1, line2, args)
  let args = []
  let i = 0
  while i < strlen(a:args)
    let s = matchstr(a:args, '^\d\+\s\+', i)
    if strlen(s)
      call add(args, str2nr(s))
      let i += strlen(s)
    else
      call add(args, a:args[(i):])
      break
    endif
  endwhile
  if !len(args) && a:count
    let args = range(a:line1, a:line2, a:line1 < a:line2 ? 1 : -1)
  endif
  " echo 'args:' args
  try
    call tabpagebuffer#command#bdelete(a:command, args)
  catch /.*/
    call s:echoerr(v:exception)
  endtry
endfunction

" tabpagebuffer#command#bdelete_all({command} [, {count}])
function! tabpagebuffer#command#bdelete_all(command, ...)
  call tabpagebuffer#command#bdelete(a:command, s:numerical_sort(
    \ tabpagebuffer#function#buflist())[:(a:0 && a:1 ? a:1 : -1)])
endfunction
function! tabpagebuffer#command#do_bdelete_all(command, count)
  try
    call tabpagebuffer#command#bdelete_all(a:command, a:count)
  catch /.*/
    call s:echoerr(v:exception)
  endtry
endfunction

" tabpagebuffer#command#buffer({command} [, {expr}])
" E86: Cannot go to buffer %ld
function! tabpagebuffer#command#buffer(command, ...)
  let tabnr = tabpagenr()
  let pop = tabpagebuffer#function#bufnr(a:0 ? a:1 : '%', 0, tabnr, 1)
  " echo 'pop:' pop
  execute a:command pop
endfunction
function! tabpagebuffer#command#do_buffer(command, count, args)
  try
    let m = matchlist(a:args, '\m^\(+.*\\\@<! \+\)\=\(.*\)')
    call tabpagebuffer#command#buffer(
      \ join([a:command, m[1]]),
      \ m[2] =~ '^\d\+$' ? str2nr(m[2]) :
      \ strlen(m[2]) ? m[2] :
      \ a:count ? a:count : '%')
  catch /.*/
    call s:echoerr(v:exception)
  endtry
endfunction

" tabpagebuffer#command#next({command} [, {count}])
" tabpagebuffer#command#previous({command} [, {count}])
" tabpagebuffer#command#modified_next({command} [, {count}])
" tabpagebuffer#command#modified_previous({command} [, {count}])
" E84: No modified buffer found
" E87: Cannot go beyond last buffer
" E88: Cannot go before first buffer
" E488: Trailing characters
function! s:bnext(forward, modified, command, count)
  let bufs = s:numerical_sort(filter(tabpagebuffer#function#buflist(),
    \ 'buflisted(v:val) && (!a:modified || getbufvar(v:val, "&modified"))'))
  " echo 'bufs:' bufs
  if !len(bufs)
    if a:modified
      throw join(['tabpagebuffer-misc:E84:',
        \ 'No modified buffer found'])
    endif
    return
  endif

  let cur = index(bufs, bufnr('%'))
  let pop = bufs[(cur + (a:forward ? a:count : -a:count)) % len(bufs)]
  " echo 'pop:' pop
  execute a:command pop
endfunction
function! tabpagebuffer#command#bnext(command, ...)
  call s:bnext(1, 0, a:command, a:0 ? a:1 : 1)
endfunction
function! tabpagebuffer#command#bprevious(command, ...)
  call s:bnext(0, 0, a:command, a:0 ? a:1 : 1)
endfunction
function! tabpagebuffer#command#bmodified_next(command, ...)
  call s:bnext(1, 1, a:command, a:0 ? a:1 : 1)
endfunction
function! tabpagebuffer#command#bmodified_previous(command, ...)
  call s:bnext(0, 1, a:command, a:0 ? a:1 : 1)
endfunction
function! tabpagebuffer#command#do_bnext(forward, modified, command, count, args)
  try
    let m = matchlist(a:args, '\m^\(+.*\\\@<! \+\)\=\(.*\)')
    if m[2] =~ '\D'
      throw join(['tabpagebuffer-misc:E488',
        \ 'Trailing characters'])
    endif
    call s:bnext(a:forward, a:modified,
      \ join([a:command, m[1]]),
      \ strlen(m[2]) ? str2nr(m[2]) : a:count ? a:count : 1)
  catch /.*/
    call s:echoerr(v:exception)
  endtry
endfunction

" tabpagebuffer#command#first({command})
" tabpagebuffer#command#last({command})
" tabpagebuffer#command#modified_first({command})
" tabpagebuffer#command#modified_last({command})
" E84: No modified buffer found
function! s:brewind(forward, modified, command)
  let bufs = s:numerical_sort(filter(tabpagebuffer#function#buflist(),
    \ 'buflisted(v:val) && (!a:modified || getbufvar(v:val, "&modified"))'))
  " echo 'bufs:' bufs
  if !len(bufs)
    if a:modified
      throw join(['tabpagebuffer-misc:E84:',
        \ 'No modified buffer found'])
    endif
    return
  endif

  let pop = a:forward ? bufs[-1] : bufs[0]
  " echo 'pop:' pop
  execute a:command pop
endfunction
function! tabpagebuffer#command#first(command)
  call s:brewind(0, 0, a:command)
endfunction
function! tabpagebuffer#command#last(command)
  call s:brewind(1, 0, a:command)
endfunction
function! tabpagebuffer#command#modified_first(command)
  call s:brewind(0, 1, a:command)
endfunction
function! tabpagebuffer#command#modified_last(command)
  call s:brewind(1, 1, a:command)
endfunction
function! tabpagebuffer#command#do_brewind(forward, modified, command, args)
  try
    call s:brewind(a:forward, a:modified,
      \ join([a:command, a:args]))
  catch /.*/
    call s:echoerr(v:exception)
  endtry
endfunction

" tabpagebuffer#command#unhide({command} [, {count}])
" tabpagebuffer#command#ball({command} [, {count}])
function! s:unhide(loaded, command, count)
  let bufs = reverse(s:numerical_sort(filter(
    \ tabpagebuffer#function#buflist(),
    \ 'buflisted(v:val) && (!a:loaded || bufloaded(v:val))')))
  " echo 'bufs:' bufs
  if !len(bufs)
    return
  endif

  silent only!
  if len(bufs) > 1
    let save_ei = &eventignore
    try
      set eventignore+=BufLeave,WinLeave,BufEnter,WinEnter
      execute 'buffer!' bufs[0]
      for pop in bufs[1:(a:count ? a:count : -1)]
        execute a:command pop
      endfor
    finally
      let &eventignore = save_ei
    endtry
    if &eventignore !~ 'WinEnter'
      call s:doautocmd('WinEnter')
    endif
    if &eventignore !~ 'BufEnter'
      call s:doautocmd('BufEnter')
    endif
  endif
endfunction
function! tabpagebuffer#command#unhide(command, ...)
  call s:unhide(1, a:command, a:0 ? a:1 : 1)
endfunction
function! tabpagebuffer#command#ball(command, ...)
  call s:unhide(0, a:command, a:0 ? a:1 : 1)
endfunction
function! tabpagebuffer#command#do_unhide(loaded, command, count)
  try
    call s:unhide(a:loaded, a:command, a:count)
  catch /.*/
    call s:echoerr(v:exception)
  endtry
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
