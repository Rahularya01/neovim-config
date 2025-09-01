return {
  'nvim-pack/nvim-spectre',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
    'grapp-dev/nui-components.nvim',
  },
  event = 'VeryLazy',
  config = function()
    require('spectre').setup({})

    -- Keymaps
    vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', {
      desc = 'Toggle Spectre',
    })
    -- Note: <leader>sw is used by Snacks.nvim, using alternative keymap
    vim.keymap.set(
      'n',
      '<leader>sW',
      '<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
      {
        desc = 'Spectre search current word',
      }
    )
    vim.keymap.set('v', '<leader>sW', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
      desc = 'Spectre search current word',
    })
    vim.keymap.set(
      'n',
      '<leader>sp',
      '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
      {
        desc = 'Search on current file',
      }
    )
  end,
}
