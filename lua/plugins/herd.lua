local platform = require("config.platform")

return {
  "MomePP/herd.nvim",
  cond = function()
    return platform.not_vscode() and vim.fn.executable("herdr") == 1
  end,
  event = "VeryLazy",
  opts = {
    -- Herdr keeps these agents alive independently of Neovim. The plugin
    -- provides a picker, persistent floating terminal, and selection sending.
    tools = {
      claude = { cmd = { "claude" } },
      codex = { cmd = { "codex" } },
    },
  },
  keys = {
    { "<leader>\\", "<cmd>Herd toggle<cr>", desc = "Toggle Herdr agent" },
    { "<leader>aH", "<cmd>Herd dashboard<cr>", desc = "Herdr agent dashboard" },
    { "<leader>ax", "<cmd>Herd diagnostics<cr>", desc = "Send diagnostics to Herdr agent" },
  },
}
