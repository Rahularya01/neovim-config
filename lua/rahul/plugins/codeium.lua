return {
	"Exafunction/codeium.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim", -- Required dependency
		"hrsh7th/nvim-cmp", -- For completion integration
	},

	event = "InsertEnter", -- Load only when entering insert mode for better startup time
	config = function()
		local codeium = require("codeium")

		codeium.setup({
			-- Core settings
			enable_chat = true, -- Enable Codeium chat feature
			language_server = {
				-- Language server settings
				command = "codeium_language_server",
				on_attach = function(client, bufnr)
					-- Allow LSP hover while using Codeium
					vim.api.nvim_buf_set_keymap(
						bufnr,
						"i",
						"<C-h>",
						[[<Cmd>lua vim.lsp.buf.hover()<CR>]],
						{ noremap = true, silent = true }
					)
				end,
			},

			-- Completion display settings
			completion = {
				enable = true, -- Enable completion
				accept_method = "key", -- How to accept completions: "key" or "input"
				debounce_ms = 100, -- Debounce time to reduce server load
				keyboard_mode = "auto", -- Keyboard layout: "auto", "vscode" or "jk"
				keep_after_accept = false, -- Clear suggestions after accepting one
			},

			-- Virtual text display for suggestions
			virtual_text = {
				enabled = true, -- Show suggestions as virtual text
				prefix = " ", -- Prefix for the virtual text
				max_lines = 20, -- Maximum lines of virtual text
				highlight = "CodeiumSuggestion", -- Highlight group for virtual text
			},

			-- Tool windows settings
			tools = {
				chat = {
					width = 0.4, -- Chat window width (percentage of screen)
					height = 0.6, -- Chat window height
					border = "rounded", -- Border style: "none", "single", "double", "rounded"
					position = "50%", -- Window position
				},
			},

			-- Custom filetype-specific configurations
			filetype_config = {
				-- Disable for specific filetypes
				["markdown"] = { enabled = true, trim_spaces = false },
				["text"] = { enabled = true, trim_spaces = false },
				["gitcommit"] = { enabled = true },
				["TelescopePrompt"] = { enabled = false },
			},
		})

		-- Keymap settings for Codeium
		vim.keymap.set("i", "<C-g>", function()
			return vim.fn["codeium#Accept"]()
		end, { expr = true, silent = true })
		vim.keymap.set("i", "<C-n>", function()
			return vim.fn["codeium#CycleCompletions"](1)
		end, { expr = true, silent = true })
		vim.keymap.set("i", "<C-p>", function()
			return vim.fn["codeium#CycleCompletions"](-1)
		end, { expr = true, silent = true })
		vim.keymap.set("i", "<C-x>", function()
			return vim.fn["codeium#Clear"]()
		end, { expr = true, silent = true })
		vim.keymap.set("n", "<leader>cc", "<cmd>CodeiumChat<cr>", { desc = "Codeium Chat" })

		-- Define custom highlight group for Codeium suggestions
		vim.api.nvim_set_hl(0, "CodeiumSuggestion", { fg = "#808080", italic = true })
	end,
}
