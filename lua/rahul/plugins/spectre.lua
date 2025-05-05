-- In your Lazy configuration (typically in lua/plugins.lua or similar)
return {
	{
		"nvim-pack/nvim-spectre",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		-- Lazy-load on keymaps
		keys = {
			{ "<leader>S", mode = { "n" }, desc = "Toggle Spectre" },
			{ "<leader>sw", mode = { "n" }, desc = "Search current word" },
			{ "<leader>sv", mode = { "v" }, desc = "Search current selection" },
			{ "<leader>sf", mode = { "n" }, desc = "Search in current file" },
			{ "<leader>sp", mode = { "n" }, desc = "Search word in current file" },
			{ "<leader>sr", mode = { "n" }, desc = "Resume last search" },
		},
		config = function()
			local spectre = require("spectre")
			spectre.setup({
				color_devicons = true,
				open_cmd = "vnew", -- Open spectre in a vertical split
				live_update = true, -- Auto update as you type
				line_sep_start = "┌──────────────────────────────────────────",
				result_padding = "│  ",
				line_sep = "└──────────────────────────────────────────",
				highlight = {
					ui = "String",
					search = "DiffChange",
					replace = "DiffDelete",
				},
				mapping = {
					["toggle_line"] = {
						map = "dd",
						cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
						desc = "toggle current item",
					},
					["enter_file"] = {
						map = "<cr>",
						cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
						desc = "goto current file",
					},
					["send_to_qf"] = {
						map = "<leader>q",
						cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
						desc = "send all items to quickfix",
					},
					["replace_cmd"] = {
						map = "<leader>c",
						cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
						desc = "input replace command",
					},
					["show_option_menu"] = {
						map = "<leader>o",
						cmd = "<cmd>lua require('spectre').show_options()<CR>",
						desc = "show options",
					},
					["run_replace"] = {
						map = "<leader>r",
						cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
						desc = "replace all",
					},
					["change_view_mode"] = {
						map = "<leader>v",
						cmd = "<cmd>lua require('spectre').change_view()<CR>",
						desc = "change result view mode",
					},
					["toggle_ignore_case"] = {
						map = "ti",
						cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
						desc = "toggle ignore case",
					},
					["toggle_ignore_hidden"] = {
						map = "th",
						cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>",
						desc = "toggle search hidden",
					},
					["resume_last_search"] = {
						map = "<leader>l",
						cmd = "<cmd>lua require('spectre').resume_last_search()<CR>",
						desc = "resume last search",
					},
				},
				find_engine = {
					-- rg is map with finder_cmd
					["rg"] = {
						cmd = "rg",
						-- default args
						args = {
							"--color=never",
							"--no-heading",
							"--with-filename",
							"--line-number",
							"--column",
						},
						options = {
							["ignore-case"] = {
								value = "--ignore-case",
								icon = "[I]",
								desc = "ignore case",
							},
							["hidden"] = {
								value = "--hidden",
								desc = "hidden file",
								icon = "[H]",
							},
							-- you can put any option you want here
							["fixed-strings"] = {
								value = "--fixed-strings",
								desc = "fixed strings",
								icon = "[F]",
							},
						},
					},
					["ag"] = {
						cmd = "ag",
						args = {
							"--vimgrep",
							"-s",
						},
						options = {
							["ignore-case"] = {
								value = "-i",
								icon = "[I]",
								desc = "ignore case",
							},
							["hidden"] = {
								value = "--hidden",
								desc = "hidden file",
								icon = "[H]",
							},
						},
					},
				},
				replace_engine = {
					["sed"] = {
						cmd = "sed",
						args = nil,
						options = {
							["ignore-case"] = {
								value = "--ignore-case",
								icon = "[I]",
								desc = "ignore case",
							},
						},
					},
					-- call rust code by nvim-oxi
					["oxi"] = {
						cmd = "oxi",
						args = {},
						options = {
							["ignore-case"] = {
								value = "i",
								icon = "[I]",
								desc = "ignore case",
							},
						},
					},
				},
				default = {
					find = {
						--pick one of item in find_engine
						cmd = "rg",
						options = { "ignore-case" },
					},
					replace = {
						--pick one of item in replace_engine
						cmd = "sed",
					},
				},
				replace_vim_cmd = "cfdo %s///g",
				is_open_target_win = true, --open file on opener window
				is_insert_mode = false, -- start open panel in insert mode
				is_block_ui_break = true, -- prevent ui breaking when search too frequently
			})

			-- Key mappings
			vim.keymap.set("n", "<leader>S", '<cmd>lua require("spectre").toggle()<CR>', {
				desc = "Toggle Spectre",
			})
			vim.keymap.set("n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
				desc = "Search current word",
			})
			vim.keymap.set("v", "<leader>sv", '<esc><cmd>lua require("spectre").open_visual()<CR>', {
				desc = "Search current selection",
			})
			vim.keymap.set("n", "<leader>sf", '<cmd>lua require("spectre").open_file_search()<CR>', {
				desc = "Search in current file",
			})
			vim.keymap.set("n", "<leader>sp", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
				desc = "Search word in current file",
			})
			vim.keymap.set("n", "<leader>sr", '<cmd>lua require("spectre").resume_last_search()<CR>', {
				desc = "Resume last search",
			})
		end,
	},
}
