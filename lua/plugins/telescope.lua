return {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	keys = {
		{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
		{ "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Find in files" },
		{ "<leader>.", "<cmd>Telescope buffers<cr>", desc = "Show all buffers" },
		{ "<leader>cs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Go to symbol" },
		{ "<leader>ws", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace symbols" },
	},
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		defaults = {
			file_ignore_patterns = { "node_modules", ".git/" },
			vimgrep_arguments = {
				"rg",
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
				"--smart-case",
				"--hidden",
			},
		},
	},
}
