-- 0. Make user-local tools available to plugins and language servers.
local local_bin = vim.fn.expand("~/.local/bin")
local local_go_bin = vim.fn.expand("~/.local/go/bin")
vim.env.PATH = table.concat({ local_bin, local_go_bin, vim.env.PATH }, ":")

-- 1. Performance: Enable lua loader for faster startup (Neovim 0.9+)
if vim.loader then
  vim.loader.enable()
end

-- 2. Set Leader Keys (Must be before lazy setup)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 3. Load Core Options
require("config.options")
require("config.commands")
require("config.keymaps")

-- 3.5. Initialize health checks (deferred to not block startup)
vim.defer_fn(function()
  require("config.health").setup()
end, 2000) -- Run after 2 seconds

-- 4. Bootstrap Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 5. Load Plugins
require("lazy").setup("plugins", {
  defaults = {
    lazy = true, -- Default all plugins to lazy loading
  },
  install = {
    colorscheme = { "gruvbox" },
  },
  checker = {
    enabled = false, -- Don't check for plugin updates automatically
  },
  change_detection = {
    enabled = false, -- Stops notifications on config change
    notify = false, -- Use nvim-notify for better notifications
  },
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tutor",
        "zipPlugin",
      },
    },
  },
  ui = {
    border = "rounded",
  },
})
