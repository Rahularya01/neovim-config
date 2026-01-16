return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		bigfile = { enabled = true },
		input = { enabled = true },
		picker = {
			enabled = true,
		},
		dashboard = { enabled = true },
		terminal = { enabled = true },
		notifier = { enabled = true },
		indent = { enabled = true },
		lazygit = { enabled = true },
		image = { enabled = true },
		scroll = { enabled = true },
	},
	keys = {
		-- Top Pickers
		{
			"<leader>.",
			function()
				Snacks.picker.buffers()
			end,
		},
		{
			"<leader>ff",
			function()
				Snacks.picker.files()
			end,
			desc = "Find Files",
		},
		{
			"<leader>sg",
			function()
				Snacks.picker.grep()
			end,
			desc = "Grep",
		},

		-- Other Snacks Utilities
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
