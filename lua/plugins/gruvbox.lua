return {
	"ellisonleao/gruvbox.nvim",
	priority = 1000,
	config = function()
		require("gruvbox").setup({
			contrast = "hard",
			transparent_mode = true,
			overrides = {
				Pmenu = { bg = "NONE" },
				PmenuSel = { bg = "#504945", fg = "NONE" }, -- Selection color (Dark Grey)
				PmenuSbar = { bg = "NONE" },
				PmenuThumb = { bg = "NONE" },

				NormalFloat = { bg = "NONE" },
				FloatBorder = { bg = "NONE", fg = "#d65d0e" }, -- Orange border

				BlinkCmpMenu = { bg = "NONE" },
				BlinkCmpDoc = { bg = "NONE" },
			},
		})
		vim.cmd("colorscheme gruvbox")
	end,
}
