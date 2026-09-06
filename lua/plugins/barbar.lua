local platform = require("config.platform")

vim.g.barbar_auto_setup = false -- we call setup() ourselves via lazy's opts

return {
  "romgrk/barbar.nvim",
  cond = platform.not_vscode,
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    animation = false,
    sidebar_filetypes = { oil = true },
  },
  keys = {
    { "<A-,>", "<cmd>BufferPrevious<cr>", desc = "Previous buffer" },
    { "<A-.>", "<cmd>BufferNext<cr>", desc = "Next buffer" },
    { "<leader>bp", "<cmd>BufferPick<cr>", desc = "Pick buffer" },
  },
}
