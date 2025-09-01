require 'core.options'
require 'core.keymaps'
require 'core.snippets'

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Function to load all plugin modules from the plugins directory
local function load_plugins_from_dir(directory)
  local plugins = {}
  local plugin_files = vim.fn.globpath(directory, '*.lua', false, true)
  for _, file in ipairs(plugin_files) do
    local plugin_name = file:match("([^/\\]+)%.lua$")
    if plugin_name then
      table.insert(plugins, require('plugins.' .. plugin_name))
    end
  end
  return plugins
end

-- Automatically load all plugins from plugins folder with basic performance tweaks
require('lazy').setup(load_plugins_from_dir(vim.fn.stdpath('config') .. '/lua/plugins'), {
  performance = {
    rtp = {
      -- disable some builtin Vim plugins to reduce startup time
      disabled_plugins = {
        'gzip', 'matchit', 'matchparen', 'netrwPlugin', 'tarPlugin', 'tohtml', 'tutor', 'zipPlugin',
      },
    },
  },
})

