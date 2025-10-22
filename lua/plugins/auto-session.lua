-- Create this file at: lua/rahul/plugins/auto-session.lua

return {
	"rmagatti/auto-session",
	lazy = false, -- Load immediately for session management
	config = function()
		local auto_session = require("auto-session")

		auto_session.setup({
			log_level = "error",

			-- Basic configuration for better compatibility
			auto_save_enabled = true,
			auto_restore_enabled = true,
			auto_session_suppress_dirs = {
				"~/",
				"~/Downloads",
				"/tmp",
				"/",
			},

			-- Session lens configuration
			session_lens = {
				buftypes_to_ignore = {},
				load_on_setup = true,
				theme_conf = { border = true },
				previewer = false,
			},

			-- Pre and post hooks for better stability
			pre_save_cmds = {
				"silent! NeoTreeClose",
				"silent! SymbolsOutlineClose",
				"silent! TroubleClose",
			},

			post_restore_cmds = {
				"silent! do User SessionRestored",
			},
		})

		-- Key mappings for session management
		vim.keymap.set("n", "<leader>ser", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" })
		vim.keymap.set("n", "<leader>ses", "<cmd>SessionSave<CR>", { desc = "Save session for cwd" })
		vim.keymap.set("n", "<leader>sea", "<cmd>SessionSearch<CR>", { desc = "Search sessions" })
		vim.keymap.set("n", "<leader>sed", "<cmd>SessionDelete<CR>", { desc = "Delete session for cwd" })
	end,
}
