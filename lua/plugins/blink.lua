return {
	"saghen/blink.cmp",
	dependencies = { "rafamadriz/friendly-snippets" }, -- Add this line
	version = "*",
	opts = {
		keymap = {
			preset = "default",
			["<C-k>"] = { "select_prev", "fallback" },
			["<C-j>"] = { "select_next", "fallback" },
			["<CR>"] = { "accept", "fallback" },
		},
		appearance = {
			use_nvim_cmp_as_default = true,
			nerd_font_variant = "mono",
		},
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},
		signature = { enabled = true },
		completion = {
			menu = { border = "rounded" },
			documentation = { window = { border = "rounded" } },
		},
	},
}
