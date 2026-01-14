return {
	"kevinhwang91/nvim-ufo",
	dependencies = { "kevinhwang91/promise-async" },
	event = "BufReadPre",
	config = function()
		-- Guard against rare out-of-bounds line requests from ufo's decorator.
		local ok, buffer = pcall(require, "ufo.model.buffer")
		if ok and buffer and buffer.lines then
			local original_lines = buffer.lines
			function buffer:lines(lnum, endLnum)
				local line_count = self:lineCount()
				if line_count == 0 or lnum > line_count then
					return { "" }
				end
				if endLnum and endLnum > line_count then
					endLnum = line_count
				end
				return original_lines(self, lnum, endLnum)
			end
		end

		vim.opt.foldcolumn = "0"
		vim.opt.foldlevel = 99
		vim.opt.foldlevelstart = 99
		vim.opt.foldenable = true

		require("ufo").setup({
			provider_selector = function(bufnr, filetype, buftype)
				if buftype == "nofile" then
					return ""
				end

				return { "lsp", "indent" }
			end,
		})

		vim.keymap.set("n", "zR", require("ufo").openAllFolds)
		vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
	end,
}
