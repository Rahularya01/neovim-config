return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = {
					enabled = true,
					auto_trigger = true,
					debounce = 75,
					keymap = {
						accept = "<Tab>",
						accept_word = false,
						accept_line = false,
						next = "<M-]>",
						prev = "<M-[>",
						dismiss = "<C-]>",
					},
				},
				panel = { enabled = false },
			})
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "main",
		dependencies = {
			{ "zbirenbaum/copilot.lua" },
			{ "nvim-lua/plenary.nvim" },
		},
		build = "make tiktoken",
		opts = {
			show_help = true,
			window = {
				layout = "vertical",
				width = 0.4,
				height = 0.99,
				border = "rounded",
			},
		},
		keys = {
			{
				"<leader>ac",
				function()
					require("CopilotChat").toggle()
				end,
				desc = "Copilot Chat Toggle",
				mode = { "n", "v" },
			},
			{
				"<leader>an",
				function()
					require("CopilotChat").reset()
				end,
				desc = "Copilot Chat New",
				mode = { "n", "v" },
			},
		},
	},
}
