return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)

		wk.add({
			{ "<leader>a", group = "ai/sidekick" },
			{ "<leader>b", group = "buffer" },
			{ "<leader>c", group = "code" },
			{ "<leader>d", group = "debug" },
			{ "<leader>f", group = "find/format" },
			{ "<leader>g", group = "git" },
			{ "<leader>l", group = "lsp" },
			{ "<leader>r", group = "run" },
			{ "<leader>s", group = "search" },
			{ "<leader>t", group = "terminal" },
			{ "<leader>u", group = "ui/toggles" },
			{ "<leader>w", group = "session" },
			{ "<leader>x", group = "diagnostics/trouble" },
			mode = { "n", "v" },
		})
	end,
	opts = {
		plugins = {
			marks = true,
			registers = true,
			spelling = {
				enabled = true,
				suggestions = 20,
			},
			presets = {
				operators = true,
				motions = true,
				text_objects = true,
				windows = true,
				nav = true,
				z = true,
				g = true,
			},
		},
		win = {
			border = "rounded",
			padding = { 2, 2 },
		},
	},
}
