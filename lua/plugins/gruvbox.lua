return {
	"ellisonleao/gruvbox.nvim",
	priority = 1000,
	config = function()
		require("gruvbox").setup({
			contrast = "hard",
			transparent_mode = true,
			overrides = {
				Pmenu = { bg = "NONE" },
				PmenuSel = { bg = "#504945", fg = "NONE" },
				PmenuSbar = { bg = "NONE" },
				PmenuThumb = { bg = "NONE" },
				NormalFloat = { bg = "NONE" },
				FloatBorder = { bg = "NONE", fg = "#504945" },
				["@tag"] = { fg = "#83a598" },
				["@tag.builtin"] = { fg = "#83a598" },
				["@tag.attribute"] = { fg = "#fabd2f" },
				["@tag.delimiter"] = { fg = "#83a598" },
				SignColumn = { bg = "NONE" },
			},
		})
		vim.cmd("colorscheme gruvbox")
	end,
}
