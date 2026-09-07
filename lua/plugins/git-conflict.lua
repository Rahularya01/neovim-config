local platform = require("config.platform")

return {
  "akinsho/git-conflict.nvim",
  cond = platform.not_vscode,
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    default_mappings = true, -- co/ct/cb/c0 to choose ours/theirs/both/none
    disable_diagnostics = false,
  },
  keys = {
    { "]x", "<cmd>GitConflictNextConflict<cr>", desc = "Next git conflict" },
    { "[x", "<cmd>GitConflictPrevConflict<cr>", desc = "Prev git conflict" },
  },
}
