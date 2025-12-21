return {
	"ellisonleao/gruvbox.nvim",
	priority = 1000,
	config = function()
		require("gruvbox").setup({
			contrast = "hard",
			transparent_mode = true,
			overrides = {
				Pmenu = { bg = "#282828" }, -- Solid background for popup menu
				PmenuSel = { bg = "#504945", fg = "NONE" },
				NormalFloat = { bg = "NONE" }, -- Transparent floats
				FloatBorder = { bg = "NONE", fg = "#504945" }, -- Transparent borders
				SignColumn = { bg = "NONE" },
				-- Avante-specific transparency
				AvanteTitle = { bg = "NONE" },
				AvanteReversedTitle = { bg = "NONE" },
				AvanteSubtitle = { bg = "NONE" },
				AvanteReversedSubtitle = { bg = "NONE" },
				AvanteThirdTitle = { bg = "NONE" },
				AvanteReversedThirdTitle = { bg = "NONE" },
			},
		})
		vim.cmd("colorscheme gruvbox")
	end,
}
