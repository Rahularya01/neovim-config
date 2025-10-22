return {
  'ellisonleao/gruvbox.nvim',
  name = 'gruvbox',
  priority = 1000,
  config = function()
    -- Use Gruvbox with transparent background
    vim.o.background = 'dark'
    local has_gruvbox, gruvbox = pcall(require, 'gruvbox')
    if has_gruvbox then
      gruvbox.setup {
        terminal_colors = true,
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = false,
          emphasis = true,
          comments = true,
          operators = false,
          folds = true,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true,
        contrast = '', -- can be "hard", "soft" or empty string
        palette_overrides = {},
        overrides = {},
        dim_inactive = false,
        transparent_mode = true,
      }
      vim.cmd.colorscheme 'gruvbox'

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
      -- Gruvbox not installed; fall back safely to default colorscheme
      vim.notify('Gruvbox not found; skipping theme setup', vim.log.levels.WARN)
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
