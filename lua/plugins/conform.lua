return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  opts = {
    default_format_opts = {
      timeout_ms = 3000,
      lsp_format = 'fallback',
    },
    formatters_by_ft = {
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
      typescript = { 'prettierd', 'prettier', stop_after_first = true },
      javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
      typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
      svelte = { 'prettierd', 'prettier', stop_after_first = true },
      css = { 'prettierd', 'prettier', stop_after_first = true },
      html = { 'prettierd', 'prettier', stop_after_first = true },
      json = { 'prettierd', 'prettier', stop_after_first = true },
      yaml = { 'prettierd', 'prettier', stop_after_first = true },
      markdown = { 'prettierd', 'prettier', stop_after_first = true },
      graphql = { 'prettierd', 'prettier', stop_after_first = true },
      lua = { 'stylua' },
      python = { 'isort', 'black' },
      sh = { 'shfmt' },
      fish = { 'fish_indent' },
      -- Fallback formatters
      ['*'] = { 'codespell' },
      ['_'] = { 'trim_whitespace' },
    },
    format_on_save = {
      timeout_ms = 3000,
      lsp_format = 'fallback',
    },
    formatters = {
      prettierd = {
        -- make sure it uses project local binaries/config
        prefer_local = 'node_modules/.bin',
      },
    },
  },
}
