return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		bigfile = { enabled = true },
		input = { enabled = true },
		picker = {
			enabled = true,
			sources = {
				gh_issue = {},
				gh_pr = {},
			},
		},
		dashboard = { enabled = true },
		terminal = { enabled = true },
		notifier = { enabled = true },
		indent = { enabled = true },
		lazygit = { enabled = true },
		gh = {
			enabled = true,
		},
		image = {
			enabled = true,
			doc = {
				enabled = false,
				max_width = 30,
				max_height = 15,
			},
		},
	},

	keys = {
		{
			"<leader>gi",
			function()
				Snacks.picker.gh_issue()
			end,
			desc = "GitHub Issues (open)",
		},
		{
			"<leader>gI",
			function()
				Snacks.picker.gh_issue({ state = "all" })
			end,
			desc = "GitHub Issues (all)",
		},
		{
			"<leader>gp",
			function()
				Snacks.picker.gh_pr()
			end,
			desc = "GitHub Pull Requests (open)",
		},
		{
			"<leader>gP",
			function()
				Snacks.picker.gh_pr({ state = "all" })
			end,
			desc = "GitHub Pull Requests (all)",
		},
		-- Image hover
		{
			"<S-j>",
			function()
				Snacks.image.hover()
			end,
			mode = { "n", "v" },
			desc = "Image Hover",
		},
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
