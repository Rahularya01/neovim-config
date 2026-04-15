# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## Repository Overview

This is a Neovim configuration using **lazy.nvim** for plugin management. The config prioritizes performance with lazy loading, extensive LSP integration, and modern dev tools across multiple languages.

**See AGENTS.md** for detailed style guidelines, code patterns, and development workflows. This file covers architecture and essential commands.

---

## Essential Commands

### Config Validation
```bash
# Fresh start test (validate init.lua loads without errors)
nvim --clean -u init.lua

# Check tool requirements and plugin health
:checkhealth

# View LSP server status
:LspInfo

# View plugin errors and status
:Lazy status
```

### Formatting & Linting
```bash
# Format entire config from project root
stylua .

# Format current buffer (Neovim mapping)
<leader>f

# Navigate diagnostics
[d  # previous
]d  # next
```

### Plugin Management
```bash
:Lazy sync    # Sync plugins (install, update, clean)
:Lazy update  # Update all plugins
:Lazy clean   # Remove unused plugins
```

---

## Architecture

### Directory Structure
```
init.lua              # Entry point: enables lua loader, sets leader key, loads core config & plugins
lua/config/           # Core configuration modules
  ├── options.lua     # Editor settings, autocommands (cursor line, undo, autocomplete, etc.)
  ├── keymaps.lua     # Global keybindings (navigation, buffer management, toggles)
  ├── commands.lua    # Custom Neovim commands
  └── health.lua      # Health check configuration
lua/plugins/          # Plugin specifications (one file per plugin, lazy-loaded)
lazy-lock.json        # Plugin version lock file (commit changes to pin versions)
```

### Startup Flow
1. **init.lua** → Enable lua loader, set leader key
2. **Load core config** → options, keymaps, commands
3. **Deferred health setup** → Runs after 2 seconds to avoid startup delay
4. **Bootstrap lazy.nvim** → Checks if installed, clones if needed
5. **Load plugins** → Lazy loads from `lua/plugins/` directory

### Plugin Architecture

**All plugins use lazy.nvim's spec format:**
- **Key patterns**: `event`, `cmd`, `ft`, `keys` for lazy loading
- **Dependencies**: Declared in `dependencies = {}` table
- **One file per plugin** in `lua/plugins/` (kebab-case naming)
- **Configuration**: Via `opts` table or `config` function

**Example structure:**
```lua
return {
  "author/plugin-name",
  dependencies = { "dep1", "dep2" },
  event = "VeryLazy",  -- Lazy load on VeryLazy event
  keys = { { "<leader>x", "<cmd>Cmd<cr>", desc = "Description" } },
  opts = { setting = true },
  config = function(_, opts)
    require("plugin").setup(opts)
  end,
}
```

### Key Plugin Areas

**LSP Integration** (`lua/plugins/lsp.lua`)
- Centralized config for mason, mason-lspconfig, nvim-lspconfig
- Supports: Lua, Python, Go, JavaScript/TypeScript, C/C++
- Autocommands for LspAttach with consistent keybindings (K, gd, gD, gi, gr, <leader>rn, <leader>ca, etc.)
- Inlay hints enabled where supported
- Formatting disabled for servers (handled by conform.nvim instead)

**Completion** (`lua/plugins/blink-cmp.lua`)
- Uses blink.cmp (modern completion engine)
- LSP capabilities integrated via mason-lspconfig

**Navigation & UI**
- **snacks.nvim**: Picker (files, grep, buffers), terminal, lazygit, GitHub issue/PR picker
- **neo-tree.lua**: File explorer
- **oil.lua**: File operations UI
- **lualine.lua**: Status line
- **treesitter.lua**: Syntax highlighting & code parsing

**Development Tools**
- **conform.nvim**: Multi-language formatting (stylua, prettier, black, goimports, clang-format, etc.)
- **nvim-lint**: Linting via LSP + nvim-lint engine
- **trouble.lua**: Diagnostic list UI
- **gitsigns.lua**: Git change indicators in gutter
- **grug-far.lua**: Find & replace (rip-grep/ast-grep powered)

---

## Code Style Summary

See AGENTS.md for comprehensive style guide. Quick reference:

- **Indentation**: 2 spaces (stylua-enforced, expandtab=true)
- **Naming**: `snake_case` for variables, `UPPER_SNAKE_CASE` for constants, `kebab-case` for plugin files
- **Keybindings**: Always include `desc` field, use `silent = true` where appropriate
- **Error handling**: Use `pcall(require, "module")` for optional deps, `vim.notify()` for user-facing errors
- **Autocommands**: Always wrap in augroup with `clear = true`
- **Tables**: Align values for readability, use double quotes for strings

---

## Common Workflows

### Adding a New Plugin
1. Create `lua/plugins/<name>.lua` following lazy.nvim spec pattern
2. Use `event`, `cmd`, or `keys` for lazy loading (not `lazy = false` unless essential)
3. Declare dependencies in `dependencies = {}`
4. Run `:Lazy sync` to install
5. Test with `:Lazy status` and `:checkhealth`

### Modifying Configuration
- **Editor options**: Edit `lua/config/options.lua` (use `vim.opt`)
- **Global keymaps**: Edit `lua/config/keymaps.lua`
- **Plugin keymaps**: Add `keys` table in plugin spec
- **Custom commands**: Edit `lua/config/commands.lua`

### Debugging
- Use `print(vim.inspect(table))` and check `:messages`
- Use `vim.notify("message")` for floating popup notifications
- Run `:Lazy profile` to identify slow plugins
- Check `:LspInfo` for LSP server attachment status

---

## LSP & Formatting

**LSP Servers Configured**: lua_ls, basedpyright, gopls, vtsls, clangd, emmet_language_server, tailwindcss

**Formatting**: Handled by conform.nvim (not LSP) for consistency
- Tools auto-installed via mason-tool-installer
- Disabled on LSP servers to prevent conflicts

**Diagnostics**:
- Virtual text inline with 4-space spacing
- Float on `<leader>ld` with rounded border
- Signs defined for Error, Warn, Info, Hint

---

## Important Notes

- **lazy-lock.json**: Commit this file to pin plugin versions across machines
- **Performance**: Lua loader enabled (Neovim 0.9+), plugins lazy-loaded by default, native compiled modules cached
- **Disabled built-in plugins**: gzip, matchit, matchparen, netrwPlugin, tarPlugin, tohtml, tutor, zipPlugin
- **Testing**: No automated test runner; validate via fresh start, :checkhealth, :LspInfo, :Lazy status
