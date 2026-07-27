# Neovim Configuration Style Guide

## 1. Scope And Enforcement

This guide applies to Lua files under `lua/`, `lsp/`, and `ftplugin/`, plus
the root `init.lua`.

The repository follows progressive enforcement:

- New code must follow this guide.
- Modified code must be brought into compliance within the touched area.
- Unrelated legacy code does not need to be rewritten solely for style.
- Prefer the smallest coherent change over broad cleanup.

## 2. Existing Architecture

Preserve the repository's responsibility-based layout:

```text
init.lua                  Startup boundary
lua/plugins/              Plugin declarations for vim.pack
lua/config/               Plugin and built-in behavior configuration
lua/keymaps/              Keymaps grouped by capability
lsp/                      Neovim LSP configuration tables
ftplugin/                 Filetype-local setup
```

Within `lua/plugins/`, `lua/config/`, and `lua/keymaps/`, group modules by
capability such as `builtin`, `editor-basic`, `lsp-relative`, and `ui`.
`init.lua` files are aggregators: they load child modules and should not grow
feature implementations of their own.

Numbered file suffixes such as `foo1.lua` and `foo2.lua` are allowed. A file
name must still identify its capability; do not use a number as a substitute
for a meaningful base name.

## 3. Formatting

- Use tabs for indentation and one indentation level per nested block.
- Use double quotes for ordinary Lua strings.
- Put spaces around binary operators and after commas.
- Use one blank line to separate logical sections.
- Include trailing commas in multiline tables and argument lists.
- Prefer multiline tables when a single line becomes difficult to scan.
- Run `stylua` on changed Lua files. StyLua output is authoritative for layout.

```lua
local opts = {
	filetypes = { "lua", "vim" },
	settings = {
		Lua = {
			completion = {
				callSnippet = "Replace",
			},
		},
	},
}
```

Do not preserve cramped formatting such as:

```lua
local spec = {src= "https://example.com/plugin.nvim"}
```

## 4. Naming And Scope

- Use `snake_case` for local variables and functions.
- Use descriptive names based on responsibility, not temporary implementation
  details.
- Keep variables and helper functions `local` unless Neovim requires a global.
- Use uppercase names only for intentional module or constant conventions.
- Follow external API field names exactly, even when they use another style.
- Use `M` only for a real exported module table. Return a table directly when
  no module identity or methods are needed.
- A short local alias such as `local map = vim.keymap.set` is acceptable when
  an API is called repeatedly in the same file.

## 5. Module Responsibilities

Each module should have one clear reason to change:

- Plugin declaration modules return `vim.pack.Spec` data.
- Configuration modules call `setup()` or configure built-in behavior.
- Keymap modules define keymaps only.
- LSP modules return a `vim.lsp.Config` table.
- `ftplugin` modules contain behavior specific to their filetype.

Do not combine plugin installation, setup, keymaps, and unrelated utilities in
one file. Split a module when it begins coordinating multiple independent
features or when its main path can no longer be understood without scanning
unrelated sections. Do not split small, cohesive configuration merely to meet
an arbitrary line count.

Prefer explicit data flow and small local helpers. A helper is justified when
it names a non-obvious operation, removes meaningful duplication, or isolates
a side effect. Keep one-off table literals inline when extraction would only
add indirection.

## 6. Plugin Specifications

Plugin declaration files should return a consistently typed list:

```lua
---@type vim.pack.Spec[]
return {
	{ src = "https://github.com/example/plugin.nvim" },
}
```

- Register each plugin exactly once.
- Keep plugin source declarations in `lua/plugins/`.
- Keep runtime setup in the matching `lua/config/` capability.
- Do not pass `nil` entries into `vim.pack.add`.
- Use the existing dependency rather than implementing equivalent behavior
  locally when the dependency already exposes the required API.

## 7. Module Loading And Failure Handling

Use native `require` for required internal modules and dependencies. Required
module failures are programming or installation errors and should remain
visible.

Use `Safe_Require` only at an optional boundary:

- top-level startup aggregation where one optional feature must not prevent
  Neovim from opening;
- optional plugin integrations whose absence is an expected state.

Always check the result before using a safely loaded module:

```lua
local oil = Safe_Require("oil")
if not oil then
	return
end

oil.setup({})
```

Do not write `Safe_Require("plugin").setup({})`; a failed load would replace a
clear dependency error with a nil-index error. Do not use `Safe_Require` to
hide errors in required sibling modules.

## 8. Keymaps And User Commands

Every user-defined keymap and user command must include an accurate English
`desc`.

```lua
vim.keymap.set("n", "<leader>ff", Snacks.picker.files, {
	desc = "Find files",
	silent = true,
})
```

- Write descriptions as concise actions, using sentence case.
- Describe behavior, not the key sequence or implementation.
- Set `silent = true` for command-string mappings unless command output is
  intentionally useful.
- Use buffer-local mappings for LSP or filetype-specific behavior.
- Avoid duplicate mappings. When replacing an existing mapping intentionally,
  keep the override close to its condition and explain why if it is not
  obvious.
- Keep leader assignment in the keymap entry module before loading child
  keymap modules.

## 9. Autocommands

Autocommands must be idempotent so re-sourcing configuration does not create
duplicate behavior.

```lua
local group = vim.api.nvim_create_augroup("config.format", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
	group = group,
	callback = function(args)
		format_buffer(args.buf)
	end,
	desc = "Format buffer before writing",
})
```

- Create a named augroup with `clear = true` for each cohesive feature.
- Assign every autocmd to a group.
- Add an English `desc` that states the observable action.
- Prefer `buffer` or a narrow `pattern` over `pattern = "*"` when behavior is
  not genuinely global.
- Keep callbacks small; delegate substantial logic to a named local function.

## 10. Types And Documentation

Use LuaLS annotations where they clarify contracts:

- Add `---@type vim.pack.Spec[]` to plugin specification lists.
- Add `---@type vim.lsp.Config` to returned LSP configurations.
- Add `---@param` and `---@return` to non-obvious local helpers and reusable
  functions.
- Define `---@class` and `---@field` types for structured custom data passed
  across function boundaries.
- Use Neovim and plugin-provided types instead of broad `table` or `any` when
  those types are available.

Names in annotations must match the corresponding parameter names exactly.
Do not add annotations that merely repeat an obvious local assignment.

Comments explain intent, constraints, workarounds, or external behavior. Do
not narrate syntax. Keep links next to the workaround or API behavior they
justify. Use English for new comments and documentation so code, API names,
and external references share one language.

## 11. User-Visible Text And Errors

- Use English for keymap descriptions, command descriptions, prompts, and
  notifications.
- Include the feature or integration name in actionable error messages.
- Report expected optional-feature failures once at the loading boundary.
- Do not silently discard errors from background commands or LSP requests.
- Avoid logging routine success paths unless the information helps diagnose a
  long-running or stateful operation.

## 12. Responsiveness And Side Effects

Neovim's main loop must remain responsive:

- Use `vim.system` callbacks for external commands that may block.
- Use `vim.schedule` before calling UI APIs from asynchronous callbacks when
  required.
- Avoid synchronous filesystem scans, shell commands, and network work during
  startup or interactive callbacks.
- Keep setup side effects at module boundaries and keep transformation or
  selection logic in local functions where practical.

## 13. Validation

Before considering a change complete:

1. Format changed Lua files with `stylua`.
2. Check changed files with LuaLS and resolve new diagnostics.
3. Start Neovim headlessly and confirm configuration loads without errors.
4. Exercise the changed user scenario, such as invoking the keymap, command,
   formatter, plugin setup, or LSP configuration.
5. Re-source affected modules when relevant and confirm autocmds, commands,
   and mappings are not duplicated.

Prefer behavior-level validation through the real Neovim entry point. A static
syntax check alone is insufficient for plugin wiring or editor interactions.

## 14. Review Checklist

- Is the change in the correct architectural layer?
- Does each changed module have one coherent responsibility?
- Are formatting, naming, and table layout consistent?
- Is every plugin registered once and represented by a valid spec?
- Is `Safe_Require` limited to an optional boundary and checked before use?
- Do all new keymaps, commands, and autocmds have accurate English `desc`
  values?
- Are autocmds grouped and safe to re-source?
- Do non-obvious contracts have precise LuaLS annotations?
- Does potentially blocking work stay off Neovim's main loop?
- Was the real changed scenario executed successfully?
