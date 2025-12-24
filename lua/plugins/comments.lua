return {
	"numToStr/Comment.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
	config = function()
		local comment = require("Comment")
		local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")

		comment.setup({
			-- for commenting tsx, jsx, svelte, html files
			pre_hook = ts_context_commentstring.create_pre_hook(),
			padding = true,
			sticky = true,
			ignore = nil,
			mappings = {
				basic = true,
				extra = true,
			},
		})

		-- OPTIONAL: Map 'gc' in visual mode to do blockwise comment (same as 'gb')
		-- This forces the block style you want when you press 'gc' on selected text
		vim.keymap.set(
			"x",
			"gc",
			"<Plug>(comment_toggle_blockwise_visual)",
			{ desc = "Comment toggle blockwise (visual)" }
		)
	end,
}
