return {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	keys = {
		{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
		{ "<leader>fa", "<cmd>Telescope find_files hidden=true no_ignore=true<cr>", desc = "Find all files" },
		{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
		{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
		{ "<leader>.", "<cmd>Telescope buffers<cr>", desc = "Show all buffers" },
		{ "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
		{ "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "Grep word under cursor" },
		{ "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Search help" },
		{ "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Search keymaps" },
		{ "<leader>sc", "<cmd>Telescope commands<cr>", desc = "Search commands" },
		{ "<leader>sr", "<cmd>Telescope resume<cr>", desc = "Resume last search" },
		{ "<leader>cs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols" },
		{ "<leader>ws", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace symbols" },
		{ "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document diagnostics" },
		{ "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace diagnostics" },
		{ "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git commits" },
		{ "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git status" },
		{ "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Git branches" },
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				prompt_prefix = " ",
				selection_caret = " ",
				path_display = { "smart" },
				sorting_strategy = "ascending",
				layout_strategy = "horizontal",
				layout_config = {
					horizontal = {
						prompt_position = "top",
						preview_width = 0.55,
						results_width = 0.8,
					},
					vertical = {
						mirror = false,
					},
					width = 0.87,
					height = 0.80,
					preview_cutoff = 120,
				},
				file_ignore_patterns = {
					"node_modules",
					"%.git/",
					"__pycache__",
					"%.pyc",
					"%.pyo",
					"%.pyd",
					"%.egg%-info",
					"dist/",
					"build/",
					"%.so",
					"%.dylib",
					"%.dll",
					"%.class",
					"%.zip",
					"%.tar%.gz",
					"%.rar",
					"%.pdf",
					"%.jpg",
					"%.jpeg",
					"%.png",
					"%.gif",
					"%.ico",
					"%.svg",
					"%.ttf",
					"%.woff",
					"%.woff2",
					"%.eot",
					"%.mp3",
					"%.mp4",
					"target/",
					"vendor/",
					"%.lock",
				},
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--hidden",
					"--glob",
					"!**/.git/*",
				},
				mappings = {
					i = {
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						["<C-n>"] = actions.cycle_history_next,
						["<C-p>"] = actions.cycle_history_prev,
						["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
						["<C-s>"] = actions.select_horizontal,
						["<C-v>"] = actions.select_vertical,
						["<C-t>"] = actions.select_tab,
						["<C-u>"] = actions.preview_scrolling_up,
						["<C-d>"] = actions.preview_scrolling_down,
						["<Esc>"] = actions.close,
					},
					n = {
						["q"] = actions.close,
						["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
						["<C-s>"] = actions.select_horizontal,
						["<C-v>"] = actions.select_vertical,
						["<C-t>"] = actions.select_tab,
					},
				},
				preview = {
					treesitter = true,
				},
				history = {
					path = vim.fn.stdpath("data") .. "/telescope_history.sqlite3",
					limit = 100,
				},
				color_devicons = true,
				set_env = { ["COLORTERM"] = "truecolor" },
				borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
			},
			pickers = {
				find_files = {
					find_command = {
						"rg",
						"--files",
						"--hidden",
						"--glob",
						"!**/.git/*",
						"--glob",
						"!**/node_modules/*",
					},
					follow = true,
				},
				live_grep = {
					additional_args = function()
						return { "--hidden" }
					end,
				},
				grep_string = {
					additional_args = function()
						return { "--hidden" }
					end,
				},
				buffers = {
					sort_lastused = true,
					sort_mru = true,
					ignore_current_buffer = true,
					mappings = {
						i = {
							["<C-d>"] = actions.delete_buffer,
						},
						n = {
							["dd"] = actions.delete_buffer,
						},
					},
				},
				lsp_references = {
					show_line = false,
					include_declaration = false,
				},
				lsp_definitions = {
					show_line = false,
				},
				lsp_document_symbols = {
					symbol_width = 50,
				},
				lsp_dynamic_workspace_symbols = {
					symbol_width = 50,
				},
				oldfiles = {
					cwd_only = true,
				},
			},
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			},
		})

		-- Load extensions
		telescope.load_extension("fzf")
	end,
}
