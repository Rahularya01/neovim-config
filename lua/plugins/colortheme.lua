return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  config = function()
    -- Use Catppuccin Mocha with transparent background
    vim.o.background = 'dark'
    local has_cat, catppuccin = pcall(require, 'catppuccin')
    if has_cat then
      catppuccin.setup {
        flavour = 'mocha', -- latte, frappe, macchiato, mocha
        transparent_background = true,
        term_colors = true,
        styles = {
          comments = { 'italic' },
          functions = { 'bold' },
        },
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          telescope = true,
          notify = true,
          native_lsp = { enabled = true },
          -- lualine integration removed because the installed Catppuccin package
          -- may not include `catppuccin.groups.integrations.lualine`. We set
          -- Lualine's theme directly in its plugin config instead.
          bufferline = true,
          which_key = true,
          treesitter = true,
        },
      }
      vim.cmd.colorscheme 'catppuccin'

      -- Clear background for common groups to ensure transparency is consistent
      vim.cmd [[
        highlight Normal guibg=NONE ctermbg=NONE
        highlight NormalNC guibg=NONE ctermbg=NONE
        highlight SignColumn guibg=NONE ctermbg=NONE
        highlight EndOfBuffer guibg=NONE ctermbg=NONE
        highlight NvimTreeNormal guibg=NONE ctermbg=NONE
        highlight NeoTreeNormal guibg=NONE ctermbg=NONE
        highlight TelescopeNormal guibg=NONE ctermbg=NONE
        highlight NormalFloat guibg=NONE ctermbg=NONE
        highlight FloatBorder guibg=NONE ctermbg=NONE
        highlight Pmenu guibg=NONE ctermbg=NONE
        highlight PmenuSel guibg=NONE ctermbg=NONE
      ]]
    else
      -- Catppuccin not installed; fall back safely to default colorscheme
      vim.notify('Catppuccin not found; skipping theme setup', vim.log.levels.WARN)
    end
    -- User command to toggle transparency quickly
    vim.api.nvim_create_user_command('ToggleTransparent', function()
      local groups = {
        'Normal',
        'NormalNC',
        'SignColumn',
        'EndOfBuffer',
        'NvimTreeNormal',
        'NeoTreeNormal',
        'TelescopeNormal',
        'NormalFloat',
        'FloatBorder',
        'Pmenu',
        'PmenuSel',
      }
      local set_none = false
      -- detect current state by checking Normal
      local ok, hl = pcall(vim.api.nvim_get_hl_by_name, 'Normal', true)
      if ok and hl then
        set_none = not (hl.background == nil or hl.background == 0)
      end

      for _, g in ipairs(groups) do
        if set_none then
          vim.cmd(string.format('highlight %s guibg=NONE ctermbg=NONE', g))
        else
          vim.cmd(string.format('highlight clear %s', g))
        end
      end
      print('Toggled transparency: ' .. (set_none and 'on' or 'off'))
    end, { desc = 'Toggle transparency for common groups' })
  end,
}
