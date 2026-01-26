return {
	"rmagatti/auto-session",
	event = "VimEnter",

	config = function()
		require("auto-session").setup({
			log_level = "error",

			suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },

			bypass_session_save_file_types = {
				"oil",
				"NeoTree",
				"dapui_scopes",
				"dapui_breakpoints",
				"dapui_stacks",
				"dapui_watches",
			},

			post_restore_cmds = {
				function()
					vim.cmd("edit")
				end,
			},

			vim.keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session" }),
			vim.keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session" }),
		})
	end,
}
