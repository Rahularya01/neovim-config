return {
	"nvim-lualine/lualine.nvim",
	config = function()
		-- Custom mode component with leading space
		local mode = {
			"mode",
			fmt = function(str)
				return " " .. str
			end,
		}

		-- Filename component with file status and relative path
		local filename = {
			"filename",
			file_status = true,
			path = 0,
		}

		-- Helper function to hide components when window is too narrow
		local hide_in_width = function()
			return vim.fn.winwidth(0) > 100
		end

		-- Diagnostics component for LSP errors and warnings
		local diagnostics = {
			"diagnostics",
			sources = { "nvim_diagnostic" },
			sections = { "error", "warn" },
			symbols = { error = " ", warn = " ", info = " ", hint = " " },
			colored = false,
			update_in_insert = false,
			always_visible = false,
			cond = hide_in_width,
		}

		-- Git diff component showing added/modified/removed lines
		local diff = {
			"diff",
			colored = false,
			symbols = { added = " ", modified = " ", removed = " " },
			cond = hide_in_width,
		}

		-- Main lualine setup
		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "gruvbox",
				section_separators = { left = "", right = "" },
				component_separators = { left = "", right = "" },
				always_divide_middle = false,
				globalstatus = true,
			},
			sections = {
				lualine_a = { mode },
				lualine_b = { "branch" },
				lualine_c = { filename },
				lualine_x = {
					diagnostics,
					diff,
					{ "encoding", cond = hide_in_width },
					{ "filetype", cond = hide_in_width },
				},
				lualine_y = { "location" },
				lualine_z = { "progress" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { { "filename", path = 1 } },
				lualine_x = { { "location", padding = 0 } },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			extensions = { "fugitive" },
		})
	end,
}
