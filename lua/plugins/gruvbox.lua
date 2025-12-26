return {
	"ellisonleao/gruvbox.nvim",
	priority = 1000,
	lazy = false,
	config = function()
		local colors = {
			bg0 = "#282828",
			bg1 = "#3c3836",
			bg2 = "#504945",
			fg = "#ebdbb2",
		}

		require("gruvbox").setup({
			contrast = "hard",
			transparent_mode = true,

			italic = {
				strings = false,
				emphasis = true,
				comments = true,
				operators = false,
				folds = true,
			},
			bold = true,

			overrides = {
				Pmenu = { bg = colors.bg0 },
				PmenuSel = { bg = colors.bg2, fg = "NONE", bold = true },

				NormalFloat = { bg = "NONE" },
				FloatBorder = { bg = "NONE", fg = colors.bg2 },

				SignColumn = { bg = "NONE" },
				FoldColumn = { bg = "NONE" },

				AvanteTitle = { bg = "NONE", fg = colors.fg },
				AvanteReversedTitle = { bg = "NONE", fg = colors.fg },
				AvanteSubtitle = { bg = "NONE", fg = colors.fg },
				AvanteReversedSubtitle = { bg = "NONE", fg = colors.fg },
				AvanteThirdTitle = { bg = "NONE", fg = colors.fg },
				AvanteReversedThirdTitle = { bg = "NONE", fg = colors.fg },

				TelescopeNormal = { bg = "NONE" },
				TelescopeBorder = { bg = "NONE", fg = colors.bg2 },
			},
		})

		vim.cmd("colorscheme gruvbox")
	end,
}
