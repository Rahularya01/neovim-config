-- Neovim config — native vim.pack, mirrors the Cursor/VSCodeVim setup.
vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.options")
require("config.pack") -- build hooks + :Pack* commands; must run before any vim.pack.add()
require("config.keymaps")
require("config.autocmds")

-- Built-in optional plugins shipped with Neovim 0.12 (no download).
vim.cmd.packadd("nvim.undotree") -- :Undotree
vim.cmd.packadd("nvim.difftool") -- :DiffTool <left> <right>, nvim -d dir1 dir2

local function load(mods)
  for _, mod in ipairs(mods) do
    local ok, err = pcall(require, "plugins." .. mod)
    if not ok then
      vim.notify(("plugins.%s failed to load:\n%s"):format(mod, err), vim.log.levels.ERROR)
    end
  end
end

-- Needed before the first screen is drawn. Order matters: colorscheme first,
-- completion before lsp (it provides capabilities).
load({ "colorscheme", "snacks", "ui", "treesitter", "completion", "lsp", "formatting", "git" })

-- Everything else loads right after the UI appears.
local function load_deferred()
  load({ "linting", "editor", "explorer", "ai", "dap", "tools" })
  vim.g.deferred_plugins_loaded = true
end
local headless = vim.list_contains(vim.v.argv, "--headless")
vim.api.nvim_create_autocmd(headless and "VimEnter" or "UIEnter", {
  once = true,
  callback = function()
    vim.schedule(load_deferred)
  end,
})
