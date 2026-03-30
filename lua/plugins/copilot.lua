return {
	"supermaven-inc/supermaven-nvim",
	event = "BufReadPost",
	opts = {
		keymap = {
			accept = "<Tab>",
			clear = "<C-h>",
			accept_word = "<C-l>",
			accept_line = "<C-j>",
			next = "<C-k>",
			prev = "<C-;>",
		},
	},
}
