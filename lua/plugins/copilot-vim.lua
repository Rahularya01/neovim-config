local platform = require("config.platform")

return {
  "github/copilot.vim",
  cond = platform.not_vscode,
  event = "BufWinEnter",
  cmd = "Copilot",
  init = function()
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_hide_during_completion = false
  end,
  config = function()
    
    vim.fn["copilot#Init"]()
    vim.fn["copilot#OnFileType"]()
  end,
}
