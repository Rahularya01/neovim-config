-- Keymaps based on VS Code settings

local map = vim.keymap.set

-- Better window navigation (tmux-aware)
map("n", "<C-h>", "<cmd><C-U>TmuxNavigateLeft<cr>", { desc = "Go to left window" })
map("n", "<C-j>", "<cmd><C-U>TmuxNavigateDown<cr>", { desc = "Go to lower window" })
map("n", "<C-k>", "<cmd><C-U>TmuxNavigateUp<cr>", { desc = "Go to upper window" })
map("n", "<C-l>", "<cmd><C-U>TmuxNavigateRight<cr>", { desc = "Go to right window" })
map("t", "<C-h>", "<C-\\><C-n><cmd><C-U>TmuxNavigateLeft<cr>", { desc = "Go to left window" })
map("t", "<C-j>", "<C-\\><C-n><cmd><C-U>TmuxNavigateDown<cr>", { desc = "Go to lower window" })
map("t", "<C-k>", "<C-\\><C-n><cmd><C-U>TmuxNavigateUp<cr>", { desc = "Go to upper window" })
map("t", "<C-l>", "<C-\\><C-n><cmd><C-U>TmuxNavigateRight<cr>", { desc = "Go to right window" })

-- Buffer navigation (Shift-L/H)
map("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<S-h>", ":bprev<CR>", { desc = "Previous buffer" })

-- Window splitting
map("n", "<leader>v", ":vsplit<CR>", { desc = "Split window right" })

-- Clear search highlights (only when search is active)
map("n", "<Esc>", function()
	if vim.v.hlsearch and vim.v.hlsearch == 1 then
		vim.cmd("nohlsearch")
	end
end, { desc = "Clear search highlights" })

-- Move lines (Alt-Shift-j/k) - M is Alt
map("n", "<M-J>", ":m .+1<CR>==", { desc = "Move line down" })
map("n", "<M-K>", ":m .-2<CR>==", { desc = "Move line up" })
map("v", "<M-J>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<M-K>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Close buffer (Space x - mapped to closeActiveEditor in VSCode)
map("n", "<leader>bd", ":bd<CR>", { desc = "Close buffer" })
map("n", "<C-x>", ":bd<CR>", { desc = "Close buffer" })

-- Insert mode escape
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- Quickfix and location lists
map("n", "<leader>q", ":copen<CR>", { desc = "Open quickfix list" })

-- Alternative save
map("n", "<leader>w", ":w<CR>", { desc = "Save file" })

-- Terminal toggle
map("n", "<C-\\>", ":ToggleTerm<CR>", { desc = "Toggle terminal" })

-- Close ALL buffers with Leader + bc
-- :%bd deletes all buffers. If you have unsaved changes, Vim will prompt you.
map("n", "<leader>bc", ":silent! %bd!<CR>", { desc = "Close all buffers silently" })

-- Toggle listchars (show whitespace)
map("n", "<leader>ul", function()
	vim.opt.list = not vim.opt.list:get()
end, { desc = "Toggle listchars (show whitespace)" })

-- Toggle spell checking
map("n", "<leader>us", function()
	vim.opt.spell = not vim.opt.spell:get()
end, { desc = "Toggle spell checking" })
