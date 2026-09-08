local platform = require("config.platform")

return {
  "zbirenbaum/copilot.lua",
  cond = platform.not_vscode,
  cmd = "Copilot",
  event = "InsertEnter",
  dependencies = {
    {
      "copilotlsp-nvim/copilot-lsp",
      init = function()
        -- Avoid requesting next-edit suggestions while a rapid sequence of
        -- edits is still in progress.
        vim.g.copilot_nes_debounce = 500
      end,
    },
  },
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      keymap = {
        -- <Tab> accepts ghost-text, but the binding lives in blink-cmp.lua
        -- (it checks suggestion.is_visible() before falling back to
        -- snippet-forward/completion) so it doesn't fight blink.cmp's own
        -- <Tab> handling. Disable copilot's own accept keymap here.
        accept = false,
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<C-]>",
      },
    },
    panel = { enabled = false },
    -- Next Edit Suggestions are handled by sidekick.nvim's <Tab> mapping
    -- (via the shared copilot-lsp server), so copilot.lua's own NES UI is
    -- disabled here to avoid two plugins fighting over the same keymap.
    nes = { enabled = false },
  },
}
