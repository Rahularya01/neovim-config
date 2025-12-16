return {
	"yetone/avante.nvim",
	cmd = { "AvanteAsk", "AvanteChat", "AvanteToggle" },
	keys = {
		{ "<leader>aa", "<cmd>AvanteAsk<cr>", desc = "Avante Ask" },
		{ "<leader>at", "<cmd>AvanteToggle<cr>", desc = "Avante Toggle" },
		{ "<leader>ac", "<cmd>AvanteChat<cr>", desc = "Avante Chat" },
	},
	version = false,
	build = "make",

	opts = {
		provider = "copilot",
		auto_suggestions_provider = "copilot",

		providers = {
			copilot = {
				model = "grok-code-fast-1",
			},
		},

		windows = {
			width = 26,
			sidebar_header = {
				enabled = true,
				align = "center",
				rounded = true,
			},
			input = {
				prefix = "> ",
				height = 15,
			},
			edit = {
				border = "rounded",
				start_insert = true,
			},
		},

		highlights = {
			diff = {
				current = "DiffText",
				incoming = "DiffAdd",
			},
		},
	},

	dependencies = {
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
		"zbirenbaum/copilot.lua",
		"HakonHarnes/img-clip.nvim",
		{
			"MeanderingProgrammer/render-markdown.nvim",
			ft = { "markdown", "Avante" },
			opts = {
				file_types = { "markdown", "Avante" },
			},
		},
	},
}
