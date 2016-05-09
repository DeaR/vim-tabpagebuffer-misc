" CtrlP function for the buffer belonging to the tab page.
"
" Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
" Last Change:  09-May-2016.
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

function! s:syntax()
  if !ctrlp#nosy() && ctrlp#getvar('s:has_conceal')
    for [ke, va] in items(ctrlp#getvar('s:hlgrps'))
      call ctrlp#hicheck('CtrlP' . ke, va)
    endfor

    syntax region CtrlPBufferNr     concealends matchgroup=Ignore start='<nr>' end='</nr>'
    syntax region CtrlPBufferInd    concealends matchgroup=Ignore start='<bi>' end='</bi>'
    syntax region CtrlPBufferRegion concealends matchgroup=Ignore start='<bn>' end='</bn>'
    \ contains=CtrlPBufferHid,CtrlPBufferHidMod,CtrlPBufferVis,CtrlPBufferVisMod,CtrlPBufferCur,CtrlPBufferCurMod
    syntax region CtrlPBufferHid    concealends matchgroup=Ignore     start='\s*{' end='}' contained
    syntax region CtrlPBufferHidMod concealends matchgroup=Ignore    start='+\s*{' end='}' contained
    syntax region CtrlPBufferVis    concealends matchgroup=Ignore   start='\*\s*{' end='}' contained
    syntax region CtrlPBufferVisMod concealends matchgroup=Ignore  start='\*+\s*{' end='}' contained
    syntax region CtrlPBufferCur    concealends matchgroup=Ignore  start='\*!\s*{' end='}' contained
    syntax region CtrlPBufferCurMod concealends matchgroup=Ignore start='\*+!\s*{' end='}' contained
    syntax region CtrlPBufferPath   concealends matchgroup=Ignore start='<bp>' end='</bp>'
  endif
endfunction

function! ctrlp#tabpagebuffer#init(crbufnr)
  let tabnr = exists('s:tabnr') ? s:tabnr : tabpagenr()
  let bufs = [[], []]
  for bufnr in sort(filter(tabpagebuffer#function#buflist(tabnr),
  \ 'empty(getbufvar(v:val, "&buftype")) && buflisted(v:val)'), 's:compmreb')
    let parts = ctrlp#call('s:bufparts', bufnr)
    if !ctrlp#nosy() && ctrlp#getvar('s:has_conceal')
      let str = printf('<nr>%' . ctrlp#getvar('s:bufnr_width') . 's</nr>', bufnr)
      let str .= printf(' %-13s %s%-36s',
      \ '<bi>' . parts[0] . '</bi>',
      \ '<bn>' . parts[1], '{' . parts[2] . '}</bn>')
      if !empty(ctrlp#getvar('s:bufpath_mod'))
        let str .= printf('  %s', '<bp>' . parts[3] . '</bp>')
      endif
    else
      let str = printf('%' . ctrlp#getvar('s:bufnr_width') . 's', bufnr)
      let str .= printf(' %-5s %-30s',
      \ parts[0],
      \ parts[2])
      if !empty(ctrlp#getvar('s:bufpath_mod'))
        let str .= printf('  %s', parts[3])
      endif
    endif
    call add(bufs[empty(bufname(bufnr))], str)
  endfor

  call s:syntax()
  return bufs[0] + bufs[1]
endfunction

function! ctrlp#tabpagebuffer#accept(mode, str)
  let bufnr = str2nr(matchstr(a:str, '^\%(<nr>\)\?\s*\zs\d\+'))
  call ctrlp#acceptfile(a:mode, bufnr)
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
