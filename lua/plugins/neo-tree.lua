return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		lazy = false,

		keys = {
			{ "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Toggle NeoTree" },
		},

		opts = {
			-- 1. General UI Settings
			close_if_last_window = true, -- Close Neo-tree if it's the last window left
			popup_border_style = "rounded",
			enable_git_status = true,
			enable_diagnostics = true,

			-- 2. Visuals & Icons Configuration
			default_component_configs = {
				indent = {
					with_expanders = true, -- Add expander triangles
					expander_collapsed = "",
					expander_expanded = "",
					expander_highlight = "NeoTreeExpander",
				},
				icon = {
					folder_closed = "",
					folder_open = "",
					folder_empty = "󰜌",
					default = "*",
					highlight = "NeoTreeFileIcon",
				},
				modified = {
					symbol = "[+]",
					highlight = "NeoTreeModified",
				},
				git_status = {
					symbols = {
						-- Change type
						added = "",
						modified = "",
						deleted = "✖",
						renamed = "󰁕",
						-- Status type
						untracked = "",
						ignored = "",
						unstaged = "󰄱",
						staged = "",
						conflict = "",
					},
				},
			},

			-- 3. Filesystem Specific Settings
			filesystem = {
				follow_current_file = {
					enabled = true, -- This will find and focus the file in the active buffer
					leave_dirs_open = false,
				},
				use_libuv_file_watcher = true, -- This will automatically detect changes (e.g. from git pull)

				-- Filter out hidden files
				filtered_items = {
					visible = false,
					hide_dotfiles = false,
					hide_gitignored = false,
					hide_by_name = {
						".git",
						".DS_Store",
						"thumbs.db",
					},
				},

				-- 4. Keymaps (Your custom mapping)
				window = {
					mappings = {
						["l"] = "open",
						["h"] = "close_node",
						["a"] = "add",
						["A"] = "add_directory",
						["d"] = "delete",
						["r"] = "rename",

						-- Optional: Map '?' to show help
						["?"] = "show_help",
					},
				},
			},
		},
	},
}
