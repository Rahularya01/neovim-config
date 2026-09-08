local platform = require("config.platform")

return {
  "rmagatti/auto-session",
  cond = platform.not_vscode,
  -- Must load before VimEnter (not lazily on a trigger) so it can restore
  -- the session as soon as Neovim starts.
  lazy = false,
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
    auto_save = true,
    auto_restore = true,
    session_lens = {
      -- Auto-detects Snacks (already configured as the picker in this repo).
      load_on_setup = true,
    },
  },
  keys = {
    { "<leader>wr", "<cmd>AutoSession restore<cr>", desc = "Restore session (cwd)" },
    { "<leader>ws", "<cmd>AutoSession save<cr>", desc = "Save session" },
    { "<leader>wf", "<cmd>AutoSession search<cr>", desc = "Find session" },
    { "<leader>wd", "<cmd>AutoSession delete<cr>", desc = "Delete session" },
    { "<leader>wa", "<cmd>AutoSession toggle<cr>", desc = "Toggle autosave" },
  },
}
