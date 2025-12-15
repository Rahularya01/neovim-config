return {
	"ellisonleao/gruvbox.nvim",
	priority = 1000,
	config = function()
		require("gruvbox").setup({
			contrast = "hard",
			transparent_mode = true, -- Changed to false to match VS Code's solid background
			overrides = {
				-- UI Overrides
				Pmenu = { bg = "#282828" }, -- Solid background for popup menu
				PmenuSel = { bg = "#504945", fg = "NONE" },
				NormalFloat = { bg = "#282828" }, -- Solid background for floats
				FloatBorder = { bg = "#282828", fg = "#504945" },
				SignColumn = { bg = "NONE" },
			},
		})
		vim.cmd("colorscheme gruvbox")
	end,
}
