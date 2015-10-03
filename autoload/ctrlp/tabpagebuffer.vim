" CtrlP function for the buffer belonging to the tab page.
"
" Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
" Last Change:  02-Oct-2015.
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
\ 'init'   : 'ctrlp#tabpagebuffer#init()',
\ 'accept' : 'ctrlp#acceptfile',
\ 'lname'  : 'tabpagebuffer',
\ 'sname'  : 'tpb',
\ 'exit'   : 'ctrlp#tabpagebuffer#exit()',
\ 'type'   : 'path'})

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)

function! ctrlp#tabpagebuffer#init()
  let tabnr = exists('s:tabnr') ? s:tabnr : tabpagenr()
  let ids = filter(tabpagebuffer#function#buflist(tabnr),
  \ 'empty(getbufvar(v:val, "&buftype")) && buflisted(v:val)')

  let bufs = [[], []]
  for id in ids
    let bname = bufname(id)
    let ebname = bname == ''
    let fname = fnamemodify(ebname ? ('[' . id . '*No Name]') : bname, ':.')
    call add(bufs[ebname], fname)
  endfor
  return bufs[0] + bufs[1]
endfunction

function! ctrlp#tabpagebuffer#cmd(...)
  let s:tabnr = get(a:000, 0, tabpagenr())
  return s:id
endfunction

function! ctrlp#tabpagebuffer#exit()
  unlet! s:tabnr
endfunction
