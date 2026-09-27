-- Copilot (Cursor: github.copilot.enable). Two clients of the same Mason-pinned
-- copilot-language-server (plugins/tools.lua), sharing one sign-in:
-- copilot.vim for inline suggestions, copilot-lsp's `copilot_ls` for next edit
-- suggestions. First run: :Copilot setup

-- Must be set before copilot.vim's plugin/ file is sourced by vim.pack.add().
-- Its bundled server (older, needs Node) and npx download are both bypassed.
vim.g.copilot_command = "copilot-language-server"
vim.g.copilot_version = false
vim.g.copilot_no_tab_map = true -- <Tab> accepts via completion.lua
-- Cursor: copilot disabled for plaintext / markdown / scminput
vim.g.copilot_filetypes = { text = false, markdown = false, gitcommit = false }

local gh = require("config.pack").gh
vim.pack.add({ gh("github/copilot.vim"), gh("copilotlsp-nvim/copilot-lsp") })
-- This module loads after startup, so copilot.vim missed VimEnter (which starts
-- its client) and the current buffer's FileType/BufEnter.
if vim.v.vim_did_enter == 1 then
  vim.cmd("doautocmd <nomodeline> github_copilot VimEnter")
  vim.cmd("doautocmd <nomodeline> github_copilot FileType")
  vim.cmd("doautocmd <nomodeline> github_copilot BufEnter")
end
require("plugins.lsp").enable_installed() -- copilot_ls's config exists only now

Snacks.toggle({
  name = "Copilot",
  get = function()
    return vim.g.copilot_enabled ~= false and vim.g.copilot_enabled ~= 0
  end,
  set = function(on)
    vim.cmd.Copilot(on and "enable" or "disable")
  end,
}):map("<leader>ug")

-- Next edit suggestions: normal-mode <Tab> jumps to the edit, then applies it
-- and moves to its end. Insert-mode <Tab> is in completion.lua.
vim.keymap.set("n", "<Tab>", function()
  if not vim.b.nes_state then
    return "<Tab>"
  end
  local nes = require("copilot-lsp.nes")
  local _ = nes.walk_cursor_start_edit() or (nes.apply_pending_nes() and nes.walk_cursor_end_edit())
end, { expr = true, desc = "Next edit: jump / apply" })

-- tether.nvim: editor context for Claude Code, Gemini CLI, and Codex. Local
-- checkout, so edits in the repo are live on the next :restart.
local tether_dir = vim.fn.expand("~/Projects/Personal/tether.nvim")
vim.opt.rtp:prepend(tether_dir)
vim.cmd.runtime("plugin/tether.lua")

-- Claude Code in a right split (Cursor: <leader>a* → Claude sidebar) ------------
local function claude()
  Snacks.terminal.toggle("claude", { win = { position = "right", width = 0.4 } })
end
vim.keymap.set({ "n", "t", "i", "x" }, "<C-.>", claude, { desc = "Claude Code" })
vim.keymap.set("n", "<leader>ac", claude, { desc = "Claude Code" })
