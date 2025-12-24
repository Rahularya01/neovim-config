return {
	"norcalli/nvim-colorizer.lua",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("colorizer").setup({
			"*", -- Highlight all files, but customize some others.
			css = { rgb_fn = true },
			html = { names = false },
		})
	end,
}
