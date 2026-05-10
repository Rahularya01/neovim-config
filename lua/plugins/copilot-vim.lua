return {
  "github/copilot.vim",
  event = "BufWinEnter",
  cmd = "Copilot",
  init = function()
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_hide_during_completion = false
  end,
  config = function()
    -- copilot.vim loads lazily after VimEnter, so Init() never ran automatically
    vim.fn["copilot#Init"]()
    vim.fn["copilot#OnFileType"]()
  end,
}
