return {
	"folke/snacks.nvim",
	priority = 1000,
	event = "VeryLazy",
	opts = {
		-- Better vim.ui.input
		input = { enabled = true },
		-- Better vim.ui.select
		picker = {
			enabled = true,
			-- Explicitly map Ctrl+j and Ctrl+k for navigation
			keys = {
				next = "<C-j>",
				prev = "<C-k>",
			},
		},
		terminal = { enabled = true },
		notifier = { enabled = true },
		indent = { enabled = true },
		lazygit = { enabled = true },
	},
	keys = {
		{
			"<leader>lg",
			function()
				Snacks.lazygit()
			end,
			desc = "LazyGit",
		},
		{
			"<leader>un",
			function()
				Snacks.notifier.show_history()
			end,
			desc = "Notification History",
		},
	},
}
