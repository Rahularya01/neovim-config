return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	config = function()
		-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
		-- 1) nvim-notify: better-looking popups
		-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
		local has_notify, notify = pcall(require, "notify")
		if has_notify then
			notify.setup({
				-- semi-transparent background to blend with your theme
				background_colour = "#1e222a",
				-- compact render gives a tidier look
				render = "compact",
				-- fade in/out
				stages = "fade_in_slide_out",
				-- show newest at bottom
				top_down = false,
				-- add a subtle border
				on_open = function(win)
					vim.api.nvim_win_set_config(win, { border = "rounded" })
				end,
			})
			vim.notify = notify
		end

		-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
		-- 2) noice.nvim core config
		-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
		local has_noice, noice = pcall(require, "noice")
		if not has_noice then
			return
		end

		noice.setup({
			-- stylize LSP hover & signature help in a nice popup
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
				hover = {
					enabled = true, -- enable hover popup
					silent = false, -- don't silence errors
					view = "hover", -- use builtin hover
				},
				signature = {
					enabled = true,
					view = "hover", -- show signature in hover style
					timer = 1000, -- delay before showing
				},
			},

			-- presets give quick toggles for common UI tweaks
			presets = {
				bottom_search = true, -- move / search to bottom
				command_palette = true, -- nicer : commands
				long_message_to_split = true, -- long messages go to a split
				inc_rename = true, -- live-rename middleware
				lsp_doc_border = true, -- add border around LSP docs
			},

			-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
			-- 3) routes: style particular messages
			-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
			routes = {
				{
					-- style git commit messages as info
					view = "notify",
					filter = { event = "msg_show", kind = "", find = "written" },
				},
				{
					-- make error messages really stand out
					view = "popup",
					filter = { event = "msg_show", kind = "error" },
				},
			},

			-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
			-- 4) views: customize each UI component
			-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
			views = {
				popup = {
					border = { style = "rounded", text = { top = " Noice ❯" } },
					win_options = { winblend = 5 },
				},
				cmdline_popup = {
					position = { row = "50%", col = "50%" },
					size = { width = 60, height = "auto" },
					border = { style = "rounded", padding = { 1, 2 } },
					win_options = { winblend = 10 },
				},
				cmdline = {
					view = "cmdline_popup",
					format = {
						cmdline = { icon = "➜", lang = "bash" },
						search_down = { icon = " ", lang = "regex" },
						search_up = { icon = " ", lang = "regex" },
					},
				},
			},
		})

		-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
		-- 5) handy keymaps
		-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
		local opts = { silent = true, nowait = true }
		vim.keymap.set("n", "<leader>sn", function()
			require("noice").cmd("last")
		end, opts)
		vim.keymap.set("n", "<leader>sh", function()
			require("noice").cmd("history")
		end, opts)
		vim.keymap.set("n", "<leader>sl", function()
			require("noice").cmd("launcher")
		end, opts)
	end,
}
