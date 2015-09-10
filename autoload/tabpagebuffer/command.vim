" Commands for the buffer belonging to the tab page.
"
" Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
" Last Change:  10-Sep-2015.
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

function! s:has_patch(major, minor, patch)
  let l:version = (a:major * 100 + a:minor)
  return has('patch-' . a:major . '.' . a:minor . '.' . a:patch) ||
  \ (v:version > l:version) ||
  \ (v:version == l:version && has('patch' . a:patch))
endfunction

function! s:_numerical_sort(i1, i2)
  return a:i1 - a:i2
endfunction
let s:numerical_sort = s:has_patch(7, 4, 341) ? 'n' : 's:_numerical_sort'

let s:_doautocmd = s:has_patch(7, 3, 438) ? '<nomodeline>' : ''
function! s:doautocmd(...)
  execute 'doautocmd' s:_doautocmd join(a:000)
endfunction

function! s:bufnr(expr, ...)
  let create = get(a:000, 0)

  if type(a:expr) == type(0)
    return tabpagebuffer#function#bufnr(a:expr, create)
  else
    let bufs = tabpagebuffer#function#bufnr(a:expr, create, 1)
    if empty(bufs)
      throw join(['tabpagebuffer-misc:E94:',
      \ 'No matching buffer for', a:expr])
    elseif len(bufs) > 1
      throw join(['tabpagebuffer-misc:E93:',
      \ 'More than one match for', a:expr])
    else
      return bufs[0]
    endif
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
" E93: More than one match for %s
" E94: No matching buffer for %s
" E515: No buffers were unloaded
" E516: No buffers were deleted
" E517: No buffers were wiped out
function! tabpagebuffer#command#bdelete(command, ...)
  let list = get(a:000, 0, ['%'])

  let bufs = filter(map(list, 's:bufnr(v:val)'), 'v:val > 0')
  " echo 'bufs:' bufs
  if empty(bufs)
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
    let pop = get(filter(
    \ add(sort(tabpagebuffer#function#buflist(), s:numerical_sort),
    \   tabpagebuffer#function#bufnr('#')),
    \ 'buflisted(v:val) && index(bufs, v:val) < 0 && ' .
    \ 'getbufvar(v:val, "&filetype") != "qf"'), -1)
    " echo 'pop:' pop
    if pop > 0
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
    let s = matchstr(a:args, '^\s*\<\d\+\>\s*', i)
    if !empty(s)
      call add(args, str2nr(s))
      let i += strlen(s)
    else
      call add(args, a:args[(i):])
      break
    endif
  endwhile
  if empty(args) && a:count
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
  let count = get(a:000, 0, -1)

  call tabpagebuffer#command#bdelete(a:command,
  \ sort(tabpagebuffer#function#buflist(), s:numerical_sort)[:(count)])
endfunction
function! tabpagebuffer#command#do_bdelete_all(command, count)
  try
    call tabpagebuffer#command#bdelete_all(a:command, a:count)
  catch /.*/
    call s:echoerr(v:exception)
  endtry
endfunction

" tabpagebuffer#command#buffer({command} [, {expr}])
" E86: Buffer %ld does not exist
" E93: More than one match for %s
" E94: No matching buffer for %s
function! tabpagebuffer#command#buffer(command, ...)
  let expr = get(a:000, 0, '%')

  let pop = s:bufnr(expr)
  " echo 'pop:' pop
  if pop <= 0
    throw join(['tabpagebuffer-misc:E86:',
    \ 'Buffer', expr, 'does not exist'])
  endif

  execute a:command pop
endfunction
function! tabpagebuffer#command#do_buffer(command, count, args)
  try
    let p = matchstr(a:args, '^+.*\\\@<! \+')
    let r = a:args[strlen(p):]
    call tabpagebuffer#command#buffer(
    \ join([a:command, p]),
    \ r =~ '^\d\+$' ? str2nr(r) :
    \ !empty(r) ? r :
    \ a:count ? a:count : '%')
  catch /.*/
    call s:echoerr(v:exception)
  endtry
endfunction

" tabpagebuffer#command#bnext({command} [, {count}])
" tabpagebuffer#command#bprevious({command} [, {count}])
" tabpagebuffer#command#bmodified_next({command} [, {count}])
" tabpagebuffer#command#bmodified_previous({command} [, {count}])
" E84: No modified buffer found
" E87: Cannot go beyond last buffer
" E88: Cannot go before first buffer
" E488: Trailing characters
function! s:bnext(forward, modified, command, count)
  let bufs = sort(
  \ filter(tabpagebuffer#function#buflist(),
  \   'buflisted(v:val) && (!a:modified || getbufvar(v:val, "&modified"))'),
  \ s:numerical_sort)
  " echo 'bufs:' bufs
  if empty(bufs)
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
  call s:bnext(1, 0, a:command, get(a:000, 0, 1))
endfunction
function! tabpagebuffer#command#bprevious(command, ...)
  call s:bnext(0, 0, a:command, get(a:000, 0, 1))
endfunction
function! tabpagebuffer#command#bmodified_next(command, ...)
  call s:bnext(1, 1, a:command, get(a:000, 0, 1))
endfunction
function! tabpagebuffer#command#bmodified_previous(command, ...)
  call s:bnext(0, 1, a:command, get(a:000, 0, 1))
endfunction
function! tabpagebuffer#command#do_bnext(forward, modified, command, count, args)
  try
    let p = matchstr(a:args, '^+.*\\\@<! \+')
    let r = a:args[strlen(p):]
    if r =~ '\D'
      throw join(['tabpagebuffer-misc:E488',
      \ 'Trailing characters'])
    endif
    call s:bnext(a:forward, a:modified,
    \ join([a:command, p]),
    \ !empty(r) ? str2nr(r) : a:count ? a:count : 1)
  catch /.*/
    call s:echoerr(v:exception)
  endtry
endfunction

" tabpagebuffer#command#bfirst({command})
" tabpagebuffer#command#blast({command})
" tabpagebuffer#command#bmodified_first({command})
" tabpagebuffer#command#bmodified_last({command})
" E84: No modified buffer found
function! s:brewind(forward, modified, command)
  let bufs = sort(
  \ filter(tabpagebuffer#function#buflist(),
  \   'buflisted(v:val) && (!a:modified || getbufvar(v:val, "&modified"))'),
  \ s:numerical_sort)
  " echo 'bufs:' bufs
  if empty(bufs)
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
function! tabpagebuffer#command#bfirst(command)
  call s:brewind(0, 0, a:command)
endfunction
function! tabpagebuffer#command#blast(command)
  call s:brewind(1, 0, a:command)
endfunction
function! tabpagebuffer#command#bmodified_first(command)
  call s:brewind(0, 1, a:command)
endfunction
function! tabpagebuffer#command#bmodified_last(command)
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
  let bufs = reverse(sort(
  \ filter(tabpagebuffer#function#buflist(),
  \   'buflisted(v:val) && (!a:loaded || bufloaded(v:val))'),
  \ s:numerical_sort))
  " echo 'bufs:' bufs
  if empty(bufs)
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
  call s:unhide(1, a:command, get(a:000, 0, 1))
endfunction
function! tabpagebuffer#command#ball(command, ...)
  call s:unhide(0, a:command, get(a:000, 0, 1))
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
