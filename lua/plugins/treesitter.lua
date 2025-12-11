return {
	-- 1. Configure nvim-ts-autotag separately
	{
		"windwp/nvim-ts-autotag",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			-- Defaults
			enable_close = true,
			enable_rename = true,
			enable_close_on_slash = true, -- Auto close on trailing </
		},
	},

	-- 2. Your Treesitter configuration
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"c",
					"cpp",
					"lua",
					"vim",
					"vimdoc",
					"rust",
					"toml",
					"json",
					"javascript",
					"typescript",
					"tsx",
					"python",
					"markdown",
					"markdown_inline",
					"go",
					"yaml",
					"html",
					"css", -- Added html/css as they are crucial for autotag testing
				},
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "gnn",
						node_incremental = "grn",
						scope_incremental = "grc",
						node_decremental = "grm",
					},
				},
				-- NOTE: 'autotag' section is REMOVED from here.
				-- It is handled by the plugin block above.

				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
						},
					},
				},
			})
		end,
	},
}
