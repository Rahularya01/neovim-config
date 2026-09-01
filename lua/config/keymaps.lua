local map = vim.keymap.set

-- Navigate Neovim windows. Herdr owns navigation between its outer panes.
map("n", "<C-h>", "<C-w>h", { desc = "Go to left Neovim window", silent = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower Neovim window", silent = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper Neovim window", silent = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right Neovim window", silent = true })
map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Go to left Neovim window", silent = true })
map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Go to lower Neovim window", silent = true })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Go to upper Neovim window", silent = true })
map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Go to right Neovim window", silent = true })

-- Buffer navigation
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer", silent = true })
map("n", "<S-h>", "<cmd>bprev<cr>", { desc = "Previous buffer", silent = true })

-- Window management
map("n", "<leader>v", "<cmd>vsplit<cr>", { desc = "Split window right", silent = true })
map("n", "<leader>rc", "<cmd>RemoveComments<cr>", { desc = "Remove comments", silent = true })

-- Clear search highlights
map("n", "<Esc>", function()
	if vim.v.hlsearch == 1 then
		vim.cmd("nohlsearch")
	end
end, { desc = "Clear search highlights", silent = true })

-- Line movement
map("n", "<M-J>", ":m .+1<CR>==", { desc = "Move line down", silent = true })
map("n", "<M-K>", ":m .-2<CR>==", { desc = "Move line up", silent = true })
map("v", "<M-J>", ":m '>+1<CR>gv=gv", { desc = "Move selection down", silent = true })
map("v", "<M-K>", ":m '<-2<CR>gv=gv", { desc = "Move selection up", silent = true })

-- Save (use <C-s>; <leader>w* reserved for sessions via persistence.nvim)
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file", silent = true })

-- Buffer management (<C-x>/<leader>bd via snacks.bufdelete)
map("n", "<leader>bc", "<cmd>silent! %bd!<cr>", { desc = "Close all buffers silently", silent = true })

-- Exit insert mode
map("i", "jk", "<Esc>", { desc = "Exit insert mode", silent = true })

-- Quickfix (Trouble: <leader>xQ)
map("n", "<leader>q", "<cmd>copen<cr>", { desc = "Open quickfix list", silent = true })

-- Toggle options
map("n", "<leader>ul", function()
	vim.opt.list = not vim.opt.list:get()
end, { desc = "Toggle listchars (show whitespace)", silent = true })

map("n", "<leader>us", function()
	vim.opt.spell = not vim.opt.spell:get()
end, { desc = "Toggle spell checking", silent = true })

-- Folds
map("n", "zR", function()
	vim.opt.foldlevel = 99
end, { desc = "Open all folds", silent = true })
map("n", "zM", function()
	vim.opt.foldlevel = 0
end, { desc = "Close all folds", silent = true })
