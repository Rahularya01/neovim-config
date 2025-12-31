return {
	"akinsho/bufferline.nvim",
	event = "VeryLazy",
	dependencies = {
		"moll/vim-bbye",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local bufferline = require("bufferline")

		-- Gruvbox color palette
		local colors = {
			bg = "#282828",
			fg = "#ebdbb2",
			bg0 = "#1d2021",
			bg1 = "#3c3836",
			bg2 = "#504945",
			bg3 = "#665c54",
			fg0 = "#fbf1c7",
			fg1 = "#ebdbb2",
			fg2 = "#d5c4a1",
			fg3 = "#bdae93",
			red = "#fb4934",
			green = "#b8bb26",
			yellow = "#fabd2f",
			blue = "#83a598",
			purple = "#d3869b",
			aqua = "#8ec07c",
			orange = "#fe8019",
			gray = "#928374",
		}

		bufferline.setup({
			options = {
				offsets = {
					{
						filetype = "neo-tree",
						text = "File Explorer",
						text_align = "center",
						highlight = "Directory",
						separator = true,
					},
				},
				mode = "buffers",
				themable = true,
				numbers = "none",
				close_command = "Bdelete! %d",
				buffer_close_icon = "✗",
				close_icon = "✗",
				modified_icon = "●",
				left_trunc_marker = "",
				right_trunc_marker = "",
				max_name_length = 30,
				max_prefix_length = 30,
				tab_size = 21,
				diagnostics = "nvim_lsp",
				diagnostics_indicator = function(count, level)
					local icon = level:match("error") and "" or (level:match("warn") and "" or "")
					return " " .. icon .. " " .. count
				end,
				color_icons = true,
				show_buffer_icons = true,
				show_buffer_close_icons = true,
				show_close_icon = true,
				persist_buffer_sort = true,
				separator_style = "thick",
				enforce_regular_tabs = true,
				always_show_bufferline = true,
				show_tab_indicators = true,
				indicator = {
					icon = "▎",
					style = "icon",
				},
				icon_pinned = "󰐃",
				minimum_padding = 1,
				maximum_padding = 5,
				maximum_length = 15,
				sort_by = "insert_at_end",
			},
			highlights = {
				fill = {
					bg = colors.bg0,
				},
				background = {
					fg = colors.fg3,
					bg = colors.bg1,
				},
				buffer_visible = {
					fg = colors.fg2,
					bg = colors.bg1,
				},
				buffer_selected = {
					fg = colors.fg0,
					bg = colors.bg,
					bold = true,
					italic = false,
				},
				close_button = {
					fg = colors.fg3,
					bg = colors.bg1,
				},
				close_button_visible = {
					fg = colors.fg2,
					bg = colors.bg1,
				},
				close_button_selected = {
					fg = colors.red,
					bg = colors.bg,
				},
				modified = {
					fg = colors.yellow,
					bg = colors.bg1,
				},
				modified_visible = {
					fg = colors.yellow,
					bg = colors.bg1,
				},
				modified_selected = {
					fg = colors.green,
					bg = colors.bg,
				},
				separator = {
					fg = colors.bg0,
					bg = colors.bg1,
				},
				separator_visible = {
					fg = colors.bg0,
					bg = colors.bg1,
				},
				separator_selected = {
					fg = colors.bg0,
					bg = colors.bg,
				},
				indicator_selected = {
					fg = colors.orange,
					bg = colors.bg,
				},
				pick = {
					fg = colors.red,
					bg = colors.bg1,
					bold = true,
				},
				pick_selected = {
					fg = colors.red,
					bg = colors.bg,
					bold = true,
				},
				pick_visible = {
					fg = colors.red,
					bg = colors.bg1,
					bold = true,
				},
				diagnostic = {
					fg = colors.fg3,
					bg = colors.bg1,
				},
				diagnostic_visible = {
					fg = colors.fg2,
					bg = colors.bg1,
				},
				diagnostic_selected = {
					fg = colors.fg1,
					bg = colors.bg,
				},
				error = {
					fg = colors.red,
					bg = colors.bg1,
				},
				error_visible = {
					fg = colors.red,
					bg = colors.bg1,
				},
				error_selected = {
					fg = colors.red,
					bg = colors.bg,
				},
				error_diagnostic = {
					fg = colors.red,
					bg = colors.bg1,
				},
				error_diagnostic_visible = {
					fg = colors.red,
					bg = colors.bg1,
				},
				error_diagnostic_selected = {
					fg = colors.red,
					bg = colors.bg,
				},
				warning = {
					fg = colors.yellow,
					bg = colors.bg1,
				},
				warning_visible = {
					fg = colors.yellow,
					bg = colors.bg1,
				},
				warning_selected = {
					fg = colors.yellow,
					bg = colors.bg,
				},
				warning_diagnostic = {
					fg = colors.yellow,
					bg = colors.bg1,
				},
				warning_diagnostic_visible = {
					fg = colors.yellow,
					bg = colors.bg1,
				},
				warning_diagnostic_selected = {
					fg = colors.yellow,
					bg = colors.bg,
				},
				info = {
					fg = colors.blue,
					bg = colors.bg1,
				},
				info_visible = {
					fg = colors.blue,
					bg = colors.bg1,
				},
				info_selected = {
					fg = colors.blue,
					bg = colors.bg,
				},
				info_diagnostic = {
					fg = colors.blue,
					bg = colors.bg1,
				},
				info_diagnostic_visible = {
					fg = colors.blue,
					bg = colors.bg1,
				},
				info_diagnostic_selected = {
					fg = colors.blue,
					bg = colors.bg,
				},
				hint = {
					fg = colors.aqua,
					bg = colors.bg1,
				},
				hint_visible = {
					fg = colors.aqua,
					bg = colors.bg1,
				},
				hint_selected = {
					fg = colors.aqua,
					bg = colors.bg,
				},
				hint_diagnostic = {
					fg = colors.aqua,
					bg = colors.bg1,
				},
				hint_diagnostic_visible = {
					fg = colors.aqua,
					bg = colors.bg1,
				},
				hint_diagnostic_selected = {
					fg = colors.aqua,
					bg = colors.bg,
				},
				duplicate = {
					fg = colors.gray,
					bg = colors.bg1,
				},
				duplicate_visible = {
					fg = colors.gray,
					bg = colors.bg1,
				},
				duplicate_selected = {
					fg = colors.gray,
					bg = colors.bg,
				},
				tab = {
					fg = colors.fg3,
					bg = colors.bg1,
				},
				tab_selected = {
					fg = colors.fg0,
					bg = colors.bg,
				},
				tab_close = {
					fg = colors.red,
					bg = colors.bg0,
				},
			},
		})

		-- Keymaps for buffer navigation and closing can be defined here if needed
		local opts = { noremap = true, silent = true }
	end,
}
