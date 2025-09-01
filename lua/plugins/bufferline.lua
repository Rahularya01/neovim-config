return {
  'akinsho/bufferline.nvim',
  dependencies = {
    'moll/vim-bbye',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    local bufferline = require 'bufferline'
    bufferline.setup {
      options = {
        offsets = {
          {
            filetype = 'neo-tree',
            text = '',
            highlight = 'Directory',
            separator = true,
          },
        },
        mode = 'buffers', -- Show buffers rather than tabpages
        themable = true, -- Allow highlight overrides
        numbers = 'none', -- Disable buffer numbers
        close_command = 'Bdelete! %d',
        buffer_close_icon = '✗',
        close_icon = '✗',
        modified_icon = '●',
        left_trunc_marker = '',
        right_trunc_marker = '',
        max_name_length = 30,
        max_prefix_length = 30,
        tab_size = 21,
        diagnostics = 'nvim_lsp',
        diagnostics_indicator = function(count, level)
          local icon = level:match 'error' and '' or (level:match 'warn' and '' or '')
          return ' ' .. icon .. ' ' .. count
        end,
        color_icons = true,
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        persist_buffer_sort = true,
        separator_style = 'thick', -- Use thick separators for better visibility
        enforce_regular_tabs = true,
        always_show_bufferline = true,
        show_tab_indicators = true,
        indicator = {
          icon = '▎', -- Visible indicator for current buffer
          style = 'icon',
        },
        icon_pinned = '󰐃',
        minimum_padding = 1,
        maximum_padding = 5,
        maximum_length = 15,
        sort_by = 'insert_at_end',
        disabled_filetypes = { 'neo-tree', 'NvimTree' },
      },
  -- Use Catppuccin integration for bufferline to get the Mocha palette, if available
  highlights = (function()
    local ok, groups = pcall(require, 'catppuccin.groups.integrations.bufferline')
    if ok and groups and groups.get then
      return groups.get { style = 'mocha' }
    end
    return nil
  end)(),
    }

    -- Keymaps for buffer navigation and closing
    local opts = { noremap = true, silent = true }
  end,
}
