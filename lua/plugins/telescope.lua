return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local builtin = require("telescope.builtin")
		-- VS Code mappings
		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
		vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "Find in files" })
		vim.keymap.set("n", "<leader>.", builtin.buffers, { desc = "Show all buffers" })
		vim.keymap.set("n", "<leader>cs", builtin.lsp_document_symbols, { desc = "Go to symbol" })
		vim.keymap.set("n", "<leader>ws", builtin.lsp_workspace_symbols, { desc = "Workspace symbols" })
	end,
}
