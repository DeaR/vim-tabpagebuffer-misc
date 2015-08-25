" ExCmd for Tabpage Buffer
"
" Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
" Last Change:  25-Aug-2015.
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
  \ call tabpagebuffer#excmds#delete_excmd('bdelete<bang>',
  \   <count>, <line1>, <line2>, <f-args>)
command! -bang -bar -range=0 -nargs=* -complete=buffer
  \ TpbWipeout
  \ call tabpagebuffer#excmds#delete_excmd('bwipeout<bang>',
  \   <count>, <line1>, <line2>, <f-args>)
command! -bang -bar -range=0 -nargs=* -complete=buffer
  \ TpbUnload
  \ call tabpagebuffer#excmds#delete_excmd('bunload<bang>',
  \   <count>, <line1>, <line2>, <f-args>)

command! -bang -bar -count
  \ TpbDeleteAll
  \ call tabpagebuffer#excmds#delete_all('bdelete<bang>',
  \   <count>)
command! -bang -bar -count
  \ TpbWipeoutAll
  \ call tabpagebuffer#excmds#delete_all('bwipeout<bang>',
  \   <count>)
command! -bang -bar -count
  \ TpbUnloadAll
  \ call tabpagebuffer#excmds#delete_all('bunload<bang>',
  \   <count>)

command! -bang -bar -count -nargs=? -complete=buffer
  \ TpbBuffer
  \ call tabpagebuffer#excmds#buffer_excmd('buffer<bang>',
  \   <count>, <q-args>)
command! -bar -count -nargs=? -complete=buffer
  \ STpbBuffer
  \ call tabpagebuffer#excmds#buffer_excmd('sbuffer',
  \   <count>, <q-args>)
command! -bar -count -nargs=? -complete=buffer
  \ VTpbBuffer
  \ call tabpagebuffer#excmds#buffer_excmd('vertical sbuffer',
  \   <count>, <q-args>)
command! -bar -count -nargs=? -complete=buffer
  \ TTpbBuffer
  \ call tabpagebuffer#excmds#buffer_excmd('tab sbuffer',
  \   <count>, <q-args>)

command! -bang -bar -count -nargs=?
  \ TpbNext
  \ call tabpagebuffer#excmds#next_excmd(1, 0, 'buffer<bang>',
  \   <count>, <q-args>)
command! -bang -bar -count -nargs=?
  \ TpbPrevious
  \ call tabpagebuffer#excmds#next_excmd(0, 0, 'buffer<bang>',
  \   <count>, <q-args>)
command! -bang -bar -count -nargs=?
  \ TpbModified
  \ call tabpagebuffer#excmds#next_excmd(1, 1, 'buffer<bang>',
  \   <count>, <q-args>)
command! -bang -bar -count -nargs=?
  \ TpbModifiedNext
  \ call tabpagebuffer#excmds#next_excmd(1, 1, 'buffer<bang>',
  \   <count>, <q-args>)
command! -bang -bar -count -nargs=?
  \ TpbModifiedPrevious
  \ call tabpagebuffer#excmds#next_excmd(0, 1, 'buffer<bang>',
  \   <count>, <q-args>)
command! -bar -count -nargs=?
  \ STpbNext
  \ call tabpagebuffer#excmds#next_excmd(1, 0, 'sbuffer',
  \   <count>, <q-args>)
command! -bar -count -nargs=?
  \ STpbPrevious
  \ call tabpagebuffer#excmds#next_excmd(0, 0, 'sbuffer',
  \   <count>, <q-args>)
command! -bar -count -nargs=?
  \ STpbModified
  \ call tabpagebuffer#excmds#next_excmd(1, 1, 'sbuffer',
  \   <count>, <q-args>)
command! -bar -count -nargs=?
  \ STpbModifiedNext
  \ call tabpagebuffer#excmds#next_excmd(1, 1, 'sbuffer',
  \   <count>, <q-args>)
command! -bar -count -nargs=?
  \ STpbModifiedPrevious
  \ call tabpagebuffer#excmds#next_excmd(0, 1, 'sbuffer',
  \   <count>, <q-args>)
command! -bar -count -nargs=?
  \ VTpbNext
  \ call tabpagebuffer#excmds#next_excmd(1, 0, 'vertical sbuffer',
  \   <count>, <q-args>)
command! -bar -count -nargs=?
  \ VTpbPrevious
  \ call tabpagebuffer#excmds#next_excmd(0, 0, 'vertical sbuffer',
  \   <count>, <q-args>)
command! -bar -count -nargs=?
  \ VTpbModified
  \ call tabpagebuffer#excmds#next_excmd(1, 1, 'vertical sbuffer',
  \   <count>, <q-args>)
command! -bar -count -nargs=?
  \ VTpbModifiedNext
  \ call tabpagebuffer#excmds#next_excmd(1, 1, 'vertical sbuffer',
  \   <count>, <q-args>)
command! -bar -count -nargs=?
  \ VTpbModifiedPrevious
  \ call tabpagebuffer#excmds#next_excmd(0, 1, 'vertical sbuffer',
  \   <count>, <q-args>)
command! -bar -count -nargs=?
  \ TTpbNext
  \ call tabpagebuffer#excmds#next_excmd(1, 0, 'tab sbuffer',
  \   <count>, <q-args>)
command! -bar -count -nargs=?
  \ TTpbPrevious
  \ call tabpagebuffer#excmds#next_excmd(0, 0, 'tab sbuffer',
  \   <count>, <q-args>)
command! -bar -count -nargs=?
  \ TTpbModified
  \ call tabpagebuffer#excmds#next_excmd(1, 1, 'tab sbuffer',
  \   <count>, <q-args>)
command! -bar -count -nargs=?
  \ TTpbModifiedNext
  \ call tabpagebuffer#excmds#next_excmd(1, 1, 'tab sbuffer',
  \   <count>, <q-args>)
command! -bar -count -nargs=?
  \ TTpbModifiedPrevious
  \ call tabpagebuffer#excmds#next_excmd(0, 1, 'tab sbuffer',
  \   <count>, <q-args>)

command! -bang -bar -nargs=?
  \ TpbRewind
  \ call tabpagebuffer#excmds#rewind_excmd(0, 0, 'buffer<bang>',
  \   <q-args>)
command! -bang -bar -nargs=?
  \ TpbFirst
  \ call tabpagebuffer#excmds#rewind_excmd(0, 0, 'buffer<bang>',
  \   <q-args>)
command! -bang -bar -nargs=?
  \ TpbLast
  \ call tabpagebuffer#excmds#rewind_excmd(1, 0, 'buffer<bang>',
  \   <q-args>)
command! -bang -bar -nargs=?
  \ TpbModifiedRewind
  \ call tabpagebuffer#excmds#rewind_excmd(0, 1, 'buffer<bang>',
  \   <q-args>)
command! -bang -bar -nargs=?
  \ TpbModifiedFirst
  \ call tabpagebuffer#excmds#rewind_excmd(0, 1, 'buffer<bang>',
  \   <q-args>)
command! -bang -bar -nargs=?
  \ TpbModifiedLast
  \ call tabpagebuffer#excmds#rewind_excmd(1, 1, 'buffer<bang>',
  \   <q-args>)
command! -bar -nargs=?
  \ STpbRewind
  \ call tabpagebuffer#excmds#rewind_excmd(0, 0, 'sbuffer'
  \   <q-args>)
command! -bar -nargs=?
  \ STpbFirst
  \ call tabpagebuffer#excmds#rewind_excmd(0, 0, 'sbuffer'
  \   <q-args>)
command! -bar -nargs=?
  \ STpbLast
  \ call tabpagebuffer#excmds#rewind_excmd(1, 0, 'sbuffer'
  \   <q-args>)
command! -bar -nargs=?
  \ STpbModifiedRewind
  \ call tabpagebuffer#excmds#rewind_excmd(0, 1, 'sbuffer'
  \   <q-args>)
command! -bar -nargs=?
  \ STpbModifiedFirst
  \ call tabpagebuffer#excmds#rewind_excmd(0, 1, 'sbuffer'
  \   <q-args>)
command! -bar -nargs=?
  \ STpbModifiedLast
  \ call tabpagebuffer#excmds#rewind_excmd(1, 1, 'sbuffer'
  \   <q-args>)
command! -bar -nargs=?
  \ VTpbRewind
  \ call tabpagebuffer#excmds#rewind_excmd(0, 0, 'vertical sbuffer'
  \   <q-args>)
command! -bar -nargs=?
  \ VTpbFirst
  \ call tabpagebuffer#excmds#rewind_excmd(0, 0, 'vertical sbuffer'
  \   <q-args>)
command! -bar -nargs=?
  \ VTpbLast
  \ call tabpagebuffer#excmds#rewind_excmd(1, 0, 'vertical sbuffer'
  \   <q-args>)
command! -bar -nargs=?
  \ VTpbModifiedRewind
  \ call tabpagebuffer#excmds#rewind_excmd(0, 1, 'vertical sbuffer'
  \   <q-args>)
command! -bar -nargs=?
  \ VTpbModifiedFirst
  \ call tabpagebuffer#excmds#rewind_excmd(0, 1, 'vertical sbuffer'
  \   <q-args>)
command! -bar -nargs=?
  \ VTpbModifiedLast
  \ call tabpagebuffer#excmds#rewind_excmd(1, 1, 'vertical sbuffer'
  \   <q-args>)
command! -bar -nargs=?
  \ TTpbRewind
  \ call tabpagebuffer#excmds#rewind_excmd(0, 0, 'tab sbuffer'
  \   <q-args>)
command! -bar -nargs=?
  \ TTpbFirst
  \ call tabpagebuffer#excmds#rewind_excmd(0, 0, 'tab sbuffer'
  \   <q-args>)
command! -bar -nargs=?
  \ TTpbLast
  \ call tabpagebuffer#excmds#rewind_excmd(1, 0, 'tab sbuffer'
  \   <q-args>)
command! -bar -nargs=?
  \ TTpbModifiedRewind
  \ call tabpagebuffer#excmds#rewind_excmd(0, 1, 'tab sbuffer'
  \   <q-args>)
command! -bar -nargs=?
  \ TTpbModifiedFirst
  \ call tabpagebuffer#excmds#rewind_excmd(0, 1, 'tab sbuffer'
  \   <q-args>)
command! -bar -nargs=?
  \ TTpbModifiedLast
  \ call tabpagebuffer#excmds#rewind_excmd(1, 1, 'tab sbuffer'
  \   <q-args>)

command! -bar -count
  \ TpbUnhide
  \ call tabpagebuffer#excmds#unhide(1, 'sbuffer',
  \   <count>)
command! -bar -count
  \ STpbUnhide
  \ call tabpagebuffer#excmds#unhide(1, 'sbuffer',
  \   <count>)
command! -bar -count
  \ VTpbUnhide
  \ call tabpagebuffer#excmds#unhide(1, 'vertical sbuffer',
  \   <count>)
command! -bar -count
  \ TTpbUnhide
  \ call tabpagebuffer#excmds#unhide(1, 'tab sbuffer',
  \   <count>)

command! -bar -count
  \ TpbAll
  \ call tabpagebuffer#excmds#unhide(0, 'sbuffer',
  \   <count>)
command! -bar -count
  \ STpbAll
  \ call tabpagebuffer#excmds#unhide(0, 'sbuffer',
  \   <count>)
command! -bar -count
  \ VTpbAll
  \ call tabpagebuffer#excmds#unhide(0, 'vertical sbuffer',
  \   <count>)
command! -bar -count
  \ TTpbAll
  \ call tabpagebuffer#excmds#unhide(0, 'tab sbuffer',
  \   <count>)

let &cpo = s:save_cpo
unlet s:save_cpo
