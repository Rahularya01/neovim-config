return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		-- 1. Helper: Better Macro Recording (with refresh logic)
		local function show_macro_recording()
			local recording_register = vim.fn.reg_recording()
			if recording_register == "" then
				return ""
			end
			return "● Recording @" .. recording_register
		end

		-- Force lualine to refresh when recording macros

		vim.api.nvim_create_autocmd("RecordingEnter", {
			callback = function()
				require("lualine").refresh({ place = { "statusline" } })
			end,
		})
		vim.api.nvim_create_autocmd("RecordingLeave", {
			callback = function()
				local timer = vim.loop.new_timer()
				timer:start(
					50,
					0,
					vim.schedule_wrap(function()
						require("lualine").refresh({ place = { "statusline" } })
					end)
				)
			end,
		})

		-- 2. Helper: Conditional width
		local hide_in_width = function()
			return vim.fn.winwidth(0) > 80
		end

		require("lualine").setup({
			options = {
				theme = "gruvbox",
				-- Using subtle rounded or slant separators looks more "modern"
				-- Use { left = '', right = '' } for bubbles
				section_separators = { left = "", right = "" },
				component_separators = { left = "", right = "" },
				globalstatus = true,
				disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
			},
			extensions = { "trouble" },
			sections = {
				lualine_a = { { "mode", separator = { left = " " }, right_padding = 2 } },
				lualine_b = {
					{ "branch", icon = "" },
					{ "diff", symbols = { added = " ", modified = " ", removed = " " } },
				},
				lualine_c = {
					{ "filename", file_status = true, path = 1 }, -- path = 1 shows relative path
				},
				lualine_x = {
					{
						show_macro_recording,
						color = { fg = "#ff9e64", gui = "bold" },
					},
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						symbols = { error = " ", warn = " ", info = " ", hint = "󰛩 " },
					},
					{ "filetype", cond = hide_in_width },
				},
				lualine_y = { "progress" },
				lualine_z = {
					{ "location", separator = { right = " " }, left_padding = 2 },
					{
						require("opencode").statusline,
					},
				},
			},
			inactive_sections = {
				lualine_c = { { "filename", path = 1 } },
				lualine_x = { "location" },
			},
		})
	end,
}
