return {
	"folke/sidekick.nvim",
	event = "VeryLazy",
	opts = {
		cli = {
			mux = {
				backend = "tmux",
				enabled = true,
			},
		},
	},
	keys = {
		{
			"<tab>",
			function()
				if not require("sidekick").nes_jump_or_apply() then
					return "<Tab>"
				end
			end,
			expr = true,
			desc = "Goto/Apply Next Edit Suggestion",
		},
		{
			"<C-.>",
			function()
				require("sidekick.cli").focus()
			end,
			desc = "Sidekick Focus",
			mode = { "n", "t", "i", "x" },
		},
		{
			"<leader>ac",
			function()
				require("sidekick.cli").toggle({ name = "claude", focus = true })
			end,
			desc = "Toggle Claude",
		},
		{
			"<leader>aa",
			function()
				require("sidekick.cli").toggle()
			end,
			desc = "Toggle CLI",
		},
		{
			"<leader>as",
			function()
				require("sidekick.cli").select()
			end,
			desc = "Select CLI",
		},
		{
			"<leader>ad",
			function()
				require("sidekick.cli").close()
			end,
			desc = "Detach CLI Session",
		},
		{
			"go",
			function()
				require("sidekick.cli").send({ msg = "{this}" })
			end,
			mode = { "x", "n" },
			desc = "Send This",
		},

		{
			"<leader>af",
			function()
				require("sidekick.cli").send({ msg = "{file}" })
			end,
			desc = "Send File",
		},
		{
			"<leader>av",
			function()
				require("sidekick.cli").send({ msg = "{selection}" })
			end,
			mode = { "x" },
			desc = "Send Visual Selection",
		},
		{
			"<leader>ap",
			function()
				require("sidekick.cli").prompt()
			end,
			mode = { "n", "x" },
			desc = "Select Prompt",
		},
		{
			"<C-a>",
			function()
				require("sidekick.cli").send({ msg = "{file}", submit = true })
			end,
			desc = "Ask about buffer",
		},
	},
}
