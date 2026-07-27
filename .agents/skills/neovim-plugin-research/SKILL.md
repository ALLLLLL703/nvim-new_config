---
name: neovim-plugin-research
description: Help agents research and troubleshoot Neovim plugin configuration, behavior, and integration issues. Use when working on Neovim config, checking how a plugin should be configured, comparing plugin APIs, investigating plugin load order or lazy-loading behavior, or verifying commands, autocmds, keymaps, highlights, health checks, issues, PRs, and documented usage patterns.
---

# Neovim Plugin Research

Follow this order unless there is a strong reason not to:

1. Inspect the user's current config and identify the exact plugin, event, command, keymap, or integration point involved.
2. Inspect the local plugin source under `/home/sanae/.local/share/nvim/site/pack/core/opt/`.
3. Read the plugin's README, `doc/*.txt`, help tags, and inline Lua annotations in the local source.
4. Check Neovim official docs for the editor feature the plugin is built on.
5. Search upstream discussions for real-world usage and edge cases: GitHub issues, PRs, discussions, and if useful Reddit posts.
6. Only then propose configuration guidance or likely root causes.

## Local Source First

When a plugin is already installed locally, prefer the local copy before relying on memory.

- Read `README.md`, `doc/`, `lua/`, `plugin/`, and `ftplugin/` when present.
- Search for `setup`, user commands, autocmds, default options, keymaps, and exported modules.
- Confirm whether the plugin expects `opts`, explicit `config`, global variables, or side-effect loading.
- Check whether the plugin defines help docs and mention the exact help topic when available.

Common targets to inspect:

- `lua/<plugin>/init.lua`
- `lua/<plugin>/config.lua`
- `plugin/*.lua`
- `doc/*.txt`
- `README.md`

## Upstream Research

If local docs are incomplete or behavior looks version-sensitive, search upstream sources.

- GitHub: usage examples, open and closed issues, merged PRs, discussions, breaking changes, deprecations.
- Reddit: practical setup examples and reports of integration problems.
- Prefer maintainer comments and merged PR context over random snippets.

When GitHub MCP is available, use it to inspect issues and PRs directly. Otherwise use web search.

## Neovim Docs

Check official Neovim docs whenever the plugin relies on core editor behavior, especially for:

- `:help lua-guide`
- `:help api`
- `:help autocmd`
- `:help map.txt`
- `:help options`
- `:help diagnostic`
- `:help lsp`
- `:help treesitter`
- `:help ui`
- `:help health`

Use core docs to separate plugin bugs from Neovim behavior.

## Configuration Review Checklist

- Confirm the plugin is installed from the expected source and is actually loaded.
- Confirm the lazy-loading trigger matches the feature being tested: `event`, `ft`, `cmd`, `keys`, or dependency chain.
- Confirm `setup()` is called exactly once and on the correct module.
- Confirm option names match the installed plugin version.
- Confirm keymaps call loaded modules safely if the plugin is lazy-loaded.
- Confirm dependent plugins are declared and loaded in a compatible order.
- Confirm filetype detection and buffer-local conditions match the test case.
- Confirm user commands, autocmd groups, highlights, and signs are not being overwritten later.
- Confirm the behavior is not blocked by an older lockfile entry or stale plugin checkout.

## Debugging Guidance

Prefer evidence over guesswork.

- Check whether the plugin created expected commands, keymaps, autocmds, or highlights.
- Check `:checkhealth` when the plugin integrates with LSP, Treesitter, providers, formatters, linters, or external binaries.
- Distinguish startup-time config from runtime buffer-local behavior.
- Watch for common Neovim pitfalls: wrong filetype, late option overrides, shadowed keymaps, missing dependencies, and stale cached state.
- If a plugin exposes a health checker, doc topic, or debug flag, mention it.

## Advice Style

- Prefer minimal fixes that fit the user's current config style.
- Cite where the conclusion came from: local source, plugin docs, Neovim docs, issue, or PR.
- Separate confirmed behavior from informed suspicion.
- If multiple valid approaches exist, present the current-style fix first and alternatives second.

For a compact troubleshooting checklist, read `references/research-checklist.md`.
