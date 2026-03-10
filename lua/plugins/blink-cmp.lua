return {
	"saghen/blink.cmp",
	dependencies = { "rafamadriz/friendly-snippets" },
	version = "1.*",

	opts = {
		keymap = {
			preset = "default",

			-- Mirror nvim-cmp mappings
			["<C-k>"] = { "select_prev", "fallback" },
			["<C-j>"] = { "select_next", "fallback" },
			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },
			["<CR>"] = { "accept", "fallback" },
			["<C-e>"] = { "hide", "fallback" },
			["<C-space>"] = { "show", "show_documentation", "hide_documentation" },

			-- Snippet jumps
			["<C-l>"] = { "snippet_forward", "fallback" },
			["<C-h>"] = { "snippet_backward", "fallback" },
			["<S-Tab>"] = { "snippet_backward", "fallback" },
		},

		appearance = {
			nerd_font_variant = "mono",
		},

		completion = {
			documentation = {
				auto_show = false,
				window = {
					border = "rounded",
					winblend = 05,
					winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine",
				},
			},

			menu = {
				border = "rounded",
				winblend = 15,
				winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection",
				draw = {
					columns = {
						{ "label", "label_description", gap = 1 },
						{ "kind_icon", "kind", gap = 1 },
						{ "source_name" },
					},
				},
			},

			ghost_text = { enabled = true },
		},

		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},

		-- removes the rust binary warning fallback noise
		fuzzy = { implementation = "lua" },
	},

	opts_extend = { "sources.default" },

	config = function(_, opts)
		require("blink.cmp").setup(opts)

		-- Optional: make generic floating windows transparent too
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
		vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE" })

		-- Blink menu
		vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = "NONE", fg = "#ebdbb2" })
		vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { bg = "NONE", fg = "#928374" })
		vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { bg = "#504945", bold = true })

		-- Blink documentation
		vim.api.nvim_set_hl(0, "BlinkCmpDoc", { bg = "NONE", fg = "#ebdbb2" })
		vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { bg = "NONE", fg = "#928374" })
		vim.api.nvim_set_hl(0, "BlinkCmpDocCursorLine", { bg = "#504945" })

		-- Labels
		vim.api.nvim_set_hl(0, "BlinkCmpLabel", { fg = "#ebdbb2", bg = "NONE" })
		vim.api.nvim_set_hl(0, "BlinkCmpLabelMatch", { fg = "#fabd2f", bg = "NONE", bold = true })
		vim.api.nvim_set_hl(0, "BlinkCmpLabelDetail", { fg = "#928374", bg = "NONE" })
		vim.api.nvim_set_hl(0, "BlinkCmpLabelDescription", { fg = "#928374", bg = "NONE" })
		vim.api.nvim_set_hl(0, "BlinkCmpLabelDeprecated", { fg = "#928374", bg = "NONE", strikethrough = true })

		-- Source names
		vim.api.nvim_set_hl(0, "BlinkCmpSource", { fg = "#928374", bg = "NONE" })

		-- Ghost text
		vim.api.nvim_set_hl(0, "BlinkCmpGhostText", { link = "Comment" })

		-- Kind colors
		local kind_colors = {
			Text = "#ebdbb2",
			Method = "#8ec07c",
			Function = "#8ec07c",
			Constructor = "#8ec07c",
			Field = "#83a598",
			Variable = "#83a598",
			Class = "#fabd2f",
			Interface = "#fabd2f",
			Module = "#fabd2f",
			Property = "#83a598",
			Unit = "#d3869b",
			Value = "#d3869b",
			Enum = "#fabd2f",
			Keyword = "#fb4934",
			Snippet = "#fe8019",
			Color = "#fe8019",
			File = "#ebdbb2",
			Reference = "#83a598",
			Folder = "#fabd2f",
			EnumMember = "#83a598",
			Constant = "#d3869b",
			Struct = "#fabd2f",
			Event = "#fe8019",
			Operator = "#8ec07c",
			TypeParameter = "#fabd2f",
		}

		for kind, fg in pairs(kind_colors) do
			vim.api.nvim_set_hl(0, "BlinkCmpKind" .. kind, { fg = fg, bg = "NONE" })
		end

		vim.api.nvim_set_hl(0, "BlinkCmpKind", { fg = "#928374", bg = "NONE" })
	end,
}
