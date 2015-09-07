" To control the buffer belonging to the tab page.
"
" Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
" Last Change:  07-Sep-2015.
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

if exists('g:loaded_tabpagebuffer_misc')
  finish
endif
let g:loaded_tabpagebuffer_misc = 1

let s:save_cpo = &cpo
set cpo&vim

command! -bang -bar
\ TpbFiles
\ call tabpagebuffer#command#do_ls('files<bang>')
command! -bang -bar
\ TpbBuffers
\ call tabpagebuffer#command#do_ls('buffers<bang>')
command! -bang -bar
\ TpbLs
\ call tabpagebuffer#command#do_ls('ls<bang>')

command! -bang -bar -range=0 -nargs=* -complete=buffer
\ TpbDelete
\ call tabpagebuffer#command#do_bdelete('bdelete<bang>',
\   <count>, <line1>, <line2>, <q-args>)
command! -bang -bar -range=0 -nargs=* -complete=buffer
\ TpbWipeout
\ call tabpagebuffer#command#do_bdelete('bwipeout<bang>',
\   <count>, <line1>, <line2>, <q-args>)
command! -bang -bar -range=0 -nargs=* -complete=buffer
\ TpbUnload
\ call tabpagebuffer#command#do_bdelete('bunload<bang>',
\   <count>, <line1>, <line2>, <q-args>)

command! -bang -bar -count
\ TpbDeleteAll
\ call tabpagebuffer#command#do_bdelete_all('bdelete<bang>',
\   <count>)
command! -bang -bar -count
\ TpbWipeoutAll
\ call tabpagebuffer#command#do_bdelete_all('bwipeout<bang>',
\   <count>)
command! -bang -bar -count
\ TpbUnloadAll
\ call tabpagebuffer#command#do_bdelete_all('bunload<bang>',
\   <count>)

command! -bang -bar -count -nargs=? -complete=buffer
\ TpbBuffer
\ call tabpagebuffer#command#do_buffer('buffer<bang>',
\   <count>, <q-args>)
command! -bar -count -nargs=? -complete=buffer
\ STpbBuffer
\ call tabpagebuffer#command#do_buffer('sbuffer',
\   <count>, <q-args>)
command! -bar -count -nargs=? -complete=buffer
\ VTpbBuffer
\ call tabpagebuffer#command#do_buffer('vertical sbuffer',
\   <count>, <q-args>)
command! -bar -count -nargs=? -complete=buffer
\ TTpbBuffer
\ call tabpagebuffer#command#do_buffer('tab sbuffer',
\   <count>, <q-args>)

command! -bang -bar -count -nargs=?
\ TpbNext
\ call tabpagebuffer#command#do_bnext(1, 0, 'buffer<bang>',
\   <count>, <q-args>)
command! -bang -bar -count -nargs=?
\ TpbPrevious
\ call tabpagebuffer#command#do_bnext(0, 0, 'buffer<bang>',
\   <count>, <q-args>)
command! -bang -bar -count -nargs=?
\ TpbModified
\ call tabpagebuffer#command#do_bnext(1, 1, 'buffer<bang>',
\   <count>, <q-args>)
command! -bang -bar -count -nargs=?
\ TpbModifiedNext
\ call tabpagebuffer#command#do_bnext(1, 1, 'buffer<bang>',
\   <count>, <q-args>)
command! -bang -bar -count -nargs=?
\ TpbModifiedPrevious
\ call tabpagebuffer#command#do_bnext(0, 1, 'buffer<bang>',
\   <count>, <q-args>)
command! -bar -count -nargs=?
\ STpbNext
\ call tabpagebuffer#command#do_bnext(1, 0, 'sbuffer',
\   <count>, <q-args>)
command! -bar -count -nargs=?
\ STpbPrevious
\ call tabpagebuffer#command#do_bnext(0, 0, 'sbuffer',
\   <count>, <q-args>)
command! -bar -count -nargs=?
\ STpbModified
\ call tabpagebuffer#command#do_bnext(1, 1, 'sbuffer',
\   <count>, <q-args>)
command! -bar -count -nargs=?
\ STpbModifiedNext
\ call tabpagebuffer#command#do_bnext(1, 1, 'sbuffer',
\   <count>, <q-args>)
command! -bar -count -nargs=?
\ STpbModifiedPrevious
\ call tabpagebuffer#command#do_bnext(0, 1, 'sbuffer',
\   <count>, <q-args>)
command! -bar -count -nargs=?
\ VTpbNext
\ call tabpagebuffer#command#do_bnext(1, 0, 'vertical sbuffer',
\   <count>, <q-args>)
command! -bar -count -nargs=?
\ VTpbPrevious
\ call tabpagebuffer#command#do_bnext(0, 0, 'vertical sbuffer',
\   <count>, <q-args>)
command! -bar -count -nargs=?
\ VTpbModified
\ call tabpagebuffer#command#do_bnext(1, 1, 'vertical sbuffer',
\   <count>, <q-args>)
command! -bar -count -nargs=?
\ VTpbModifiedNext
\ call tabpagebuffer#command#do_bnext(1, 1, 'vertical sbuffer',
\   <count>, <q-args>)
command! -bar -count -nargs=?
\ VTpbModifiedPrevious
\ call tabpagebuffer#command#do_bnext(0, 1, 'vertical sbuffer',
\   <count>, <q-args>)
command! -bar -count -nargs=?
\ TTpbNext
\ call tabpagebuffer#command#do_bnext(1, 0, 'tab sbuffer',
\   <count>, <q-args>)
command! -bar -count -nargs=?
\ TTpbPrevious
\ call tabpagebuffer#command#do_bnext(0, 0, 'tab sbuffer',
\   <count>, <q-args>)
command! -bar -count -nargs=?
\ TTpbModified
\ call tabpagebuffer#command#do_bnext(1, 1, 'tab sbuffer',
\   <count>, <q-args>)
command! -bar -count -nargs=?
\ TTpbModifiedNext
\ call tabpagebuffer#command#do_bnext(1, 1, 'tab sbuffer',
\   <count>, <q-args>)
command! -bar -count -nargs=?
\ TTpbModifiedPrevious
\ call tabpagebuffer#command#do_bnext(0, 1, 'tab sbuffer',
\   <count>, <q-args>)

command! -bang -bar -nargs=?
\ TpbRewind
\ call tabpagebuffer#command#do_brewind(0, 0, 'buffer<bang>',
\   <q-args>)
command! -bang -bar -nargs=?
\ TpbFirst
\ call tabpagebuffer#command#do_brewind(0, 0, 'buffer<bang>',
\   <q-args>)
command! -bang -bar -nargs=?
\ TpbLast
\ call tabpagebuffer#command#do_brewind(1, 0, 'buffer<bang>',
\   <q-args>)
command! -bang -bar -nargs=?
\ TpbModifiedRewind
\ call tabpagebuffer#command#do_brewind(0, 1, 'buffer<bang>',
\   <q-args>)
command! -bang -bar -nargs=?
\ TpbModifiedFirst
\ call tabpagebuffer#command#do_brewind(0, 1, 'buffer<bang>',
\   <q-args>)
command! -bang -bar -nargs=?
\ TpbModifiedLast
\ call tabpagebuffer#command#do_brewind(1, 1, 'buffer<bang>',
\   <q-args>)
command! -bar -nargs=?
\ STpbRewind
\ call tabpagebuffer#command#do_brewind(0, 0, 'sbuffer'
\   <q-args>)
command! -bar -nargs=?
\ STpbFirst
\ call tabpagebuffer#command#do_brewind(0, 0, 'sbuffer'
\   <q-args>)
command! -bar -nargs=?
\ STpbLast
\ call tabpagebuffer#command#do_brewind(1, 0, 'sbuffer'
\   <q-args>)
command! -bar -nargs=?
\ STpbModifiedRewind
\ call tabpagebuffer#command#do_brewind(0, 1, 'sbuffer'
\   <q-args>)
command! -bar -nargs=?
\ STpbModifiedFirst
\ call tabpagebuffer#command#do_brewind(0, 1, 'sbuffer'
\   <q-args>)
command! -bar -nargs=?
\ STpbModifiedLast
\ call tabpagebuffer#command#do_brewind(1, 1, 'sbuffer'
\   <q-args>)
command! -bar -nargs=?
\ VTpbRewind
\ call tabpagebuffer#command#do_brewind(0, 0, 'vertical sbuffer'
\   <q-args>)
command! -bar -nargs=?
\ VTpbFirst
\ call tabpagebuffer#command#do_brewind(0, 0, 'vertical sbuffer'
\   <q-args>)
command! -bar -nargs=?
\ VTpbLast
\ call tabpagebuffer#command#do_brewind(1, 0, 'vertical sbuffer'
\   <q-args>)
command! -bar -nargs=?
\ VTpbModifiedRewind
\ call tabpagebuffer#command#do_brewind(0, 1, 'vertical sbuffer'
\   <q-args>)
command! -bar -nargs=?
\ VTpbModifiedFirst
\ call tabpagebuffer#command#do_brewind(0, 1, 'vertical sbuffer'
\   <q-args>)
command! -bar -nargs=?
\ VTpbModifiedLast
\ call tabpagebuffer#command#do_brewind(1, 1, 'vertical sbuffer'
\   <q-args>)
command! -bar -nargs=?
\ TTpbRewind
\ call tabpagebuffer#command#do_brewind(0, 0, 'tab sbuffer'
\   <q-args>)
command! -bar -nargs=?
\ TTpbFirst
\ call tabpagebuffer#command#do_brewind(0, 0, 'tab sbuffer'
\   <q-args>)
command! -bar -nargs=?
\ TTpbLast
\ call tabpagebuffer#command#do_brewind(1, 0, 'tab sbuffer'
\   <q-args>)
command! -bar -nargs=?
\ TTpbModifiedRewind
\ call tabpagebuffer#command#do_brewind(0, 1, 'tab sbuffer'
\   <q-args>)
command! -bar -nargs=?
\ TTpbModifiedFirst
\ call tabpagebuffer#command#do_brewind(0, 1, 'tab sbuffer'
\   <q-args>)
command! -bar -nargs=?
\ TTpbModifiedLast
\ call tabpagebuffer#command#do_brewind(1, 1, 'tab sbuffer'
\   <q-args>)

command! -bar -count
\ TpbUnhide
\ call tabpagebuffer#command#do_unhide(1, 'sbuffer',
\   <count>)
command! -bar -count
\ STpbUnhide
\ call tabpagebuffer#command#do_unhide(1, 'sbuffer',
\   <count>)
command! -bar -count
\ VTpbUnhide
\ call tabpagebuffer#command#do_unhide(1, 'vertical sbuffer',
\   <count>)
command! -bar -count
\ TTpbUnhide
\ call tabpagebuffer#command#do_unhide(1, 'tab sbuffer',
\   <count>)

command! -bar -count
\ TpbAll
\ call tabpagebuffer#command#do_unhide(0, 'sbuffer',
\   <count>)
command! -bar -count
\ STpbAll
\ call tabpagebuffer#command#do_unhide(0, 'sbuffer',
\   <count>)
command! -bar -count
\ VTpbAll
\ call tabpagebuffer#command#do_unhide(0, 'vertical sbuffer',
\   <count>)
command! -bar -count
\ TTpbAll
\ call tabpagebuffer#command#do_unhide(0, 'tab sbuffer',
\   <count>)

let &cpo = s:save_cpo
unlet s:save_cpo
