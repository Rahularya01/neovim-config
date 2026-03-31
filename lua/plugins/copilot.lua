return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		build = ":Copilot auth",
		event = { "BufReadPost", "BufNewFile" },
		config = function(_, opts)
			require("copilot").setup(opts)
		end,
		opts = {
			suggestion = {
				enabled = true,
				auto_trigger = true,
				hide_during_completion = false,
				keymap = {
					accept = false,
					next = "<M-]>",
					prev = "<M-[>",
				},
			},
			panel = { enabled = false },
		},
	},
}
