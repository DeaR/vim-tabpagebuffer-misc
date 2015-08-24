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

if exists('g:loaded_tabpagebuffer_excmds')
  finish
endif
let g:loaded_tabpagebuffer_excmds = 1

let s:save_cpo = &cpo
set cpo&vim

let g:tabpagebuffer#excmds#delete_keeptabpage =
  \ get(g:, 'tabpagebuffer#excmds#delete_keeptabpage', 0)

command! -bang -bar
  \ TpbFiles
  \ call tabpagebuffer#excmds#ls('files<bang>')
command! -bang -bar
  \ TpbBuffers
  \ call tabpagebuffer#excmds#ls('buffers<bang>')
command! -bang -bar
  \ TpbLs
  \ call tabpagebuffer#excmds#ls('ls<bang>')

command! -bang -bar -range=0 -nargs=* -complete=buffer
  \ TpbDelete
  \ call tabpagebuffer#excmds#delete('bdelete<bang>',
  \   extend([<f-args>], <count> ? range(<line1>, <line2>, 1) : ['%']))
command! -bang -bar -range=0 -nargs=* -complete=buffer
  \ TpbWipeout
  \ call tabpagebuffer#excmds#delete('bwipeout<bang>',
  \   extend([<f-args>], <count> ? range(<line1>, <line2>, 1) : ['%']))
command! -bang -bar -range=0 -nargs=* -complete=buffer
  \ TpbUnload
  \ call tabpagebuffer#excmds#delete('bunload<bang>',
  \   extend([<f-args>], <count> ? range(<line1>, <line2>, 1) : ['%']))

command! -bang -bar
  \ TpbDeleteAll
  \ call tabpagebuffer#excmds#delete_all('bdelete<bang>')
command! -bang -bar
  \ TpbWipeoutAll
  \ call tabpagebuffer#excmds#delete_all('bwipeout<bang>')
command! -bang -bar
  \ TpbUnloadAll
  \ call tabpagebuffer#excmds#delete_all('bunload<bang>')

command! -bang -bar -range=0 -nargs=?
  \ TpbBuffer
  \ call tabpagebuffer#excmds#buffer('buffer<bang>',
  \   strlen(<q-args>) ? <q-args> : <count> ? <line1> : '%' )
command! -bar -range=0 -nargs=?
  \ STpbBuffer
  \ call tabpagebuffer#excmds#buffer('sbuffer',
  \   strlen(<q-args>) ? <q-args> : <count> ? <line1> : '%' )
command! -bar -range=0 -nargs=?
  \ VTpbBuffer
  \ call tabpagebuffer#excmds#buffer('vertical sbuffer',
  \   strlen(<q-args>) ? <q-args> : <count> ? <line1> : '%' )
command! -bar -range=0 -nargs=?
  \ TTpbBuffer
  \ call tabpagebuffer#excmds#buffer('tab sbuffer',
  \   strlen(<q-args>) ? <q-args> : <count> ? <line1> : '%' )

command! -bang -bar -range=0 -nargs=?
  \ TpbNext
  \ call tabpagebuffer#excmds#next('buffer<bang>', 1, 0,
  \   strlen(<q-args>) ? <q-args> : <count> ? <line1> : 1 )
command! -bang -bar -range=0 -nargs=?
  \ TpbPrevious
  \ call tabpagebuffer#excmds#next('buffer<bang>', 0, 0,
  \   strlen(<q-args>) ? <q-args> : <count> ? <line1> : 1 )
command! -bang -bar -range=0 -nargs=?
  \ TpbModified
  \ call tabpagebuffer#excmds#next('buffer<bang>', 1, 1,
  \   strlen(<q-args>) ? <q-args> : <count> ? <line1> : 1 )
command! -bang -bar -range=0 -nargs=?
  \ TpbModifiedNext
  \ call tabpagebuffer#excmds#next('buffer<bang>', 1, 1,
  \   strlen(<q-args>) ? <q-args> : <count> ? <line1> : 1 )
command! -bang -bar -range=0 -nargs=?
  \ TpbModifiedPrevious
  \ call tabpagebuffer#excmds#next('buffer<bang>', 0, 1,
  \   strlen(<q-args>) ? <q-args> : <count> ? <line1> : 1 )
command! -bar -range=0 -nargs=?
  \ STpbNext
  \ call tabpagebuffer#excmds#next('sbuffer', 1, 0,
  \   strlen(<q-args>) ? <q-args> : <count> ? <line1> : 1 )
command! -bar -range=0 -nargs=?
  \ STpbPrevious
  \ call tabpagebuffer#excmds#next('sbuffer', 0, 0,
  \   strlen(<q-args>) ? <q-args> : <count> ? <line1> : 1 )
command! -bar -range=0 -nargs=?
  \ STpbModified
  \ call tabpagebuffer#excmds#next('sbuffer', 1, 1,
  \   strlen(<q-args>) ? <q-args> : <count> ? <line1> : 1 )
command! -bar -range=0 -nargs=?
  \ STpbModifiedNext
  \ call tabpagebuffer#excmds#next('sbuffer', 1, 1,
  \   strlen(<q-args>) ? <q-args> : <count> ? <line1> : 1 )
command! -bar -range=0 -nargs=?
  \ STpbModifiedPrevious
  \ call tabpagebuffer#excmds#next('sbuffer', 0, 1,
  \   strlen(<q-args>) ? <q-args> : <count> ? <line1> : 1 )
command! -bar -range=0 -nargs=?
  \ VTpbNext
  \ call tabpagebuffer#excmds#next('vertical sbuffer', 1, 0,
  \   strlen(<q-args>) ? <q-args> : <count> ? <line1> : 1 )
command! -bar -range=0 -nargs=?
  \ VTpbPrevious
  \ call tabpagebuffer#excmds#next('vertical sbuffer', 0, 0,
  \   strlen(<q-args>) ? <q-args> : <count> ? <line1> : 1 )
command! -bar -range=0 -nargs=?
  \ VTpbModified
  \ call tabpagebuffer#excmds#next('vertical sbuffer', 1, 1,
  \   strlen(<q-args>) ? <q-args> : <count> ? <line1> : 1 )
command! -bar -range=0 -nargs=?
  \ VTpbModifiedNext
  \ call tabpagebuffer#excmds#next('vertical sbuffer', 1, 1,
  \   strlen(<q-args>) ? <q-args> : <count> ? <line1> : 1 )
command! -bar -range=0 -nargs=?
  \ VTpbModifiedPrevious
  \ call tabpagebuffer#excmds#next('vertical sbuffer', 0, 1,
  \   strlen(<q-args>) ? <q-args> : <count> ? <line1> : 1 )
command! -bar -range=0 -nargs=?
  \ TTpbNext
  \ call tabpagebuffer#excmds#next('tab sbuffer', 1, 0,
  \   strlen(<q-args>) ? <q-args> : <count> ? <line1> : 1 )
command! -bar -range=0 -nargs=?
  \ TTpbPrevious
  \ call tabpagebuffer#excmds#next('tab sbuffer', 0, 0,
  \   strlen(<q-args>) ? <q-args> : <count> ? <line1> : 1 )
command! -bar -range=0 -nargs=?
  \ TTpbModified
  \ call tabpagebuffer#excmds#next('tab sbuffer', 1, 1,
  \   strlen(<q-args>) ? <q-args> : <count> ? <line1> : 1 )
command! -bar -range=0 -nargs=?
  \ TTpbModifiedNext
  \ call tabpagebuffer#excmds#next('tab sbuffer', 1, 1,
  \   strlen(<q-args>) ? <q-args> : <count> ? <line1> : 1 )
command! -bar -range=0 -nargs=?
  \ TTpbModifiedPrevious
  \ call tabpagebuffer#excmds#next('tab sbuffer', 0, 1,
  \   strlen(<q-args>) ? <q-args> : <count> ? <line1> : 1 )

command! -bang -bar
  \ TpbRewind
  \ call tabpagebuffer#excmds#rewind('buffer<bang>', 0, 0)
command! -bang -bar
  \ TpbFirst
  \ call tabpagebuffer#excmds#rewind('buffer<bang>', 0, 0)
command! -bang -bar
  \ TpbLast
  \ call tabpagebuffer#excmds#rewind('buffer<bang>', 1, 0)
command! -bang -bar
  \ TpbModifiedRewind
  \ call tabpagebuffer#excmds#rewind('buffer<bang>', 0, 1)
command! -bang -bar
  \ TpbModifiedFirst
  \ call tabpagebuffer#excmds#rewind('buffer<bang>', 0, 1)
command! -bang -bar
  \ TpbModifiedLast
  \ call tabpagebuffer#excmds#rewind('buffer<bang>', 1, 1)
command! -bar
  \ STpbRewind
  \ call tabpagebuffer#excmds#rewind('sbuffer', 0, 0)
command! -bar
  \ STpbFirst
  \ call tabpagebuffer#excmds#rewind('sbuffer', 0, 0)
command! -bar
  \ STpbLast
  \ call tabpagebuffer#excmds#rewind('sbuffer', 1, 0)
command! -bar
  \ STpbModifiedRewind
  \ call tabpagebuffer#excmds#rewind('sbuffer', 0, 1)
command! -bar
  \ STpbModifiedFirst
  \ call tabpagebuffer#excmds#rewind('sbuffer', 0, 1)
command! -bar
  \ STpbModifiedLast
  \ call tabpagebuffer#excmds#rewind('sbuffer', 1, 1)
command! -bar
  \ VTpbRewind
  \ call tabpagebuffer#excmds#rewind('vertical sbuffer', 0, 0)
command! -bar
  \ VTpbFirst
  \ call tabpagebuffer#excmds#rewind('vertical sbuffer', 0, 0)
command! -bar
  \ VTpbLast
  \ call tabpagebuffer#excmds#rewind('vertical sbuffer', 1, 0)
command! -bar
  \ VTpbModifiedRewind
  \ call tabpagebuffer#excmds#rewind('vertical sbuffer', 0, 1)
command! -bar
  \ VTpbModifiedFirst
  \ call tabpagebuffer#excmds#rewind('vertical sbuffer', 0, 1)
command! -bar
  \ VTpbModifiedLast
  \ call tabpagebuffer#excmds#rewind('vertical sbuffer', 1, 1)
command! -bar
  \ TTpbRewind
  \ call tabpagebuffer#excmds#rewind('tab sbuffer', 0, 0)
command! -bar
  \ TTpbFirst
  \ call tabpagebuffer#excmds#rewind('tab sbuffer', 0, 0)
command! -bar
  \ TTpbLast
  \ call tabpagebuffer#excmds#rewind('tab sbuffer', 1, 0)
command! -bar
  \ TTpbModifiedRewind
  \ call tabpagebuffer#excmds#rewind('tab sbuffer', 0, 1)
command! -bar
  \ TTpbModifiedFirst
  \ call tabpagebuffer#excmds#rewind('tab sbuffer', 0, 1)
command! -bar
  \ TTpbModifiedLast
  \ call tabpagebuffer#excmds#rewind('tab sbuffer', 1, 1)

command! -bar -range=0 -nargs=?
  \ TpbUnhide
  \ call tabpagebuffer#excmds#unhide('sbuffer', 1,
  \   strlen(<q-args>) ? <q-args> : <count> ? <line1> : bufnr('$') )
command! -bar -range=0 -nargs=?
  \ STpbUnhide
  \ call tabpagebuffer#excmds#unhide('sbuffer', 1,
  \   strlen(<q-args>) ? <q-args> : <count> ? <line1> : bufnr('$') )
command! -bar -range=0 -nargs=?
  \ VTpbUnhide
  \ call tabpagebuffer#excmds#unhide('vertical sbuffer', 1,
  \   strlen(<q-args>) ? <q-args> : <count> ? <line1> : bufnr('$') )
command! -bar -range=0 -nargs=?
  \ TTpbUnhide
  \ call tabpagebuffer#excmds#unhide('tab sbuffer', 1,
  \   strlen(<q-args>) ? <q-args> : <count> ? <line1> : bufnr('$') )

command! -bar -range=0 -nargs=?
  \ TpbAll
  \ call tabpagebuffer#excmds#unhide('sbuffer', 0,
  \   strlen(<q-args>) ? <q-args> : <count> ? <line1> : bufnr('$') )
command! -bar -range=0 -nargs=?
  \ STpbAll
  \ call tabpagebuffer#excmds#unhide('sbuffer', 0,
  \   strlen(<q-args>) ? <q-args> : <count> ? <line1> : bufnr('$') )
command! -bar -range=0 -nargs=?
  \ VTpbAll
  \ call tabpagebuffer#excmds#unhide('vertical sbuffer', 0,
  \   strlen(<q-args>) ? <q-args> : <count> ? <line1> : bufnr('$') )
command! -bar -range=0 -nargs=?
  \ TTpbAll
  \ call tabpagebuffer#excmds#unhide('tab sbuffer', 0,
  \   strlen(<q-args>) ? <q-args> : <count> ? <line1> : bufnr('$') )

let &cpo = s:save_cpo
unlet s:save_cpo
