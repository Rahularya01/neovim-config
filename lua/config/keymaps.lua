local map = vim.keymap.set

map("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Go to left window" })
map("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Go to lower window" })
map("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Go to upper window" })
map("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Go to right window" })
map("t", "<C-h>", "<C-\\><C-n><cmd>TmuxNavigateLeft<cr>", { desc = "Go to left window" })
map("t", "<C-j>", "<C-\\><C-n><cmd>TmuxNavigateDown<cr>", { desc = "Go to lower window" })
map("t", "<C-k>", "<C-\\><C-n><cmd>TmuxNavigateUp<cr>", { desc = "Go to upper window" })
map("t", "<C-l>", "<C-\\><C-n><cmd>TmuxNavigateRight<cr>", { desc = "Go to right window" })

map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer", silent = true })
map("n", "<S-h>", "<cmd>bprev<cr>", { desc = "Previous buffer", silent = true })

map("n", "<leader>v", "<cmd>vsplit<cr>", { desc = "Split window right", silent = true })
map("n", "<leader>rc", "<cmd>RemoveComments<cr>", { desc = "Remove comments", silent = true })

map("n", "<Esc>", function()
	if vim.v.hlsearch == 1 then
		vim.cmd("nohlsearch")
	end
end, { desc = "Clear search highlights" })

map("n", "<M-J>", ":m .+1<CR>==", { desc = "Move line down", silent = true })
map("n", "<M-K>", ":m .-2<CR>==", { desc = "Move line up", silent = true })
map("v", "<M-J>", ":m '>+1<CR>gv=gv", { desc = "Move selection down", silent = true })
map("v", "<M-K>", ":m '<-2<CR>gv=gv", { desc = "Move selection up", silent = true })

map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

map("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Close buffer", silent = true })
map("n", "<C-x>", "<cmd>bd<cr>", { desc = "Close buffer", silent = true })

map("i", "jk", "<Esc>", { desc = "Exit insert mode" })

map("n", "<leader>q", "<cmd>copen<cr>", { desc = "Open quickfix list", silent = true })

map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file", silent = true })

map("n", "<C-\\>", function()
	Snacks.terminal()
end, { desc = "Toggle terminal" })

map("n", "<leader>bc", "<cmd>silent! %bd!<cr>", { desc = "Close all buffers silently", silent = true })

map("n", "<leader>ul", function()
	vim.opt.list = not vim.opt.list:get()
end, { desc = "Toggle listchars (show whitespace)" })

map("n", "<leader>us", function()
	vim.opt.spell = not vim.opt.spell:get()
end, { desc = "Toggle spell checking" })
