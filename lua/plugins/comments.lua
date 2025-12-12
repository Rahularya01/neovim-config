return {
	"numToStr/Comment.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		-- add any custom config here
		padding = true,
		sticky = true,
		ignore = nil,
		mappings = {
			basic = true,
			extra = true,
		},
	},
}
