return {
	"saghen/blink.cmp",
	dependencies = { "rafamadriz/friendly-snippets" },
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
			menu = {
				border = "rounded",
				draw = {
					-- We add "label_description" here to show the import source
					columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "source_name" } },
				},
			},
			documentation = { window = { border = "rounded" } },
		},
	},
}
