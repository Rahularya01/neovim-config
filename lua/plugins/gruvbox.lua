return {
	"ellisonleao/gruvbox.nvim",
	priority = 1000,
	event = "VimEnter",
	config = function()
		local colors = {
			bg0 = "#1d2021",
			bg1 = "#3c3836",
			bg_visual = "#504945",
			fg = "#ebdbb2",

			red = "#fb4934",
			green = "#b8bb26",
			yellow = "#fabd2f",
			blue = "#83a598",
			purple = "#d3869b",
			aqua = "#8ec07c",
			orange = "#fe8019",
			gray = "#928374",
		}

		require("gruvbox").setup({
			contrast = "hard",
			transparent_mode = true,
			bold = false,
			italic = {
				strings = false,
				emphasis = true,
				comments = true,
				operators = false,
				folds = true,
			},

			overrides = {
				Normal = { fg = colors.fg, bg = "NONE" },
				SignColumn = { bg = "NONE" },
				Pmenu = { bg = colors.bg1 },
				PmenuSel = { bg = colors.bg_visual, fg = "NONE", bold = true },
				Visual = { bg = colors.bg_visual },
				CursorLine = { bg = colors.bg1 },
				CursorLineNr = { fg = colors.yellow, bold = true },

				Comment = { fg = colors.gray, italic = true },
				String = { fg = colors.green },
				Character = { fg = colors.green },
				Number = { fg = colors.purple },
				Boolean = { fg = colors.purple },

				Float = { fg = colors.purple },

				Keyword = { fg = colors.red },
				Conditional = { fg = colors.red },
				Repeat = { fg = colors.red },
				Label = { fg = colors.red },
				Exception = { fg = colors.red },

				Operator = { fg = colors.aqua },
				Statement = { fg = colors.red },

				Function = { fg = colors.aqua },
				Identifier = { fg = colors.blue },

				Type = { fg = colors.yellow },
				Structure = { fg = colors.yellow },
				StorageClass = { fg = colors.orange },

				Delimiter = { fg = colors.yellow },
				["@punctuation.bracket"] = { fg = colors.yellow },
				["@punctuation.delimiter"] = { fg = colors.fg },

				Tag = { fg = colors.aqua },
				Special = { fg = colors.orange },

				["@variable"] = { fg = colors.blue },
				["@variable.builtin"] = { fg = colors.orange },
				["@variable.parameter"] = { fg = colors.blue },
				["@variable.member"] = { fg = colors.blue },

				["@property"] = { fg = colors.blue },

				["@function"] = { fg = colors.aqua },
				["@function.call"] = { fg = colors.aqua },
				["@function.builtin"] = { fg = colors.orange },

				["@operator"] = { fg = colors.aqua },
				["@keyword"] = { fg = colors.red },
				["@keyword.function"] = { fg = colors.red },
				["@keyword.operator"] = { fg = colors.aqua },
				["@keyword.import"] = { fg = colors.red },
				["@keyword.return"] = { fg = colors.red },

				["@tag"] = { fg = colors.aqua },
				["@tag.attribute"] = { fg = colors.yellow },
				["@tag.delimiter"] = { fg = colors.gray },

				["@lsp.type.class"] = { fg = colors.yellow },
				["@lsp.type.enum"] = { fg = colors.yellow },
				["@lsp.type.enumMember"] = { fg = colors.blue },
				["@lsp.type.interface"] = { fg = colors.yellow },
				["@lsp.type.type"] = { fg = colors.yellow },
				["@lsp.type.property"] = { fg = colors.blue },
				["@lsp.type.variable"] = { fg = colors.blue },
				["@lsp.type.parameter"] = { fg = colors.blue },
			},
		})

		vim.cmd("colorscheme gruvbox")
	end,
}

