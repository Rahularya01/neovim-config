return {
  'nvimtools/none-ls.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvimtools/none-ls-extras.nvim',
  },
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local null_ls = require 'null-ls'
    local formatting = null_ls.builtins.formatting

    null_ls.setup {
      -- Root directory detection for proper project awareness
      root_dir = require('null-ls.utils').root_pattern('.null-ls-root', '.neoconf.json', 'Makefile', '.git', 'package.json'),

      sources = {
        -- Formatting sources
        formatting.prettierd,
        formatting.stylua,
        formatting.black,
        formatting.isort,
        formatting.shfmt,
      },

      -- Format on save setup
      on_attach = function(client, bufnr)
        if client:supports_method 'textDocument/formatting' then
          local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
          vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format {
                async = false,
                timeout_ms = 5000,
                bufnr = bufnr,
                filter = function(c)
                  return c.name == 'null-ls'
                end,
              }
            end,
          })
        end
      end,
    }
  end,
}
