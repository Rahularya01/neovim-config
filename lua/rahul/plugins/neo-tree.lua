return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		-- some custom highlights for the floating border & background
		vim.cmd([[
      hi NeoTreeFloatBorder guifg=#61afef guibg=#1e222a
      hi NeoTreeFloatNormal guibg=#1e222a
      hi NeoTreeExpander guifg=#c678dd
      hi NeoTreeIndentMarker guifg=#3e4452
    ]])

		require("neo-tree").setup({
			-- show as a floating window
			window = {
				position = "float",
				popup = {
					size = { width = "80%", height = "85%" },
					border = "rounded",
					winblend = 10,
				},
				mappings = {
					["l"] = "open",
					["h"] = "close_node",
					["o"] = "open_with_window_picker",
					["R"] = "refresh",
					["q"] = "close_window",
				},
			},

			-- custom icons for files & folders
			default_component_configs = {
				icon = {
					folder_closed = "",
					folder_open = "",
					folder_empty = "",
					default = "",
					highlight = "NeoTreeFileIcon",
				},
				indent = {
					with_expanders = true,
					expander_collapsed = "",
					expander_expanded = "",
					expander_highlight = "NeoTreeExpander",
					indent_marker = "│",
				},
				git_status = {
					symbols = {
						added = "✚",
						modified = "",
						removed = "✖",
						untracked = "",
						ignored = "◌",
						unstaged = "󰄬",
						staged = "󰸞",
						conflict = "",
					},
				},
			},

			sources = { "filesystem", "buffers", "git_status" },
			open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "Outline" },

			filesystem = {
				bind_to_cwd = false,
				follow_current_file = { enabled = true },
				use_libuv_file_watcher = true,
				filtered_items = {
					hide_dotfiles = false,
					hide_gitignored = true,
				},
			},
		})

		-- toggle with float on <leader>e
		vim.keymap.set("n", "<leader>E", ":Neotree float<CR>", { desc = " Neo-tree (float)" })
		-- quick split-open with <leader>E
		vim.keymap.set("n", "<leader>e", ":Neotree toggle filesystem left<CR>", { desc = " Neo-tree (side)" })
	end,
}
