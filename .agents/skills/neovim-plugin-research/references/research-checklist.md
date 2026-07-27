# Neovim Plugin Research Checklist

## Quick Triage

1. Identify the plugin name, module name, and expected behavior.
2. Confirm the plugin is installed locally under `/home/sanae/.local/share/nvim/site/pack/core/opt/`.
3. Read local `README.md` and `doc/*.txt` first.
4. Search local source for `setup`, commands, autocmds, exported functions, and defaults.
5. Check whether the user's config shape matches the plugin's actual API.

## Source Search Targets

- `README.md`
- `doc/*.txt`
- `lua/**/init.lua`
- `plugin/*.lua`
- `autoload/*`
- `ftplugin/*`

Search terms that usually pay off:

- `setup`
- `nvim_create_user_command`
- `nvim_create_autocmd`
- `keymap.set`
- `default`
- `opts`
- `config`
- `health`

## When to Escalate to Upstream Search

- Local docs do not match observed behavior.
- The plugin recently changed APIs.
- The issue smells version-specific.
- The integration involves another plugin.
- The behavior may already be reported upstream.

## Common Failure Modes

- Wrong lazy-loading event.
- Calling the wrong module in `require()`.
- Using docs from a newer or older plugin version.
- Plugin command exists only after loading.
- Filetype-specific setup never runs.
- External executable missing.
- Another plugin overrides mappings, highlights, or autocmds.
- Dependency not installed or loaded too late.

## Strong Signals to Mention

- Exact local doc topic.
- Exact source file that defines the behavior.
- Maintainer comment in issue or PR.
- Matching Neovim help entry.
