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
					return ""
				end

				return { "lsp", "indent" }
			end,
		})

		vim.keymap.set("n", "zR", require("ufo").openAllFolds)
		vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

		-- Neo-tree manages its own expand/collapse state; keep ufo out of its buffers.
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "neo-tree",
			callback = function(event)
				require("ufo").detach(event.buf)
				vim.opt_local.foldenable = false
			end,
			desc = "Disable ufo for Neo-tree",
		})
	end,
}
