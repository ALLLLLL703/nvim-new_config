let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
doautoall SessionLoadPre
silent only
silent tabonly
cd ~/.config/nvim
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
set shortmess+=aoO
badd +17 ~/.config/nvim/lua/config/ui/notify1/noice2.lua
badd +3 ~/.config/nvim/lua/config/lsp-relative/dap1/dap2.lua
badd +21 ~/.config/onvim/lua/config/plugins/ui/noice.lua
badd +34 ~/.config/nvim/.luarc.json
badd +11 ~/.local/share/nvim/site/pack/core/opt/noice.nvim/lua/noice/init.lua
badd +204 ~/.local/share/nvim/site/pack/core/opt/noice.nvim/lua/noice/config/init.lua
badd +0 ~/.local/share/nvim/site/pack/core/opt/noice.nvim/lua/noice/config/views.lua
argglobal
%argdel
edit ~/.config/nvim/lua/config/ui/notify1/noice2.lua
let s:save_splitbelow = &splitbelow
let s:save_splitright = &splitright
set splitbelow splitright
wincmd _ | wincmd |
split
1wincmd k
wincmd w
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd w
let &splitbelow = s:save_splitbelow
let &splitright = s:save_splitright
wincmd t
let s:save_winminheight = &winminheight
let s:save_winminwidth = &winminwidth
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe '1resize ' . ((&lines * 28 + 30) / 61)
exe '2resize ' . ((&lines * 30 + 30) / 61)
exe 'vert 2resize ' . ((&columns * 113 + 114) / 228)
exe '3resize ' . ((&lines * 30 + 30) / 61)
exe 'vert 3resize ' . ((&columns * 114 + 114) / 228)
argglobal
enew | setl bt=help
help noice.nvim-noice-(nice,-noise,-notice)-views@en
balt ~/.config/nvim/lua/config/ui/notify1/noice2.lua
setlocal foldmethod=manual
setlocal foldexpr=0
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal nofoldenable
silent! normal! zE
let &fdl = &fdl
let s:l = 58 - ((8 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 58
normal! 0
wincmd w
argglobal
balt ~/.config/nvim/lua/config/lsp-relative/dap1/dap2.lua
setlocal foldmethod=manual
setlocal foldexpr=v:lua.vim.treesitter.foldexpr()
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldenable
silent! normal! zE
let &fdl = &fdl
let s:l = 17 - ((16 * winheight(0) + 14) / 29)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 17
normal! 020|
wincmd w
argglobal
if bufexists(fnamemodify("~/.local/share/nvim/site/pack/core/opt/noice.nvim/lua/noice/config/views.lua", ":p")) | buffer ~/.local/share/nvim/site/pack/core/opt/noice.nvim/lua/noice/config/views.lua | else | edit ~/.local/share/nvim/site/pack/core/opt/noice.nvim/lua/noice/config/views.lua | endif
if &buftype ==# 'terminal'
  silent file ~/.local/share/nvim/site/pack/core/opt/noice.nvim/lua/noice/config/views.lua
endif
balt ~/.config/nvim/lua/config/ui/notify1/noice2.lua
setlocal foldmethod=manual
setlocal foldexpr=v:lua.vim.treesitter.foldexpr()
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldenable
silent! normal! zE
let &fdl = &fdl
let s:l = 146 - ((17 * winheight(0) + 14) / 29)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 146
normal! 03|
wincmd w
2wincmd w
exe '1resize ' . ((&lines * 28 + 30) / 61)
exe '2resize ' . ((&lines * 30 + 30) / 61)
exe 'vert 2resize ' . ((&columns * 113 + 114) / 228)
exe '3resize ' . ((&lines * 30 + 30) / 61)
exe 'vert 3resize ' . ((&columns * 114 + 114) / 228)
tabnext 1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0 && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20
let &shortmess = s:shortmess_save
let &winminheight = s:save_winminheight
let &winminwidth = s:save_winminwidth
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
set hlsearch
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
