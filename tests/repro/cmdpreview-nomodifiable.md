# Crash report: command preview aborts when the preview leaves a buffer `nomodifiable`

Draft for `neovim/neovim`. Repro script: `tests/repro/cmdpreview-nomodifiable.lua`,
full backtrace: `tests/repro/cmdpreview-nomodifiable.backtrace.txt`.

## Summary

`SIGABRT` when a `:command-preview` callback puts preview text into a buffer and then leaves that
buffer `nomodifiable`. `cmdpreview_restore_state()` calls `u_rollback()` before restoring
`'modifiable'`, so the undo it needs is refused by `undo_allowed()` and `u_rollback()` hits
`abort()`.

## Steps to reproduce

```sh
nvim -u NONE --noplugin -i NONE -n -S tests/repro/cmdpreview-nomodifiable.lua
```

1. Type `:Refactor ` (with the trailing space).
2. Press `Tab` once — the completion menu offers `first` / `last`, `first` gets inserted.
3. Press `Tab` again — `last` is previewed and the preview callback writes into the float, then sets
   `nomodifiable`.
4. Neovim aborts instead of restoring the buffer.

Non-interactive form, `-S driver.lua` being a script that feeds `:Refactor <Tab>` and `<Tab>`:

```sh
nvim --headless -u NONE --noplugin -i NONE -n \
  -S tests/repro/cmdpreview-nomodifiable.lua -S driver.lua
# exit 134 (SIGABRT)
```

Setting `inccommand=` after the scripts load makes the same run exit `0`, so the crash is inside the
command preview path.

## Expected

The preview is rolled back and the command line keeps working.

## Actual

```
Program received signal SIGABRT, Aborted.
#2  abort ()
#3  u_rollback (uc=..., buf=...) at src/nvim/undo.c:3418
#4  cmdpreview_restore_state (cpinfo=...) at src/nvim/ex_getln.c:2576
#5  cmdpreview_may_show (s=...) at src/nvim/ex_getln.c:2720
#6  command_line_changed (s=...) at src/nvim/input.c:1913
#7  state_enter (s=...) at src/nvim/state.c:115
```

Values at the abort:

| Expression | Value |
| --- | --- |
| `cp_bufinfo.save_b_p_ma` (frame 4) | `1` — modifiable when checkpointed |
| `buf->b_p_ma` (frame 3) | `0` — `nomodifiable` when restored |
| `buf->b_u_seq_cur` | `1` |
| `uc->uc_seq_cur` | `0` — sequences differ, so an undo is attempted |

## Analysis

`u_rollback()` only undoes when the undo sequence moved:

```c
// src/nvim/undo.c
if (buf->b_u_seq_cur != uc->uc_seq_cur) {
  ...
  if (!u_undo_and_forget(count, false)) {
    abort();  // line 3418
  }
```

`u_undo_and_forget()` → `u_doit()` → `undo_allowed()`, which refuses to work on a nonmodifiable
buffer and only emits `E21`:

```c
if (!MODIFIABLE(buf)) {
  emsg(_(e_modifiable));
  return false;
}
```

`cmdpreview_restore_state()` restores `'modifiable'` after the rollback, not before:

```c
// src/nvim/ex_getln.c
u_rollback(&cp_bufinfo.undo_checkpoint, buf);   // line 2576
buf->b_op_start = cp_bufinfo.save_b_op_start;
buf->b_op_end = cp_bufinfo.save_b_op_end;
buf->b_p_ma = cp_bufinfo.save_b_p_ma;           // line 2581, "Restore 'modifiable'"
```

So a plugin that draws into its own scratch buffer and locks it at the end of the preview (the usual
pattern for notification and popup buffers) makes the rollback fail. Restoring `'modifiable'` before
the call, or making `u_rollback()` tolerate a refused undo, would avoid the abort.

## Versions

| Build | Result |
| --- | --- |
| `NVIM v0.12.6` (release tarball) | `SIGABRT` |
| `NVIM v0.13.0-dev-2122+g4ef4bed584` (nightly tarball) | `SIGABRT` |
| `NVIM v0.13.0-dev-2129+g12a0c72c243` (distribution package) | `SIGABRT` |

Backtrace captured with the nightly tarball.

## Related

- #23136 — different trigger (changing `inccommand` during preview), fixed by #25462.
- #32016 / #32034 — command preview skipped on `nomodifiable` buffers.
- #24330 — preview-created buffers and windows are not rolled back.
