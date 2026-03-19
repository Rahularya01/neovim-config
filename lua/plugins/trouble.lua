return {
	"folke/trouble.nvim",
	cmd = { "Trouble" },
	keys = {
		{ "<leader>xx", "<cmd>Trouble diagnostics filter.buf=0<cr>", desc = "Document Diagnostics (Trouble)" },
		{ "<leader>xX", "<cmd>Trouble diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
		{ "<leader>xL", "<cmd>Trouble loclist<cr>", desc = "Location List (Trouble)" },
		{ "<leader>xQ", "<cmd>Trouble quickfix<cr>", desc = "Quickfix List (Trouble)" },
	},
	opts = {
		focus = true,
	},
}
