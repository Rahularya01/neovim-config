return {
	"saghen/blink.cmp",
	dependencies = {
		"rafamadriz/friendly-snippets",
	},
	version = "*",
	opts = {
		enabled = function()
			local disabled = { "TelescopePrompt", "neo-tree", "lazy" }
			return not vim.tbl_contains(disabled, vim.bo.filetype)
		end,

		snippets = {
			preset = "default",
		},

		keymap = {
			preset = "default",

			["<C-k>"] = { "select_prev", "fallback" },
			["<C-j>"] = { "select_next", "fallback" },
			["<CR>"] = { "accept", "fallback" },

			["<Tab>"] = { "snippet_forward", "fallback" },
			["<S-Tab>"] = { "snippet_backward", "fallback" },

			["<C-Space>"] = { "show", "show_documentation", "fallback" },
			["<C-e>"] = { "hide", "fallback" },
			["<C-u>"] = { "scroll_documentation_up", "fallback" },
			["<C-d>"] = { "scroll_documentation_down", "fallback" },
		},

		appearance = {
			use_nvim_cmp_as_default = true,
			nerd_font_variant = "mono",
		},

		signature = {
			enabled = true,
			window = {
				border = "rounded",
			},
		},

		sources = {
			default = { "lsp", "path", "snippets", "buffer" },

			providers = {
				lsp = {
					score_offset = 10,
				},
				snippets = {
					score_offset = 7,
				},
				path = {
					score_offset = 3,
				},
				buffer = {
					score_offset = -2,
				},
			},
		},

		completion = {
			accept = {
				auto_brackets = {
					enabled = true,
				},
			},

			trigger = {
				prefetch_on_insert = false,
			},

			menu = {
				border = "rounded",
				draw = {
					treesitter = { "lsp" },

					columns = {
						{ "kind_icon" },
						{ "label", "label_description", gap = 1 },
						{ "source_name" },
					},
				},
			},

			documentation = {
				window = { border = "rounded" },
				auto_show = true,
				auto_show_delay_ms = 200,
			},

			ghost_text = {
				enabled = true,
			},
		},
	},
}
