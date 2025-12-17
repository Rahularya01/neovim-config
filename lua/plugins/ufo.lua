return {
	"kevinhwang91/nvim-ufo",
	dependencies = { "kevinhwang91/promise-async" },
	event = "BufReadPre",
	config = function()
		vim.opt.foldcolumn = "0"
		vim.opt.foldlevel = 99
		vim.opt.foldlevelstart = 99
		vim.opt.foldenable = true

		require("ufo").setup({
			provider_selector = function(bufnr, filetype, buftype)
				if filetype == "neo-tree" or buftype == "nofile" then
					return nil
				end

				return { "lsp", "indent" }
			end,
		})

		vim.keymap.set("n", "zR", require("ufo").openAllFolds)
		vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
	end,
}
