local platform = require("config.platform")

vim.g.barbar_auto_setup = false -- we call setup() ourselves via lazy's opts

return {
  "romgrk/barbar.nvim",
  cond = platform.not_vscode,
  -- Bufferline chrome should be present from the first frame; on VeryLazy it
  -- pops in a tick after startup instead of being there immediately.
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    animation = false,
    sidebar_filetypes = {
      ["neo-tree"] = true,
      oil = true,
    },
  },
  keys = {
    { "<A-,>", "<cmd>BufferPrevious<cr>", desc = "Previous buffer" },
    { "<A-.>", "<cmd>BufferNext<cr>", desc = "Next buffer" },
    { "<leader>bp", "<cmd>BufferPick<cr>", desc = "Pick buffer" },
  },
}
