return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").setup({
			install_dir = vim.fn.stdpath("data") .. "/site",
		})

		-- Parser downloads are intentionally manual. Starting an install for every
		-- language on each launch made startup noisy and retried failed downloads.
		-- Run :TSUpdate after plugin updates, or :TSInstall <language> as needed.

		-- Enable treesitter highlighting for all filetypes that have a parser.
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("treesitter_attach", { clear = true }),
			callback = function(ev)
				pcall(vim.treesitter.start, ev.buf)
			end,
		})
	end,
}
