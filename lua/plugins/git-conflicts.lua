return {
	"akinsho/git-conflict.nvim",
	version = "*",
	event = "VeryLazy",
	config = function()
		require("git-conflict").setup({
			default_mappings = true, -- disable buffer local mapping created by this plugin
			default_commands = true, -- disable commands created by this plugin
			disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
			list_opener = "copen", -- command or function to open the conflicts list
			highlights = { -- They must have background color, otherwise the default color will be used
				incoming = "DiffAdd",
				current = "DiffText",
			},
		})

		-- Keymaps for easier resolution
		vim.keymap.set("n", "<leader>co", "<cmd>GitConflictChooseOurs<CR>", { desc = "Choose Ours" })
		vim.keymap.set("n", "<leader>ct", "<cmd>GitConflictChooseTheirs<CR>", { desc = "Choose Theirs" })
		vim.keymap.set("n", "<leader>cb", "<cmd>GitConflictChooseBoth<CR>", { desc = "Choose Both" })
		vim.keymap.set("n", "<leader>cn", "<cmd>GitConflictNextConflict<CR>", { desc = "Next Conflict" })
		vim.keymap.set("n", "<leader>cp", "<cmd>GitConflictPrevConflict<CR>", { desc = "Previous Conflict" })
	end,
}
