return {
	"ellisonleao/gruvbox.nvim",
	priority = 1000,
	lazy = false, -- Make sure we load this during startup if it is your main colorscheme
	config = function()
		-- Define Gruvbox palette colors for cleaner overrides
		local colors = {
			bg0 = "#282828", -- Hard dark background
			bg1 = "#3c3836", -- Lighter background
			bg2 = "#504945", -- Selection/Border
			fg = "#ebdbb2", -- Foreground
		}

		require("gruvbox").setup({
			contrast = "hard",
			transparent_mode = true,

			-- Improve typography
			italic = {
				strings = false,
				emphasis = true,
				comments = true,
				operators = false,
				folds = true,
			},
			bold = true,

			overrides = {
				-- 1. UI & Popups
				-- Keep Pmenu solid for readability over code, but use theme colors
				Pmenu = { bg = colors.bg0 },
				PmenuSel = { bg = colors.bg2, fg = "NONE", bold = true },

				-- 2. Floating Windows & Borders
				NormalFloat = { bg = "NONE" },
				FloatBorder = { bg = "NONE", fg = colors.bg2 },

				-- 3. Core Editor transparency
				SignColumn = { bg = "NONE" },
				FoldColumn = { bg = "NONE" },

				-- 4. Avante.nvim (AI) Specifics
				-- Using a loop here would be cleaner, but explicit is fine for overrides
				AvanteTitle = { bg = "NONE", fg = colors.fg },
				AvanteReversedTitle = { bg = "NONE", fg = colors.fg },
				AvanteSubtitle = { bg = "NONE", fg = colors.fg },
				AvanteReversedSubtitle = { bg = "NONE", fg = colors.fg },
				AvanteThirdTitle = { bg = "NONE", fg = colors.fg },
				AvanteReversedThirdTitle = { bg = "NONE", fg = colors.fg },

				-- 5. Optional: Telescope transparency (if you use Telescope)
				TelescopeNormal = { bg = "NONE" },
				TelescopeBorder = { bg = "NONE", fg = colors.bg2 },
			},
		})

		vim.cmd("colorscheme gruvbox")
	end,
}
