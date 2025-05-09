return {
  "numToStr/Comment.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  config = function()
    -- Safely require modules with error handling
    local ok, comment = pcall(require, "Comment")
    if not ok then
      vim.notify("Failed to load Comment.nvim", vim.log.levels.ERROR)
      return
    end

    local ts_integration = require("ts_context_commentstring.integrations.comment_nvim")

    -- Enable comment with configuration
    comment.setup({
      -- For commenting tsx, jsx, svelte, html files
      pre_hook = ts_integration.create_pre_hook(),

      -- Optional: Add mappings (default mappings are good but you can customize)
      -- mappings = {
      --   basic = true,    -- Enable basic mappings like gcc and gbc
      --   extra = false,   -- Disable extra mappings
      -- },

      -- Optional: Add padding between comment delimiter and content
      padding = true,

      -- Optional: Enable sticky comments (preserves cursor position)
      sticky = true,
    })
  end,
}
