-- 1. Set Leader Keys (Must be before lazy setup)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 2. Load Core Options
require("config.options")
require("config.keymaps")

-- 3. Bootstrap Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 4. Load Plugins
-- This automatically imports every file inside lua/plugins/*.lua
require("lazy").setup("plugins", {
    change_detection = { notify = false } -- Optional: stops notifications on config change
})