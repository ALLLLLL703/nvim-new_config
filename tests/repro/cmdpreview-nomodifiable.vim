" Checks whether Vim shares the command preview crash described in
" tests/repro/cmdpreview-nomodifiable.md.
"
" Run with one of:
"   vim -N -u NONE -es -S tests/repro/cmdpreview-nomodifiable.vim; cat /tmp/cmdpreview-vim.log
"   vim -N -u NONE --not-a-term -S tests/repro/cmdpreview-nomodifiable.vim
"
" Vim has neither 'inccommand' nor :command-preview, and its undo.c has no
" u_checkpoint/u_rollback/u_undo_and_forget, so the abort() reachable in Neovim cannot be
" reached here. The script records that and then exercises the closest Vim analogue: an undo
" refused by undo_allowed() because the buffer was locked after a change.

set nocompatible
set nomore
set shortmess+=I

let s:log = []
let s:logfile = empty($REPRO_LOG) ? '/tmp/cmdpreview-vim.log' : $REPRO_LOG

function! s:Say(line) abort
  call add(s:log, a:line)
endfunction

function! s:Probe() abort
  call s:Say(matchstr(execute('version'), 'VIM - Vi IMproved[^\n]*'))
  call s:Say('option    ''inccommand'':           ' . exists('+inccommand'))
  call s:Say('command   :command-preview:          ' . exists(':command-preview'))
  call s:Say('function  nvim_create_user_command:  ' . exists('*nvim_create_user_command'))

  let l:opt = 'unset'
  try
    set inccommand=nosplit
    let l:opt = &inccommand
  catch
    let l:opt = 'error: ' . v:exception
  endtry
  call s:Say('set inccommand=nosplit -> ' . l:opt)

  " Without the option there is no preview callback, so the rollback that aborts in Neovim
  " has no way to trigger.
  call s:Say('verdict: preview rollback is unreachable in Vim')
  call s:Say('')
endfunction

function! s:Analogue() abort
  enew
  setlocal buftype=nofile bufhidden=wipe noswapfile
  call setline(1, ['original'])
  " Start a new undo block so the undo below rolls back only the preview write.
  let &l:undolevels = &l:undolevels

  " The pattern Neovim's preview hits: unlock, draw, lock again.
  setlocal modifiable
  call setline(1, ['previewed'])
  setlocal nomodifiable
  call s:Say('after preview writer:  line=' . string(getline(1)) . ' modifiable=' . &l:modifiable)

  " Vim's undo refuses exactly like Neovim's, but the caller only reports the error.
  let v:errmsg = ''
  silent! undo
  call s:Say('undo while locked:     errmsg=' . string(v:errmsg))
  call s:Say('after refused undo:    line=' . string(getline(1)) . ' (still running)')

  " The refusal left the undo tree intact, so the rollback works once the lock is gone.
  let v:errmsg = ''
  setlocal modifiable
  silent! undo
  call s:Say('undo after unlocking:  line=' . string(getline(1)) . ' errmsg=' . string(v:errmsg))
  call s:Say('')
  call s:Say('verdict: Vim reports E21 and keeps running, it never aborts')
endfunction

call s:Probe()
call s:Analogue()

call writefile(s:log, s:logfile)
echo 'wrote ' . s:logfile
qall!
