local gh = require("config.pack").gh
vim.pack.add({ gh("folke/sidekick.nvim") })

-- Copilot inline suggestions via the native LSP client (Cursor: github.copilot.enable).
-- The `copilot` server is installed + enabled by mason-lspconfig in lsp.lua.
-- First run: :LspCopilotSignIn
if vim.lsp.inline_completion then
  vim.lsp.inline_completion.enable()
  vim.keymap.set("i", "<M-]>", function()
    vim.lsp.inline_completion.select({ count = 1 })
  end, { desc = "Next suggestion" })
  vim.keymap.set("i", "<M-[>", function()
    vim.lsp.inline_completion.select({ count = -1 })
  end, { desc = "Prev suggestion" })
  Snacks.toggle({
    name = "Copilot suggestions",
    get = function()
      return vim.lsp.inline_completion.is_enabled()
    end,
    set = function(on)
      vim.lsp.inline_completion.enable(on)
    end,
  }):map("<leader>ug")
end
-- Cursor: copilot disabled for plaintext / markdown / scminput
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("user_copilot_ft", { clear = true }),
  pattern = { "text", "markdown", "gitcommit" },
  callback = function(ev)
    if vim.lsp.inline_completion then
      vim.lsp.inline_completion.enable(false, { bufnr = ev.buf })
    end
  end,
})

-- Claude Code / AI CLIs in a split (Cursor: <leader>a* → Claude sidebar) ------------
require("sidekick").setup({
  nes = { enabled = false }, -- editor.inline suggestions come from copilot above
  cli = { mux = { enabled = false }, win = { layout = "right" } },
})
local cli = function()
  return require("sidekick.cli")
end
local map = vim.keymap.set
map({ "n", "t", "i", "x" }, "<C-.>", function()
  cli().toggle()
end, { desc = "Sidekick toggle" })
map("n", "<leader>aa", function()
  cli().toggle()
end, { desc = "AI CLI toggle" })
map("n", "<leader>ac", function()
  cli().toggle({ name = "claude", focus = true })
end, { desc = "Claude Code" })
map("n", "<leader>as", function()
  cli().select()
end, { desc = "Select AI CLI" })
map("n", "<leader>ad", function()
  cli().close()
end, { desc = "Close AI CLI" })
map({ "n", "x" }, "<leader>at", function()
  cli().send({ msg = "{this}" })
end, { desc = "Send this" })
map("n", "<leader>af", function()
  cli().send({ msg = "{file}" })
end, { desc = "Send file" })
map("x", "<leader>av", function()
  cli().send({ msg = "{selection}" })
end, { desc = "Send selection" })
map({ "n", "x" }, "<leader>ap", function()
  cli().prompt()
end, { desc = "AI prompt" })
