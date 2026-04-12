return {
	"norcalli/nvim-colorizer.lua",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("colorizer").setup({
			"*", 
			css = { rgb_fn = true },
			html = { names = false },
		})
	end,
}
