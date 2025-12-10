return {
	"rmagatti/auto-session",
	lazy = false, -- We want this to load immediately to restore the session
	keys = {
		{ "<leader>qs", "<cmd>SessionSearch<CR>", desc = "Session Search" },
		{ "<leader>qd", "<cmd>SessionDelete<CR>", desc = "Delete Session" },
	},
	opts = {
		log_level = "error",

		auto_session_enable_last_session = false, -- Don't automatically load last session on startup (explicit is usually better)
		auto_save_enabled = true, -- Auto save when exiting
		auto_restore_enabled = true,

		auto_session_suppress_dirs = { "~/", "~/Downloads", "~/Documents", "~/Desktop", "/" },

		-- 4. Visual tweaks
		session_lens = {
			-- If you load Telescope later, this will look nice
			buftypes_to_ignore = {}, -- list of buffer types to ignore
			load_on_setup = true,
			theme_conf = { border = true },
			previewer = false,
		},
	},
}
