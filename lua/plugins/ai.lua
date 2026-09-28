-- Copilot (Cursor: github.copilot.enable). One client, copilot-lsp's `copilot_ls`,
-- running the Mason-pinned copilot-language-server (plugins/tools.lua): Neovim's
-- built-in inline completion for ghost text, copilot-lsp for next edit
-- suggestions. Prompts for GitHub sign-in on first use.

local gh = require("config.pack").gh
vim.pack.add({ gh("copilotlsp-nvim/copilot-lsp") })

-- Cursor: copilot disabled for plaintext / markdown / scminput
local disabled_ft = { text = true, markdown = true, gitcommit = true }
vim.lsp.config("copilot_ls", {
  root_dir = function(buf, on_dir)
    if not disabled_ft[vim.bo[buf].filetype] then
      on_dir(vim.uv.cwd())
    end
  end,
})
require("plugins.lsp").enable_installed() -- copilot_ls's config exists only now

-- Ghost text; <Tab> accepts via completion.lua.
vim.lsp.inline_completion.enable(true)
Snacks.toggle({
  name = "Copilot",
  get = function()
    return vim.lsp.inline_completion.is_enabled()
  end,
  set = function(on)
    vim.lsp.inline_completion.enable(on)
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
