return {
	"rmagatti/auto-session",
	lazy = false, -- Load immediately to restore session on startup
	config = function()
		require("auto-session").setup({
			log_level = "error",

			-- Suppress session for these directories
			suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },

			-- Don't save these file types
			bypass_session_save_file_types = {
				"neo-tree",
				"NvimTree",
				"dapui_scopes",
				"dapui_breakpoints",
				"dapui_stacks",
				"dapui_watches",
			},

			-- Fix: Run :edit on the current buffer after restore to trigger Treesitter/LSP
			post_restore_cmds = {
				function()
					vim.cmd("edit")
				end,
			},

			-- Keymaps
			vim.keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session" }),
			vim.keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session" }),
		})
	end,
}
