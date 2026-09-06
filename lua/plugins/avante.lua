local platform = require("config.platform")

return {
  "yetone/avante.nvim",
  cond = platform.not_vscode,
  event = "VeryLazy",
  version = false, -- avante recommends tracking main, not a tag
  build = "make",
  opts = {
    provider = "claude",
    providers = {
      claude = {
        endpoint = "https://api.anthropic.com",
        model = "claude-sonnet-5",
      },
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<leader>aa", "<cmd>AvanteAsk<cr>", desc = "Avante: Ask", mode = { "n", "v" } },
    { "<leader>ae", "<cmd>AvanteEdit<cr>", desc = "Avante: Edit", mode = "v" },
    { "<leader>at", "<cmd>AvanteToggle<cr>", desc = "Avante: Toggle sidebar" },
  },
}
