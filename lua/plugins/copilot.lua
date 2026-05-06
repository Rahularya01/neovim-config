return {
  "zbirenbaum/copilot.lua",
  dependencies = {
    {
      "copilotlsp-nvim/copilot-lsp",
      init = function()
        vim.g.copilot_nes_debounce = 500
      end,
    },
  },
  cmd = { "Copilot" },
  event = "VeryLazy",
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      hide_during_completion = false,
      keymap = {
        accept = false,
        accept_word = false,
        accept_line = false,
        next = false,
        prev = false,
        dismiss = false,
      },
    },
    nes = {
      enabled = true,
      auto_trigger = true,
      keymap = {
        accept_and_goto = "<tab>",
        accept = false,
        dismiss = "<Esc>",
      },
    },
    panel = {
      enabled = true,
      auto_refresh = true,
    },
  },
  keys = {
    {
      "<M-[>",
      function()
        require("copilot.suggestion").prev()
      end,
      mode = "i",
      desc = "Previous Copilot Suggestion",
    },
    {
      "<M-]>",
      function()
        require("copilot.suggestion").next()
      end,
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
