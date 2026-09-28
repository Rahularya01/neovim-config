# Neovim config

Native `vim.pack` (Neovim 0.12+). Mirrors the Cursor/VSCodeVim setup.

## Supply-chain policy

Everything that runs code on this machine is pinned, and nothing updates on its own.

| What | Pinned by | Updated by |
|---|---|---|
| Plugins | commit hashes in `nvim-pack-lock.json` (committed) | `:PackUpdate` → review the diff/log → `:w` |
| blink.cmp fuzzy matcher | built from source, `cargo build --locked` (no prebuilt binary download) | automatically on blink.cmp install/update |
| Treesitter parsers | revisions pinned inside the locked nvim-treesitter commit | updating nvim-treesitter |
| Mason registry | fixed release in `lua/plugins/lsp.lua` | editing the `@<release>` tag |
| LSP servers, formatters, linters, debug adapter | exact versions in `lua/plugins/tools.lua` | editing a version |

Remaining exposure: npm-based Mason tools pin the top-level package but not
transitive dependencies; GitHub-release tools are only as trustworthy as that release.
tether.nvim is the one unpinned exception: it loads from a local checkout
(`~/Projects/Personal/tether.nvim`, see `lua/plugins/ai.lua`).

## Updating

1. **Plugins:** `:PackUpdate`, read what changed, then `:w` to apply or `:q` to discard.
   Prefer waiting a few days after a new commit lands before accepting it.
   Commit `nvim-pack-lock.json`. To undo: `git checkout HEAD~1 -- nvim-pack-lock.json`,
   `:restart`, then `:lua vim.pack.update(nil, { target = "lockfile" })`.
2. **Tools:** bump a version in `lua/plugins/tools.lua` (check the upstream release
   first), `:restart`. Mason reinstalls anything that doesn't match its pin.
3. **Registry:** change the `@<release>` in `lua/plugins/lsp.lua` only when a new tool
   version you want isn't in the pinned registry.
4. **Removing plugins:** delete the spec, `:restart`, then `:PackClean`.

## Layout

- `init.lua`: loads UI-critical modules eagerly and everything else after the first screen draw
- `lua/config/`: options, keymaps, autocmds, pack hooks and `:Pack*` commands
- `lua/plugins/`: one module per area (lsp, completion, git, dap, tools, …)
