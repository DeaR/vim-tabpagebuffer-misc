" CtrlP function for the buffer belonging to the tab page.
"
" Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
" Last Change:  08-Oct-2015.
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

if exists('g:loaded_ctrlp_tabpagebuffer') && g:loaded_ctrlp_tabpagebuffer
  finish
endif
let g:loaded_ctrlp_tabpagebuffer = 1

call add(g:ctrlp_ext_vars, {
\ 'init'   : 'ctrlp#tabpagebuffer#init(s:crbufnr)',
\ 'accept' : 'ctrlp#tabpagebuffer#accept',
\ 'lname'  : 'tabpagebuffer',
\ 'sname'  : 'tpb',
\ 'exit'   : 'ctrlp#tabpagebuffer#exit()',
\ 'type'   : 'path'})

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)

function! s:compmreb(...)
  return ctrlp#call('s:compmreb', a:1, a:2)
endfunction

function! ctrlp#tabpagebuffer#init(crbufnr)
  let tabnr = exists('s:tabnr') ? s:tabnr : tabpagenr()
  let bufs = [[], []]
  for bufnr in sort(filter(tabpagebuffer#function#buflist(tabnr),
  \ 'empty(getbufvar(v:val, "&buftype")) && buflisted(v:val)'), 's:compmreb')
    let name = bufname(bufnr)
    let noname = empty(name)
    let fname = fnamemodify(
    \ noname ? ('[' . bufnr . '*No Name]') : name, ':.')
    let idc =   (bufnr == bufnr('#')   ? '#' : '') .
    \ (getbufvar(bufnr, '&modifiable') ? '' : '-') .
    \ (getbufvar(bufnr, '&readonly')   ? '=' : '') .
    \ (getbufvar(bufnr, '&modified')   ? '+' : '')
    let fname .= !empty(idc) ? ("\t" . idc) : ''
    call add(bufs[noname], fname)
  endfor
  return bufs[0] + bufs[1]
endfunction

function! ctrlp#tabpagebuffer#accept(mode, str)
  let fname = get(split(a:str, "\t"), 0, a:str)
  call ctrlp#acceptfile(a:mode, fname)
endfunction

function! ctrlp#tabpagebuffer#cmd(...)
  if a:0
    let s:tabnr = a:1
  endif
  return s:id
endfunction

function! ctrlp#tabpagebuffer#exit()
  unlet! s:tabnr
endfunction
