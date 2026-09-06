local platform = require("config.platform")

return {
  "zbirenbaum/copilot.lua",
  cond = platform.not_vscode,
  cmd = "Copilot",
  event = "InsertEnter",
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
  },
}
