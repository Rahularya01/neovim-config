return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	config = true, -- This automatically runs require('nvim-autopairs').setup({})
	opts = {
		fast_wrap = {},

		disable_filetype = { "TelescopePrompt", "vim" },
	},
}
