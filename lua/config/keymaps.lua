local map = vim.keymap.set

-- Window navigation (tmux-aware)
map("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Go to left window" })
map("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Go to lower window" })
map("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Go to upper window" })
map("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Go to right window" })
map("t", "<C-h>", "<C-\\><C-n><cmd>TmuxNavigateLeft<cr>", { desc = "Go to left window" })
map("t", "<C-j>", "<C-\\><C-n><cmd>TmuxNavigateDown<cr>", { desc = "Go to lower window" })
map("t", "<C-k>", "<C-\\><C-n><cmd>TmuxNavigateUp<cr>", { desc = "Go to upper window" })
map("t", "<C-l>", "<C-\\><C-n><cmd>TmuxNavigateRight<cr>", { desc = "Go to right window" })

-- Buffer navigation
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer", silent = true })
map("n", "<S-h>", "<cmd>bprev<cr>", { desc = "Previous buffer", silent = true })

-- Window management
map("n", "<leader>v", "<cmd>vsplit<cr>", { desc = "Split window right", silent = true })
map("n", "<leader>rc", "<cmd>RemoveComments<cr>", { desc = "Remove comments", silent = true })

-- Search
map("n", "<Esc>", function()
  if vim.v.hlsearch == 1 then
    vim.cmd("nohlsearch")
  end
end, { desc = "Clear search highlights" })

-- Line movement
map("n", "<M-J>", ":m .+1<CR>==", { desc = "Move line down", silent = true })
map("n", "<M-K>", ":m .-2<CR>==", { desc = "Move line up", silent = true })
map("v", "<M-J>", ":m '>+1<CR>gv=gv", { desc = "Move selection down", silent = true })
map("v", "<M-K>", ":m '<-2<CR>gv=gv", { desc = "Move selection up", silent = true })

-- Save
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Buffer management
map("n", "<C-x>", "<cmd>bd<cr>", { desc = "Close buffer", silent = true })
map("n", "<leader>bc", "<cmd>silent! %bd!<cr>", { desc = "Close all buffers silently", silent = true })

-- Exit insert mode
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- Quickfix
map("n", "<leader>q", "<cmd>copen<cr>", { desc = "Open quickfix list", silent = true })

-- Save
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file", silent = true })

-- Toggle options
map("n", "<leader>ul", function()
  vim.opt.list = not vim.opt.list:get()
end, { desc = "Toggle listchars (show whitespace)" })

map("n", "<leader>us", function()
  vim.opt.spell = not vim.opt.spell:get()
end, { desc = "Toggle spell checking" })

-- Folds
map("n", "zR", function()
  vim.opt.foldlevel = 99
end, { desc = "Open all folds" })
map("n", "zM", function()
  vim.opt.foldlevel = 0
end, { desc = "Close all folds" })


