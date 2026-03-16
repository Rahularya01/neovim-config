return {
	"saghen/blink.cmp",
	version = "*",
	dependencies = {
		"rafamadriz/friendly-snippets",
		{
			"Exafunction/windsurf.nvim",
			dependencies = { "nvim-lua/plenary.nvim" },
			config = function()
				require("codeium").setup({
					enable_cmp_source = false,
					virtual_text = {
						enabled = false,
					},
				})
			end,
		},
	},
	opts = {

		keymap = {
			preset = "super-tab",
			["<C-k>"] = { "select_prev", "fallback" },
			["<C-j>"] = { "select_next", "fallback" },
			["<CR>"] = { "accept", "fallback" },
			["<C-space>"] = { "show", "fallback" },
			["<C-e>"] = { "cancel", "fallback" },
		},
		appearance = {
			nerd_font_variant = "mono",
		},
		completion = {
			trigger = {
				show_on_keyword = true,
				show_on_trigger_character = true,
			},
			ghost_text = { enabled = true },
			list = {
				selection = { preselect = true, auto_insert = false },
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
				window = {
					border = "single",
					winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
				},
			},
			menu = {
				border = "single",
				winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
				draw = {
					columns = {
						{ "kind_icon", width = { fixed = 2 } },
						{ "label", "label_description", gap = 1 },
						{ "kind" },
					},
				},
			},
		},
		signature = {
			enabled = true,
			window = { border = "single" },
		},
		sources = {
			default = { "lsp", "path", "snippets", "buffer", "codeium" },
			per_filetype = {
				markdown = { "path", "snippets", "buffer", "codeium" },
			},
			providers = {
				codeium = {
					name = "Codeium",
					module = "codeium.blink",
					async = true,
				},
			},
		},
		fuzzy = {
			implementation = "prefer_rust",
			prebuilt_binaries = {
				force_version = "v1.9.1",
			},
		},
	},
	opts_extend = { "sources.default" },
}
