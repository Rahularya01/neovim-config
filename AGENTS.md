# AGENTS.md - Neovim Config Repository

## Build/Lint/Test Commands

### Formatting
- **Format current buffer**: `<leader>f` (handled by `conform.nvim`)
- **Format entire codebase**: `stylua .` (in project root)
- **Configured Formatters** (via `lua/plugins/formatting.lua`):
  - **Lua**: `stylua`
  - **Python**: `isort`, `black`
  - **Web**: `prettierd` or `prettier` (JS, TS, HTML, CSS, JSON, YAML, Markdown)
  - **C/C++**: `clang-format`
  - **Go**: `goimports`, `gofumpt`

### Linting
- **Engine**: LSP diagnostics + `mfussenegger/nvim-lint`
- **Lua**: `lua_ls` configured via `.luarc.json`
  - *Globals*: `vim`
  - *Disabled*: `assign-type-mismatch`, `unused-local`, `missing-fields`
- **Commands**:
  - Show line diagnostics: `vim.diagnostic.open_float()`
  - Navigate diagnostics: `[d` (previous) / `]d` (next)
  - List all diagnostics: `:Telescope diagnostics`

### Testing & Validation
Since this is a config repository, validation is manual:
1. **Reload**: `nvim --clean -u init.lua` to simulate a fresh start.
2. **Health**: `:checkhealth` to verify tool requirements.
3. **LSP**: `:LspInfo` to check server attachment.
4. **Plugins**: `:Lazy status` to check for errors.

### Plugin Management
- **Manager**: `folke/lazy.nvim`
- **Lockfile**: `lazy-lock.json` (Tracked: **YES**. Commit changes to this file to pin versions).
- **Commands**: `:Lazy sync`, `:Lazy update`, `:Lazy clean`.

---

## Code Style Guidelines

### File Structure
- `init.lua`: Entry point, bootstrap `lazy.nvim`, loads `config/`.
- `lua/config/`: Core settings (`options.lua`, `keymaps.lua`, `health.lua`).
- `lua/plugins/`: Plugin specs. **One file per plugin**.
- `lua/plugins/lsp.lua`: Centralized LSP server config.

### File Naming
- **Plugin files**: kebab-case (e.g., `nvim-cmp.lua`, `neo-tree.lua`).
- **Config files**: snake_case/lowercase (e.g., `options.lua`).

### Plugin Specification Pattern
Return a Lua table in `lua/plugins/*.lua`:
```lua
return {
  "author/plugin-name",
  branch = "main", -- Optional
  dependencies = { "dep1" },
  event = "VeryLazy", -- PREFERRED: explicit lazy loading
  cmd = "CommandName",
  ft = { "filetype" },
  keys = { -- Define plugin-specific keymaps here
    { "<leader>x", "<cmd>Cmd<cr>", desc = "Description" },
  },
  opts = { -- Plugin options (passed to setup)
    setting = true,
  },
  config = function(_, opts)
    require("plugin").setup(opts) -- Only needed for custom logic
  end,
}
```

### Indentation & Formatting
- **Style**: 2 spaces, no tabs (`expandtab = true`).
- **Tool**: `stylua` is authoritative.
- **Alignment**: Align values in tables for readability.

### Naming Conventions
- **Variables**: `snake_case` (`local my_var`)
- **Constants**: `UPPER_SNAKE_CASE` (`local MAX_WIDTH`)
- **Module Imports**: `lowercase` (`require("config.options")`)

### Keybindings
- **Function**: `vim.keymap.set(mode, lhs, rhs, opts)`
- **Opts**: Must include `desc`. Use `silent = true` where appropriate.
- **Location**:
  - Global: `lua/config/keymaps.lua`
  - Plugin-specific: `keys` table in plugin spec.

### Error Handling
- Use `pcall(require, "module")` for risky imports outside `lazy` specs.
- Use `vim.notify("msg", vim.log.levels.ERROR)` for errors.

### Autocommands
- Always wrap in an `augroup` with `clear = true`.
```lua
vim.api.nvim_create_autocmd("Event", {
  group = vim.api.nvim_create_augroup("GroupName", { clear = true }),
  callback = function() ... end,
})
```

---

## Workflow Instructions for Agents

### 1. Adding a New Plugin
- **Check**: Verify it doesn't exist in `lua/plugins/`.
- **Create**: Add `lua/plugins/<name>.lua`.
- **Configure**: Use the **Plugin Specification Pattern**. Default to `lazy = true` via `event`, `cmd`, or `keys`.
- **Dependencies**: List them in `dependencies = {}`.

### 2. Modifying Configuration
- **Options**: Edit `lua/config/options.lua`. Use `vim.opt`.
- **Keymaps**: Edit `lua/config/keymaps.lua` OR the specific plugin file if the map is bound to that plugin.

### 3. Debugging
- Use `print(vim.inspect(my_table))` to view data in `:messages`.
- Use `vim.notify("debug message")` for floating notifications.

### 4. Safety
- **Paths**: ALWAYS use absolute paths for file operations.
- **Git**: Create atomic commits. Do not force push.
