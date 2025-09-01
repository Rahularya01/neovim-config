-- Easily comment visual regions/lines
return {
  'numToStr/Comment.nvim',
  dependencies = {
    'JoosepAlviste/nvim-ts-context-commentstring', -- Better JSX/TSX commenting
  },

  config = function()
    -- Setup treesitter integration for context-aware commenting
    require('ts_context_commentstring').setup {
      enable_autocmd = false,
    }

    require('Comment').setup {
      -- Enable integration with treesitter for better JSX/TSX support
      pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
    }

    local opts = { noremap = true, silent = true }
    vim.keymap.set('n', '<C-_>', require('Comment.api').toggle.linewise.current, opts)
    vim.keymap.set('n', '<C-c>', require('Comment.api').toggle.linewise.current, opts)
    vim.keymap.set('n', '<C-/>', require('Comment.api').toggle.linewise.current, opts)
    vim.keymap.set('v', '<C-_>', "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", opts)
    vim.keymap.set('v', '<C-c>', "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", opts)
    vim.keymap.set('v', '<C-/>', "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", opts)
  end,
}
