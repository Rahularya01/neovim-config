local map = vim.keymap.set

map("n", "<C-h>", "<cmd><C-U>TmuxNavigateLeft<cr>", { desc = "Go to left window" })
map("n", "<C-j>", "<cmd><C-U>TmuxNavigateDown<cr>", { desc = "Go to lower window" })
map("n", "<C-k>", "<cmd><C-U>TmuxNavigateUp<cr>", { desc = "Go to upper window" })
map("n", "<C-l>", "<cmd><C-U>TmuxNavigateRight<cr>", { desc = "Go to right window" })
map("t", "<C-h>", "<C-\\><C-n><cmd><C-U>TmuxNavigateLeft<cr>", { desc = "Go to left window" })
map("t", "<C-j>", "<C-\\><C-n><cmd><C-U>TmuxNavigateDown<cr>", { desc = "Go to lower window" })
map("t", "<C-k>", "<C-\\><C-n><cmd><C-U>TmuxNavigateUp<cr>", { desc = "Go to upper window" })
map("t", "<C-l>", "<C-\\><C-n><cmd><C-U>TmuxNavigateRight<cr>", { desc = "Go to right window" })

map("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<S-h>", ":bprev<CR>", { desc = "Previous buffer" })

map("n", "<leader>v", ":vsplit<CR>", { desc = "Split window right" })

map("n", "<Esc>", function()
	if vim.v.hlsearch and vim.v.hlsearch == 1 then
		vim.cmd("nohlsearch")
	end
end, { desc = "Clear search highlights" })

map("n", "<M-J>", ":m .+1<CR>==", { desc = "Move line down" })
map("n", "<M-K>", ":m .-2<CR>==", { desc = "Move line up" })
map("v", "<M-J>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<M-K>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

map("n", "<leader>bd", ":bd<CR>", { desc = "Close buffer" })
map("n", "<C-x>", ":bd<CR>", { desc = "Close buffer" })

map("i", "jk", "<Esc>", { desc = "Exit insert mode" })

map("n", "<leader>q", ":copen<CR>", { desc = "Open quickfix list" })

map("n", "<leader>w", ":w<CR>", { desc = "Save file" })

map("n", "<C-\\>", ":ToggleTerm<CR>", { desc = "Toggle terminal" })

map("n", "<leader>bc", ":silent! %bd!<CR>", { desc = "Close all buffers silently" })

map("n", "<leader>ul", function()
	vim.opt.list = not vim.opt.list:get()
end, { desc = "Toggle listchars (show whitespace)" })

map("n", "<leader>us", function()
	vim.opt.spell = not vim.opt.spell:get()
end, { desc = "Toggle spell checking" })
