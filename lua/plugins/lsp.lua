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
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			ensure_installed = {
				"stylua",
				"prettier",
				"black",
				"isort",
				"clang-format",
				"pylint",
			},
			auto_update = true,
		},
	},

	{
		"williamboman/mason-lspconfig.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"neovim/nvim-lspconfig",
			"williamboman/mason.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local mason_lspconfig = require("mason-lspconfig")
			local lspconfig = require("lspconfig")
			local cmp_nvim_lsp = require("cmp_nvim_lsp")

			local capabilities = cmp_nvim_lsp.default_capabilities()

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
				underline = true,
				severity_sort = true,
				update_in_insert = false,
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
						vim.lsp.buf.code_action({ context = { only = { "source" } } })
					end, "Source actions")

					map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
					map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
					map("n", "<leader>ld", vim.diagnostic.open_float, "Line diagnostics")

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					local disable_format = {
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

				clangd = {
					cmd = { "clangd", "--header-insertion=never" },
				},

				ts_ls = {
					settings = {
						typescript = { format = { enable = false } },
						javascript = { format = { enable = false } },
					},
				},

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
					init_options = {
						showAbbreviationSuggestions = false,
						showSuggestionsAsSnippets = true,
						showExpandedAbbreviation = "always",
					},
					syntaxProfiles = {
						jsx = { self_closing_tag = true },
					},
				},

				tailwindcss = {},
			}

			local lsp_servers = {
				"lua_ls",
				"pyright",
				"clangd",
				"ts_ls",
				"eslint",
				"tailwindcss",
				"emmet_language_server",
			}

			mason_lspconfig.setup({
				ensure_installed = lsp_servers,
				automatic_enable = true,
			})

			local has_native = (vim.lsp and vim.lsp.config and vim.lsp.enable)

			for _, name in ipairs(lsp_servers) do
				local opts = vim.tbl_deep_extend("force", servers[name] or {}, {
					capabilities = capabilities,
				})

				if has_native then
					vim.lsp.config(name, opts)
					vim.lsp.enable(name)
				else
					lspconfig[name].setup(opts)
				end
			end
		end,
	},
}
