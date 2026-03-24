vim.g.ai_cmp = true

return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		build = ":Copilot auth",
		event = "BufReadPost",
		config = function(_, opts)
			require("copilot").setup(opts)

			local group = vim.api.nvim_create_augroup("CopilotBlinkIntegration", { clear = true })

			vim.api.nvim_create_autocmd("User", {
				group = group,
				pattern = "BlinkCmpMenuOpen",
				callback = function()
					vim.b.copilot_suggestion_hidden = true
				end,
			})

			vim.api.nvim_create_autocmd("User", {
				group = group,
				pattern = "BlinkCmpMenuClose",
				callback = function()
					vim.b.copilot_suggestion_hidden = false
				end,
			})
		end,
		opts = {
			suggestion = {
				enabled = true,
				auto_trigger = true,
				hide_during_completion = true,
				keymap = {
					accept = false,
					next = "<M-]>",
					prev = "<M-[>",
				},
			},
			panel = { enabled = false },
			filetypes = {
				markdown = true,
				help = true,
			},
		},
	},
}
