return {
	{
		"esmuellert/nvim-eslint",
		event = { "BufReadPre", "BufNewFile" },
		ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
		config = function()
			require("nvim-eslint").setup({
				bin = "eslint_d", -- Use eslint_d for faster performance
				code_actions = {
					enable = true,
				},
				diagnostics = {
					enable = true,
				},
				formatting = {
					enable = true,
				},
			})
		end,
	},
	{
		"williamboman/mason.nvim",
		event = { "BufReadPre", "BufNewFile" }, -- Load when files are opened, not immediately
		priority = 1000,
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
		event = "VeryLazy",
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			ensure_installed = {
				"stylua",
				"luacheck",
				"prettier",
				"prettierd",
				"black",
				"isort",
				"pylint",
				"basedpyright",
				"gopls",
				"goimports",
				"gofumpt",
				"golangci-lint",
			},
			auto_update = true,
			run_on_start = false, -- Don't run on startup to avoid lag
		},
	},
	{
		"j-hui/fidget.nvim",
		event = "LspAttach",
		opts = {
			notification = {
				window = { winblend = 0, border = "none" },
			},
			progress = {
				display = { render_limit = 5, done_ttl = 3 },
			},
		},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"neovim/nvim-lspconfig",
			"williamboman/mason.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"j-hui/fidget.nvim",
		},
		config = function()
			local ok, lspconfig = pcall(require, "lspconfig")
			if not ok then
				vim.notify("Failed to load lspconfig", vim.log.levels.ERROR)
				return
			end

			local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
			if not ok_cmp then
				vim.notify("Failed to load cmp_nvim_lsp", vim.log.levels.ERROR)
				return
			end

			local capabilities = cmp_nvim_lsp.default_capabilities()

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

					-- Enable inlay hints if the server supports it
					if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
						vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
					end

					-- Disable formatting for LSPs that we'll handle with conform.nvim
					local disable_format = {
						vtsls = true,
						lua_ls = true,
						basedpyright = true,
						gopls = true,
					}

					if client and disable_format[client.name] then
						client.server_capabilities.documentFormattingProvider = false
						client.server_capabilities.documentRangeFormattingProvider = false
					end
				end,
			})

			local servers = {
				lua_ls = {
					filetypes = { "lua" },
					settings = {
						Lua = {
							diagnostics = { globals = { "vim" } },
							workspace = { library = { vim.env.VIMRUNTIME }, checkThirdParty = false },
							telemetry = { enable = false },
						},
					},
				},
				basedpyright = {
					filetypes = { "python" },
					settings = {
						basedpyright = {
							analysis = {
								typeCheckingMode = "basic",
								autoSearchPaths = true,
								useLibraryCodeForTypes = true,
							},
						},
					},
				},
				gopls = {
					filetypes = { "go", "gomod", "gowork", "gotmpl" },
					settings = {
						gopls = {
							completeUnimported = true,
							usePlaceholders = true,
							analyses = { unusedparams = true },
						},
					},
				},
				vtsls = {
					filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
					settings = {
						vtsls = {
							autoUseWorkspaceTsdk = true,
							experimental = {
								completion = {
									enableServerSideFuzzyMatch = true,
								},
							},
						},
						typescript = {
							updateImportsOnFileMove = { enabled = "always" },
							suggest = {
								completeFunctionCalls = true,
							},
						},
						javascript = {
							updateImportsOnFileMove = { enabled = "always" },
							suggest = {
								completeFunctionCalls = true,
							},
						},
					},
				},

				emmet_language_server = {
					filetypes = {
						"html",
						"css",
						"scss",
						"javascript",
						"javascriptreact",
						"typescript",
						"typescriptreact",
					},
				},
				tailwindcss = {
					filetypes = {
						"html",
						"css",
						"scss",
						"javascript",
						"javascriptreact",
						"typescript",
						"typescriptreact",
					},
				},
			}

			local ok_mason, mason_lspconfig = pcall(require, "mason-lspconfig")
			if not ok_mason then
				vim.notify("Failed to load mason-lspconfig", vim.log.levels.ERROR)
				return
			end

			mason_lspconfig.setup({
				ensure_installed = vim.tbl_keys(servers),
				handlers = {
					function(server_name)
						local config = servers[server_name]
						if config then
							config.capabilities =
								vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
							local ok, err = pcall(function()
								lspconfig[server_name].setup(config)
							end)
							if not ok then
								vim.notify(
									string.format("Failed to setup LSP server %s: %s", server_name, err),
									vim.log.levels.WARN
								)
							end
						end
					end,
				},
			})

			vim.diagnostic.config({
				virtual_text = { spacing = 4, prefix = "●" },
				severity_sort = true,
				float = { border = "rounded", source = "always", header = "", prefix = "" },
				update_in_insert = false,
				underline = true,
				signs = true,
			})

			local signs = { Error = " ", Warn = " ", Hint = "󰛩 ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end
		end,
	},
}
