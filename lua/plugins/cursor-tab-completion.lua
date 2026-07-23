return {
  dir = vim.fn.expand("~/Projects/Personal/cursor-tab-completion.nvim"),
  name = "cursor-tab-completion.nvim",
  event = "InsertEnter",
  cmd = {
    "CursorTabCompletionLogin",
    "CursorTabCompletionLogout",
    "CursorTabCompletionStatus",
    "CursorTabCompletionToggle",
    "CursorTabCompletionSnooze",
  },
  -- Normal-mode Tab for NES (Insert Tab is wired through blink.cmp).
  keys = {
    {
      "<Tab>",
      function()
        if require("cursor_tab_completion").nes_jump_or_apply() then
          return ""
        end
        return "<Tab>"
      end,
      mode = "n",
      expr = true,
      silent = true,
      desc = "Cursor Tab NES jump/apply",
    },
  },
  opts = {
    debounce_ms = 40,
    cursor_debounce_ms = 60,
    accept_debounce_ms = 0,
    nes_debounce_ms = 120,
    -- Insert <Tab> stays in blink.cmp; don't auto-map here.
    keymaps = false,
  },
}
