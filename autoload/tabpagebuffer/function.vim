" Functions for the buffer belonging to the tab page.
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

" fileio.c
function! s:file_pat_to_reg_pat(expr)
  if exists('*glob2regpat')
    return glob2regpat('*' . a:expr . '*')
  endif

  let s = []
  for c in split(a:expr, '\zs')
    if c == '*'
      call add(s, '.*')
    elseif c == '.' || c == '~'
      call add(s, '\' . c)
    elseif c == '?'
      call add(s, '.')
    elseif c == '\' || c == '/'
      call add(s, '[\/]')
    else
      call add(s, c)
    endif
  endfor
  return join(s, '')
endfunction

" tabpagebuffer#function#buflist([{tabnr}])
function! tabpagebuffer#function#buflist(...)
  let tabnr = get(a:000, 0, tabpagenr())
  if exists('g:loaded_tabpagebuffer')
    return filter(map(keys(gettabvar(tabnr, 'tabpagebuffer', {})),
      \ 'str2nr(v:val)'), 'bufexists(v:val)')
  elseif exists('g:CtrlSpaceLoaded')
    return filter(map(keys(gettabvar(tabnr, 'CtrlSpaceList', {})),
      \ 'str2nr(v:val)'), 'bufexists(v:val)')
  else
    throw join(['tabpagebuffer-misc:ETPB101:',
      \ 'tabpagebuffer or ctrlspace plugin is not installed'])
  endif
endfunction

" tabpagebuffer#function#bufexists({expr} [, {tabnr}])
function! tabpagebuffer#function#bufexists(expr, ...)
  let tabnr = get(a:000, 0, tabpagenr())
  return bufexists(a:expr) && len(filter(
    \ tabpagebuffer#function#buflist(tabnr),
    \ type(a:expr) == type(0) ?
    \   'v:val == a:expr' : 'bufname(v:val) == a:expr'))
endfunction

" tabpagebuffer#function#bufname({expr} [, {tabnr} [, {error}]])
" E93: More than one match for %s
" E94: No matching buffer for %s
function! tabpagebuffer#function#bufname(expr, ...)
  let tabnr = get(a:000, 0, tabpagenr())
  let error = get(a:000, 1)
  return bufname(tabpagebuffer#function#bufnr(a:expr, 0, tabnr, error))
endfunction

" tabpagebuffer#function#bufnr({expr} [, {create} [, {tabnr} [, {error}]]])
" E93: More than one match for %s
" E94: No matching buffer for %s
function! tabpagebuffer#function#bufnr(expr, ...)
  let create = get(a:000, 0)
  let tabnr  = get(a:000, 1, tabpagenr())
  let error  = get(a:000, 2)

  let nr = bufnr(a:expr, create)
  if nr >= 0 || type(a:expr) == type(0)
    if index(tabpagebuffer#function#buflist(tabnr), nr) >= 0
      return nr
    elseif error
      throw join(['tabpagebuffer-misc:E94:',
        \ 'No matching buffer for', a:expr])
    else
      return -1
    endif
  endif

  let regpat = join(['\m', &fileignorecase ? '\c' : '\C',
    \ s:glob2regpat(a:expr)], '')
  let bufs = filter(tabpagebuffer#function#buflist(tabnr),
    \ 'bufname(v:val) =~ regpat')
  if len(bufs) == 1
    return bufs[0]
  elseif error
    if len(bufs)
      throw join(['tabpagebuffer-misc:E93:',
        \ 'More than one match for', a:expr])
    else
      throw join(['tabpagebuffer-misc:E94:',
        \ 'No matching buffer for', a:expr])
    endif
  else
    return -1
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
