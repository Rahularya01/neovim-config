local gh = require("config.pack").gh
vim.pack.add({
  gh("folke/flash.nvim"),
  gh("kylechui/nvim-surround"),
  gh("windwp/nvim-autopairs"),
  gh("MagicDuck/grug-far.nvim"),
  gh("folke/trouble.nvim"),
  gh("folke/persistence.nvim"),
})
local map = vim.keymap.set

-- Jump (Cursor: vim.sneak) ------------------------------------------------------
require("flash").setup({ modes = { search = { enabled = false }, char = { jump_labels = true } } })
map({ "n", "x", "o" }, "s", function()
  require("flash").jump()
end, { desc = "Flash" })
map({ "n", "x", "o" }, "S", function()
  require("flash").treesitter()
end, { desc = "Flash treesitter" })
map("o", "r", function()
  require("flash").remote()
end, { desc = "Remote flash" })
map({ "o", "x" }, "R", function()
  require("flash").treesitter_search()
end, { desc = "Treesitter search" })

-- Surround (Cursor: vim.surround) — ys / ds / cs
require("nvim-surround").setup()

-- Pairs
require("nvim-autopairs").setup({ check_ts = true })

-- Search & replace (Cursor: replaceInFiles) ---------------------------------------
require("grug-far").setup({ headerMaxWidth = 80 })
map("n", "<leader>sr", function()
  require("grug-far").open()
end, { desc = "Search & replace" })
map("n", "<leader>sR", function()
  require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
end, { desc = "Search & replace (file)" })
map({ "n", "x" }, "<leader>sW", function()
  local grug = require("grug-far")
  if vim.fn.mode():match("[vV]") then
    grug.with_visual_selection()
  else
    grug.open({ prefills = { search = vim.fn.expand("<cword>") } })
  end
end, { desc = "Replace word / selection" })

-- Problems panel (Cursor: workbench.actions.view.problems) --------------------------
require("trouble").setup({ focus = true })
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (workspace)" })
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Diagnostics (buffer)" })
map("n", "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols outline" })
map("n", "<leader>xr", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", { desc = "LSP refs / defs" })
map("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location list" })
map("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix list" })
map("n", "<leader>xt", "<cmd>Trouble todo toggle<cr>", { desc = "Todos" })
map("n", "]q", function()
  if require("trouble").is_open() then
    require("trouble").next({ skip_groups = true, jump = true })
  else
    pcall(vim.cmd.cnext)
  end
end, { desc = "Next trouble / quickfix" })
map("n", "[q", function()
  if require("trouble").is_open() then
    require("trouble").prev({ skip_groups = true, jump = true })
  else
    pcall(vim.cmd.cprev)
  end
end, { desc = "Prev trouble / quickfix" })

-- Sessions ----------------------------------------------------------------------
require("persistence").setup()
map("n", "<leader>wr", function()
  require("persistence").load()
end, { desc = "Restore session (cwd)" })
map("n", "<leader>wR", function()
  require("persistence").load({ last = true })
end, { desc = "Restore last session" })
map("n", "<leader>ws", function()
  require("persistence").select()
end, { desc = "Select session" })
map("n", "<leader>wd", function()
  require("persistence").stop()
end, { desc = "Don't save session" })
