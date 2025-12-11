-- Centralized LSP/diagnostics setup to avoid duplicate servers or keymaps.
local handlers = require("plugins.lsp.handlers")

return {
	{
		"williamboman/mason.nvim",
		lazy = false, -- Ensure Mason loads early to set up PATH
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		cmd = { "MasonToolsInstall", "MasonToolsUpdate" },
		opts = {
			ensure_installed = {
				"stylua",
				"clangd",
				"rust-analyzer",
				"pyright",
				"typescript-language-server",
				"prettierd",
				"eslint-lsp",
				"black",
				"isort",
				"clang-format",
				"pylint",
				"codelldb",
				"debugpy",
				"selene",
				"tailwindcss-language-server",
				"css-lsp",
				"html-lsp",
			},
			auto_update = true,
		},
		dependencies = { "williamboman/mason.nvim" },
	},
	{
		"williamboman/mason-lspconfig.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"neovim/nvim-lspconfig",
			"williamboman/mason.nvim",
			"saghen/blink.cmp",
		},
		config = function()
			local mason_lspconfig = require("mason-lspconfig")
			local lspconfig = require("lspconfig")

			require("plugins.lsp.handlers").setup()

			local servers = {
				lua_ls = {
					settings = {
						Lua = {
							diagnostics = { globals = { "vim" } },
							workspace = {
								library = { vim.env.VIMRUNTIME },
								checkThirdParty = false,
							},
							telemetry = { enable = false },
						},
					},
				},
				pyright = {},
				clangd = {
					cmd = { "clangd", "--header-insertion=never" },
				},
				tsserver = {
					settings = {
						typescript = { format = { enable = false } },
						javascript = { format = { enable = false } },
					},
				},
				eslint = {
					settings = {
						format = { enable = false },
						workingDirectory = { mode = "auto" },
					},
				},
				gopls = {},
				yamlls = {},
				jsonls = {},
				tailwindcss = {},
				cssls = {},
				html = {},
			}

			mason_lspconfig.setup({
				ensure_installed = { "lua_ls", "rust_analyzer", "pyright", "clangd", "tsserver", "eslint", "gopls", "yamlls", "jsonls", "tailwindcss", "cssls", "html" },
				handlers = {
					function(server_name)
						if server_name == "rust_analyzer" then
							return -- rustaceanvim handles this server
						end

						local server_opts = vim.tbl_deep_extend("force", servers[server_name] or {}, {
							capabilities = handlers.capabilities,
							on_attach = handlers.on_attach,
						})

						lspconfig[server_name].setup(server_opts)
					end,
				},
			})
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local null_ls = require("null-ls")

			null_ls.setup({
				sources = {
					-- Diagnostics (Linting)
					null_ls.builtins.diagnostics.pylint,
				},
				on_attach = handlers.on_attach,
			})
		end,
	},
}
