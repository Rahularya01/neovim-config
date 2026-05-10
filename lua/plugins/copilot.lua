return {
  "github/copilot.vim",
  cmd = "Copilot",
  event = "BufWinEnter",
  init = function()
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_hide_during_completion = false
  end,
  config = function()
    vim.api.nvim_create_augroup("github_copilot", { clear = true })
    vim.api.nvim_create_autocmd({ "FileType", "BufUnload" }, {
      group = "github_copilot",
      callback = function(args)
        vim.fn["copilot#On" .. args.event]()
      end,
    })
    vim.fn["copilot#OnFileType"]()
  end,
  keys = {
    {
      "<M-[>",
      "<Plug>(copilot-previous)",
      mode = "i",
      desc = "Previous Copilot Suggestion",
    },
    {
      "<M-]>",
      "<Plug>(copilot-next)",
      mode = "i",
      desc = "Next Copilot Suggestion",
    },
    {
      "<leader>acp",
      "<cmd>Copilot panel<cr>",
      desc = "Open Copilot Panel",
    },
  },
}
