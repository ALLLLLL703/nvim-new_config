## Tree-sitter Highlight Fix

- Keep the change in `lua/config/ui/highlight/treesitter-config.lua`.
- Use Neovim's parser lookup as the capability check before starting highlighting.
- Do not maintain a plugin-filetype denylist and do not notify from the failure path.
- Verify a parser-backed buffer starts highlighting, unsupported plugin buffers remain quiet,
  and repeated `FileType` events do not create duplicate highlighters or buffers.
- Run StyLua and both isolated and full-config headless startup checks.
