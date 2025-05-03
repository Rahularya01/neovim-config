return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				javascript = { "prettierd", "biome" },
				typescript = { "prettierd", "biome" },
				javascriptreact = { "prettierd", "biome" },
				typescriptreact = { "prettierd", "biome" },
				svelte = { "prettierd", "biome" },
				css = { "prettierd", "biome" },
				html = { "prettierd", "biome" },
				json = { "prettierd", "biome" },
				yaml = { "prettierd", "biome" },
				markdown = { "prettierd", "biome" },
				graphql = { "prettierd", "biome" },
				liquid = { "prettierd", "biome" },
				lua = { "stylua" },
				python = { "isort", "black" },
				go = { "gofmt", "goimports" },
				rust = { "rustfmt" },
				sh = { "shfmt" },
			},
			formatters = {
				prettier = {
					prepend_args = { "--prose-wrap", "always" },
				},
				shfmt = {
					prepend_args = { "-i", "2", "-ci" },
				},
			},
			format_on_save = {
				lsp_fallback = true,
				timeout_ms = 1000,
			},
			notify_on_error = true,
		})

		-- Format current buffer or selection
		vim.keymap.set({ "n", "v" }, "mp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or selection" })

		-- Format and then save
		vim.keymap.set("n", "mw", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			}, function()
				vim.cmd("w")
			end)
		end, { desc = "Format and write" })
	end,
	dependencies = {
		"mason.nvim",
	},
}
