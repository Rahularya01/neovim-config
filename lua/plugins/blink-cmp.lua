return {
	"saghen/blink.cmp",
	version = "*",
	dependencies = {
		"rafamadriz/friendly-snippets",
		"fang2hou/blink-copilot",
		"zbirenbaum/copilot.lua",
	},

	config = function(_, opts)
		require("blink.cmp").setup(opts)
	end,

	opts = {
		keymap = {
			preset = "super-tab",
			["<Tab>"] = {
				function(cmp)
					if cmp.is_menu_visible() then
						return cmp.select_and_accept()
					end
				end,
				function()
					local suggestion = require("copilot.suggestion")

					if suggestion.is_visible() then
						suggestion.accept()
						return true
					end
				end,
				function(cmp)
					if cmp.snippet_active() then
						return cmp.accept()
					end

					return cmp.select_and_accept()
				end,
				"snippet_forward",
				"fallback",
			},
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
			ghost_text = { enabled = false },
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
				auto_show = true,
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
			default = { "copilot", "lsp", "path", "snippets", "buffer" },
			per_filetype = {
				terminal = { "path", "snippets", "buffer" },
			},
			providers = {
				copilot = {
					name = "copilot",
					module = "blink-copilot",
					score_offset = 100,
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
