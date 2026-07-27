## Tree-sitter Highlight Fix

- Keep the change in `lua/config/ui/highlight/treesitter-config.lua`.
- Use Neovim's parser lookup as the capability check before starting highlighting.
- Do not maintain a plugin-filetype denylist and do not notify from the failure path.
- Verify a parser-backed buffer starts highlighting, unsupported plugin buffers remain quiet,
  and repeated `FileType` events do not create duplicate highlighters or buffers.
- Run StyLua and both isolated and full-config headless startup checks.

## Blink CMP V2 Build

- Follow Blink CMP's documented `vim.pack` installation path.
- Build the native matcher before `setup()`; the upstream task is a no-op when the
  library for the current plugin revision is already available.
- Verify the native library loads through the full configuration and the V2 warning
  is absent on subsequent startups.

## rest.nvim Dependencies

- Let rocks.nvim own rest.nvim and its rockspec dependencies; do not register the
  same plugin with `vim.pack`.
- Configure the rocks Lua, C, and runtime paths before loading `vim.pack` plugins.
- Use Arch's stable `/usr/bin/luarocks`; the bootstrap-generated wrapper embeds a
  temporary runtime path and cannot load external build backends later.
- Keep installation and network work out of the normal startup path.
- Verify rest.nvim commands load without missing-dependency notifications.
