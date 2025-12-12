return {
	{
		"williamboman/mason.nvim",
		lazy = false,
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
				"eslint-lsp",
				"prettier",
				"black",
				"isort",
				"clang-format",
				"pylint",
				"emmet_language_server",
				"tailwindcss",
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

			local capabilities
			local ok, blink = pcall(require, "blink.cmp")
			if ok then
				capabilities = blink.get_lsp_capabilities()
			else
				capabilities = vim.lsp.protocol.make_client_capabilities()
			end

			local signs = {
				{ name = "DiagnosticSignError", text = "" },
				{ name = "DiagnosticSignWarn", text = "" },
				{ name = "DiagnosticSignHint", text = "" },
				{ name = "DiagnosticSignInfo", text = "" },
			}

			for _, sign in ipairs(signs) do
				vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
			end

			vim.diagnostic.config({
				virtual_text = true,
				signs = { active = signs },
				update_in_insert = true,
				underline = true,
				severity_sort = true,
				float = {
					focusable = false,
					style = "minimal",
					border = "rounded",
					source = "always",
					header = "",
					prefix = "",
				},
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
				callback = function(event)
					local map = function(mode, lhs, rhs, desc)
						vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, silent = true, desc = desc })
					end

					map("n", "K", vim.lsp.buf.hover, "Hover")
					map("n", "gd", vim.lsp.buf.definition, "Go to definition")
					map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
					map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
					map("n", "gr", vim.lsp.buf.references, "List references")
					map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
					map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")

					map("n", "<leader>oi", function()
						vim.lsp.buf.code_action({
							context = { only = { "source" } },
						})
					end)

					map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
					map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
					map("n", "<leader>ld", vim.diagnostic.open_float, "Line diagnostics")

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					local disable_format = {
						tsserver = true,
						ts_ls = true,
						lua_ls = true,
						pyright = true,
						clangd = true,
						rust_analyzer = true,
						eslint = true,
					}

					if client and disable_format[client.name] then
						client.server_capabilities.documentFormattingProvider = false
						client.server_capabilities.documentRangeFormattingProvider = false
					end
				end,
			})

			local servers = {
				lua_ls = {
					settings = {
						Lua = {
							diagnostics = { globals = { "vim" } },
							workspace = { library = { vim.env.VIMRUNTIME }, checkThirdParty = false },
							telemetry = { enable = false },
						},
					},
				},
				pyright = {},
				clangd = { cmd = { "clangd", "--header-insertion=never" } },
				ts_ls = {
					settings = {
						typescript = { format = { enable = false } },
						javascript = { format = { enable = false } },
					},
				},
				-- UPDATED ESLINT CONFIGURATION
				eslint = {
					settings = {
						workingDirectory = { mode = "auto" },
						format = { enable = false },
					},
					root_dir = lspconfig.util.root_pattern(
						".eslintrc",
						".eslintrc.js",
						".eslintrc.cjs",
						".eslintrc.yaml",
						".eslintrc.yml",
						".eslintrc.json",
						"eslint.config.js",
						"eslint.config.mjs",
						"eslint.config.cjs"
					),
				},
				emmet_language_server = {
					filetypes = { "html", "typescriptreact", "javascriptreact" },
				},
				tailwindcss = {},
			}

			mason_lspconfig.setup({
				ensure_installed = {
					"lua_ls",
					"rust_analyzer",
					"pyright",
					"clangd",
					"ts_ls",
					"eslint",
					"emmet_language_server",
					"tailwindcss",
				},
				handlers = {
					function(server_name)
						if server_name == "rust_analyzer" then
							return
						end

						local server_opts = vim.tbl_deep_extend("force", servers[server_name] or {}, {
							capabilities = capabilities,
						})

						lspconfig[server_name].setup(server_opts)
					end,
				},
			})
		end,
	},
}
