return {
	"stevearc/oil.nvim",
	-- Optional dependencies
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("oil").setup({
			-- Oil will take over directory buffers (e.g. foo/bar/)
			default_file_explorer = true,
			columns = {
				"icon",
			},
			-- Buffer-local options
			buf_options = {
				buflisted = false,
				bufhidden = "hide",
			},
			-- Window-local options
			win_options = {
				wrap = false,
				signcolumn = "no",
				cursorcolumn = false,
				foldcolumn = "0",
				spell = false,
				list = false,
				conceallevel = 3,
				concealcursor = "nvic",
			},
			-- Send deleted files to the trash instead of permanently deleting them
			delete_to_trash = false,
			skip_confirm_for_simple_edits = false,
			save_confirm = true,
			view_options = {
				show_hidden = true,
				is_hidden_file = function(name, bufnr)
					return vim.startswith(name, ".")
				end,
				is_always_hidden_file = function(name, bufnr)
					return false
				end,
				natural_order = true,
				sort = {
					{ "type", "asc" },
					{ "name", "asc" },
				},
			},
			-- NEW: Keyboard shortcuts specifically for the Oil buffer
			keymaps = {
				["g?"] = "actions.show_help",
				["<CR>"] = "actions.select",
				["<C-v>"] = "actions.select_vsplit",
				["<leader>H"] = "actions.select_split",
				["<C-t>"] = "actions.select_tab",
				["<C-p>"] = "actions.preview",
				["q"] = "actions.close", -- Close Oil
				["<Esc>"] = "actions.close", -- Close Oil with Escape
				["R"] = "actions.refresh",
				["-"] = "actions.parent",
				["_"] = "actions.open_cwd",
				["`"] = "actions.cd",
				["~"] = "actions.tcd",
				["gs"] = "actions.change_sort",
				["gx"] = "actions.open_external",
				["g."] = "actions.toggle_hidden",
				["g\\"] = "actions.toggle_trash",
			},
		})

		-- Global keymaps to open Oil
		vim.keymap.set("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory" })
		vim.keymap.set("n", "<leader>O", "<cmd>Oil<CR>", { desc = "Open Oil" })
	end,
}
