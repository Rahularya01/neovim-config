return {
	"akinsho/git-conflict.nvim",
	version = "*",
	lazy = false,
	config = function()
		require("git-conflict").setup({
			default_mappings = true, -- Ensure default mappings are enabled
			disable_diagnostics = false,
			list_opener = "copen",
		})
	end,
}
