# AGENTS.md - Neovim Config Repository

## Build/Lint/Test Commands

### Formatting
- **Format buffer**: `<leader>f` (uses `conform.nvim`)
- **Format codebase**: `stylua .` (run from project root)
- **Formatters by filetype**:
  - Lua: `stylua`
  - Python: `isort`, `black`
  - Web: `prettierd` or `prettier` (JS/TS/HTML/CSS/JSON/YAML/Markdown)
  - C/C++: `clang-format`
  - Go: `goimports`, `gofumpt`

### Linting
- **Engine**: LSP diagnostics + `nvim-lint`
- **Lua**: `lua_ls` via `.luarc.json` (globals: `vim`; disabled: `assign-type-mismatch`, `unused-local`, `missing-fields`)
- **Navigate**: `[d` (prev) / `]d` (next) diagnostic
- **Show**: `<leader>xx` (Trouble) or `<leader>sd` (Snacks picker)
- **Float**: `vim.diagnostic.open_float()`

### Testing
Config validation is manual (no test runner):
1. **Reload**: `nvim --clean -u init.lua` (fresh start test)
2. **Health**: `:checkhealth` (tool requirements)
3. **LSP**: `:LspInfo` (server status)
4. **Plugins**: `:Lazy status` (plugin errors)

### Plugin Management
- **Manager**: `folke/lazy.nvim`
- **Lockfile**: `lazy-lock.json` (commit changes to pin versions)
- **Commands**: `:Lazy sync`, `:Lazy update`, `:Lazy clean`

---

## Code Style Guidelines

### File Structure
- `init.lua`: Entry point, bootstrap lazy.nvim, load `config/`
- `lua/config/`: Core settings (`options.lua`, `keymaps.lua`, `commands.lua`, `health.lua`)
- `lua/plugins/`: Plugin specs, **one file per plugin**
- `lua/plugins/lsp.lua`: Centralized LSP configuration

### File Naming
- Plugin files: `kebab-case.lua` (e.g., `nvim-cmp.lua`, `neo-tree.lua`)
- Config files: `snake_case.lua` (e.g., `options.lua`)

### Plugin Spec Pattern
```lua
return {
  "author/plugin-name",
  branch = "main",
  dependencies = { "dep1" },
  event = "VeryLazy",
  cmd = "CommandName",
  ft = { "filetype" },
  keys = {
    { "<leader>x", "<cmd>Cmd<cr>", desc = "Description" },
  },
  opts = { setting = true },
  config = function(_, opts)
    require("plugin").setup(opts)
  end,
}
```

### Indentation & Formatting
- **Style**: 2 spaces, no tabs (`expandtab = true`)
- **Tool**: `stylua` (authoritative)
- **Tables**: Align values for readability
- **Quotes**: Double quotes for strings

### Naming Conventions
- Variables: `snake_case` (`local my_var`)
- Constants: `UPPER_SNAKE_CASE` (`local MAX_WIDTH`)
- Modules: `lowercase` (`require("config.options")`)
- Functions: `snake_case` (`local function my_func()`)

### Keybindings
- **Function**: `vim.keymap.set(mode, lhs, rhs, opts)`
- **Required opts**: Always include `desc`
- **Silent**: Use `silent = true` where appropriate
- **Location**:
  - Global: `lua/config/keymaps.lua`
  - Plugin-specific: `keys` table in plugin spec

### Imports & Requires
- Use `pcall(require, "module")` for risky imports outside lazy specs
- Prefer local aliases: `local opt = vim.opt`
- Group requires at top of file

### Error Handling
- `pcall()` for optional dependencies
- `vim.notify("msg", vim.log.levels.ERROR)` for user-facing errors
- Check executables: `vim.fn.executable("cmd") == 1`

### Autocommands
Always wrap in augroup with `clear = true`:
```lua
vim.api.nvim_create_autocmd("Event", {
  group = vim.api.nvim_create_augroup("GroupName", { clear = true }),
  callback = function() end,
})
```

---

## Agent Workflows

### Adding a New Plugin
1. Check `lua/plugins/` for existing plugin
2. Create `lua/plugins/<name>.lua`
3. Follow **Plugin Spec Pattern**, use lazy loading (`event`, `cmd`, `keys`)
4. Add dependencies in `dependencies = {}`

### Modifying Configuration
- Options: Edit `lua/config/options.lua` (use `vim.opt`)
- Keymaps: Edit `lua/config/keymaps.lua` or plugin file
- Commands: Edit `lua/config/commands.lua`

### Debugging
- Inspect: `print(vim.inspect(my_table))` → check `:messages`
- Notify: `vim.notify("debug message")` for floating popup
- Profile: Use `:Lazy profile` for startup timing

### Safety
- **Paths**: Use absolute paths for file operations
- **Git**: Atomic commits, never force push to main
- **LSP**: Ensure `lua_ls` attaches for Lua files
