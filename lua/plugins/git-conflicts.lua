return {
	"akinsho/git-conflict.nvim",
	version = "*",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("git-conflict").setup({
			default_mappings = true,
			list_opener = "copen",
			highlights = {
				incoming = "DiffAdd",

				current = "DiffChange",
				ancestor = "DiffDelete",
			},
		})

		vim.api.nvim_set_hl(0, "GitConflictCurrent", { link = "DiffChange" })
		vim.api.nvim_set_hl(0, "GitConflictIncoming", { link = "DiffAdd" })
	end,
}
