return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "LspAttach",
  priority = 1000,
  opts = {
    preset = "modern",
    transparent_cursorline = true,
    options = {
      show_source = {
        enabled = true,
      },
      show_code = true,
      throttle = 20,
      multilines = {
        enabled = true,
      },
      overflow = {
        mode = "wrap",
      },
    },
  },
  config = function(_, opts)
    require("tiny-inline-diagnostic").setup(opts)
    -- Disable default virtual text to avoid conflicts
    vim.diagnostic.config({ virtual_text = false })
  end,
  keys = {
    { "<leader>ud", "<cmd>TinyInlineDiag toggle<cr>", desc = "Toggle inline diagnostics" },
    { "<leader>uc", "<cmd>TinyInlineDiag toggle_cursor_only<cr>", desc = "Toggle cursor-only diagnostics" },
  },
}
