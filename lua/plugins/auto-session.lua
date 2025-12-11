return {
	"rmagatti/auto-session",
	lazy = false, -- Load immediately to restore session on startup
	config = function()
		require("auto-session").setup({
			log_level = "error",

			-- Suppress session for these directories (keep your home cleaner)
			suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },

			-- Don't save these file types (prevents Neo-tree or DAP UI from breaking on restore)
			bypass_session_save_file_types = {
				"neo-tree",
				"NvimTree",
				"dapui_scopes",
				"dapui_breakpoints",
				"dapui_stacks",
				"dapui_watches",
			},

			-- Keymaps
			vim.keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session" }),
			vim.keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session" }),
		})
	end,
}
