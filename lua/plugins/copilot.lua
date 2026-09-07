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
    nes = {
      enabled = true,
      keymap = {
        -- NES mappings apply in normal mode, so this does not conflict with
        -- the insert-mode Blink/Copilot ghost-text <Tab> mapping.
        accept_and_goto = false,
        accept = "<Tab>",
        -- Keep this distinct from the insert-mode ghost-text dismiss mapping;
        -- copilot.lua validates these keys globally, even across modes.
        dismiss = "<C-g>",
      },
    },
  },
}
