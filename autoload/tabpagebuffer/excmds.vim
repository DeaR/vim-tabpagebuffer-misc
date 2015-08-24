" ExCmd for Tabpage Buffer
"
" Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
" Last Change:  24-Aug-2015.
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

function! s:echoerr(...)
  echohl ErrorMsg
  echomsg join(a:000)
  echohl None
endfunction

function! s:execute(...)
  try
    " echo 'execute:' join(a:000)
    execute join(a:000)
  catch /.*/
    call s:echoerr(v:exception)
  endtry
endfunction

function! s:executes(exprs)
  try
    for expr in a:exprs
      " echo 'execute:' join(expr)
      execute join(expr)
    endfor
  catch /.*/
    call s:echoerr(v:exception)
  endtry
endfunction

function! s:doautocmd(...)
  if has('patch-7.3.438') || v:version > 703 ||
    \ (v:version == 703 && has('patch438'))
    execute 'doautocmd' '<nomodeline>' join(a:000)
  else
    execute 'doautocmd' join(a:000)
  endif
endfunction

function! s:get_tabpagebuffer()
  if exists('g:loaded_tabpagebuffer')
    return map(keys(get(t:, 'tabpagebuffer', {})), 'str2nr(v:val)')
  elseif exists('g:CtrlSpaceLoaded')
    return map(keys(get(t:, 'CtrlSpaceList', {})), 'str2nr(v:val)')
  else
    call s:echoerr('tabpagebuffer-excmds:',
      \ 'tabpagebuffer or ctrlspace plugin is not installed.')
  endif
endfunction

function! s:numerical_sort(i1, i2)
  return a:i1 - a:i2
endfunction

function! tabpagebuffer#excmds#ls(command)
  redir => out
  silent execute a:command
  redir END
  let tpb = s:get_tabpagebuffer()
  for buf in filter(split(out, '\n'),
    \ 'index(tpb, str2nr(matchstr(v:val, "\\d\\+"))) >= 0')
    echo buf
  endfor
endfunction

function! tabpagebuffer#excmds#delete(command, args)
  let tpb = s:get_tabpagebuffer()
  let bufs = filter(
    \ map(a:args, 'v:val =~ "^\\d\\+$" ? str2nr(v:val) : bufnr(v:val)'),
    \ 'index(tpb, v:val) >= 0')
  " echo 'bufs:' bufs
  if !len(bufs)
    " E516
    return
  endif

  let cancel = ''
  if g:tabpagebuffer#excmds#delete_keeptabpage && tabpagenr('$') > 1
    let pop = get(filter(s:get_tabpagebuffer(),
      \ 'buflisted(v:val) && index(bufs, v:val) < 0'), -1)
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
    call s:execute(a:command, join(bufs))
  finally
    " echo 'cancel:' cancel
    if winnr('$') > 1
      execute cancel
    endif
  endtry
endfunction

function! tabpagebuffer#excmds#delete_all(command)
  call tabpagebuffer#excmds#delete(a:command, s:get_tabpagebuffer())
endfunction

function! tabpagebuffer#excmds#buffer(command, count)
  let pop = a:count =~ '^\d\+$' ? str2nr(a:count) : bufnr(a:count)
  " echo 'pop:' pop
  if index(s:get_tabpagebuffer(), pop) < 0
    " E86
    return
  endif

  call s:execute(a:command, pop)
endfunction

function! tabpagebuffer#excmds#next(command, forward, modified, count)
  let bufs = filter(s:get_tabpagebuffer(),
    \ 'buflisted(v:val) && (!a:modified || getbufvar(v:val, "&modified"))')
  " echo 'bufs:' bufs
  if !len(bufs)
    " E84
    return
  endif

  let bufs = sort(bufs,
    \ has('patch-7.4.341') ? 'n' : 's:numerical_sort')
  let cur = index(bufs, bufnr('%'))
  let pop = bufs[(cur + (a:forward ? a:count : -a:count)) % len(bufs)]
  " echo 'pop:' pop

  call s:execute(a:command, pop)
endfunction

function! tabpagebuffer#excmds#rewind(command, forward, modified)
  let bufs = filter(s:get_tabpagebuffer(),
    \ 'buflisted(v:val) && (!a:modified || getbufvar(v:val, "&modified"))')
  " echo 'bufs:' bufs
  if !len(bufs)
    return
  endif

  let bufs = sort(bufs,
    \ has('patch-7.4.341') ? 'n' : 's:numerical_sort')
  let pop = a:forward ? bufs[-1] : bufs[0]
  " echo 'pop:' pop

  call s:execute(a:command, pop)
endfunction

function! tabpagebuffer#excmds#unhide(command, loaded, count)
  let bufs = filter(s:get_tabpagebuffer(),
    \ 'buflisted(v:val) && (!a:loaded || bufloaded(v:val))')
  " echo 'bufs:' bufs
  if !len(bufs)
    return
  endif

  let bufs = reverse(sort(bufs,
    \ has('patch-7.4.341') ? 'n' : 's:numerical_sort'))

  call s:execute('silent', 'only!')
  if len(bufs) > 1
    let save_ei = &eventignore
    try
      set eventignore+=BufLeave,WinLeave,BufEnter,WinEnter
      call s:execute('buffer!', bufs[0])
      call s:executes(map((bufs[:a:count])[1:-1], '[a:command, v:val]'))
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

let &cpo = s:save_cpo
unlet s:save_cpo
