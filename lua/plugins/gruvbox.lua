return {
	"ellisonleao/gruvbox.nvim",
	priority = 1000,
	event = "VimEnter", -- Load after startup to not block
	config = function()
		-- VS Code Gruvbox Dark "Hard" Palette
		-- Source: src/shared.ts from the uploaded extension
		local colors = {
			bg0 = "#1d2021", -- "Hard" background (was #282828)
			bg1 = "#3c3836", -- darker bg
			bg_visual = "#504945", -- selection
			fg = "#ebdbb2", -- default fg

			-- Palette (Bright/2 variants)
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
			-- NOTE: Set this to false if you want the exact #1d2021 background color.
			-- If true, it uses your terminal's background color.
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
				-- UI
				-- Use colors.bg0 if you disable transparency to see the hard contrast
				Normal = { fg = colors.fg, bg = "NONE" },
				SignColumn = { bg = "NONE" },
				Pmenu = { bg = colors.bg1 },
				PmenuSel = { bg = colors.bg_visual, fg = "NONE", bold = true },
				Visual = { bg = colors.bg_visual },
				CursorLine = { bg = colors.bg1 },
				CursorLineNr = { fg = colors.yellow, bold = true },

				-- Syntax (Strict VS Code Port)
				Comment = { fg = colors.gray, italic = true },
				String = { fg = colors.green },
				Character = { fg = colors.green },
				Number = { fg = colors.purple },
				Boolean = { fg = colors.purple },

				Float = { fg = colors.purple },

				-- Keywords & Operators
				-- VS Code uses Red for generic keywords (if, else, return)
				Keyword = { fg = colors.red },
				Conditional = { fg = colors.red },
				Repeat = { fg = colors.red },
				Label = { fg = colors.red },
				Exception = { fg = colors.red },

				-- VS Code uses Aqua for operators (=, +, -) and Orange for 'new'
				Operator = { fg = colors.aqua },
				Statement = { fg = colors.red },

				-- Functions
				-- VS Code uses Aqua for function definitions and calls
				Function = { fg = colors.aqua },
				Identifier = { fg = colors.blue }, -- Variables are Blue in this theme

				-- Types
				Type = { fg = colors.yellow },
				Structure = { fg = colors.yellow },
				StorageClass = { fg = colors.orange }, -- 'const', 'let', 'var' are Orange

				-- Delimiters
				Delimiter = { fg = colors.yellow }, -- Kept your preference (VS Code is usually fg2/beige)
				["@punctuation.bracket"] = { fg = colors.yellow },
				["@punctuation.delimiter"] = { fg = colors.fg },

				-- JSX / HTML
				Tag = { fg = colors.aqua },
				Special = { fg = colors.orange },

				-- Treesitter Specifics
				["@variable"] = { fg = colors.blue }, -- VS Code: blue2
				["@variable.builtin"] = { fg = colors.orange }, -- this
				["@variable.parameter"] = { fg = colors.blue }, -- VS Code: blue2
				["@variable.member"] = { fg = colors.blue },

				["@property"] = { fg = colors.blue }, -- Properties often align with variables

				["@function"] = { fg = colors.aqua },
				["@function.call"] = { fg = colors.aqua },
				["@function.builtin"] = { fg = colors.orange }, -- Builtins often Orange

				["@operator"] = { fg = colors.aqua },
				["@keyword"] = { fg = colors.red }, -- const is storage (orange), but others are red
				["@keyword.function"] = { fg = colors.red },
				["@keyword.operator"] = { fg = colors.aqua },
				["@keyword.import"] = { fg = colors.red },
				["@keyword.return"] = { fg = colors.red },

				-- JSX/TSX
				["@tag"] = { fg = colors.aqua },
				["@tag.attribute"] = { fg = colors.yellow }, -- VS Code: yellow2
				["@tag.delimiter"] = { fg = colors.gray },

				-- LSP Semantic Tokens
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
