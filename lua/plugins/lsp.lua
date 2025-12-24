return {
	{
		"williamboman/mason.nvim",
		lazy = false,
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
		cmd = { "MasonToolsInstall", "MasonToolsUpdate" },
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			ensure_installed = {
				-- Lua
				"stylua",
				"luacheck",
				-- C/C++
				"clang-format",
				"codelldb", -- Debugger
				-- Web
				"prettier",
				"prettierd",
				"eslint_d",
				-- Python
				"black",
				"isort",
				"pylint",
				-- Go
				"gopls", -- LSP
				"goimports", -- Formatter
				"delve", -- Debugger
			},
			auto_update = true,
		},
	},
	{
		"j-hui/fidget.nvim",
		event = "LspAttach",
		opts = {
			notification = {
				window = {
					winblend = 0,
					border = "none",
				},
			},
			progress = {
				display = {
					render_limit = 5,
					done_ttl = 3,
				},
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
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
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

					-- Disable formatting for LSPs that we'll handle with conform.nvim
					local disable_format = {
						ts_ls = true,
						lua_ls = true,
						pyright = true,
						eslint = true,
						clangd = true, -- Let conform handle C/C++
						gopls = true, -- Let conform handle Go
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
				pyright = {
					filetypes = { "python" },
					settings = {
						python = {
							analysis = {
								typeCheckingMode = "basic",
								autoSearchPaths = true,
								useLibraryCodeForTypes = true,
							},
						},
					},
				},
				clangd = {
					-- Rely on Mason's path automatically
					cmd = {
						"clangd",
						"--background-index",
						"--clang-tidy",
						"--header-insertion=iwyu",
						"--completion-style=detailed",
						"--function-arg-placeholders",
						"--fallback-style=llvm",
					},
					filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
					capabilities = vim.tbl_deep_extend("force", capabilities, {
						offsetEncoding = { "utf-16" },
					}),
				},
				gopls = {
					filetypes = { "go", "gomod", "gowork", "gotmpl" },
					settings = {
						gopls = {
							completeUnimported = true,
							usePlaceholders = true,
							analyses = {
								unusedparams = true,
							},
						},
					},
				},
				ts_ls = {
					filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
				},
				eslint = {
					filetypes = {
						"javascript",
						"javascriptreact",
						"typescript",
						"typescriptreact",
						"vue",
						"svelte",
						"astro",
					},
					settings = {
						validate = "on",
						packageManager = "npm",
						useESLintClass = true,
						workingDirectory = { mode = "auto" },
						experimental = { useFlatConfig = false },
						run = "onType",
						codeAction = {
							disableRuleComment = { enable = true, location = "separateLine" },
							showDocumentation = { enable = true },
						},
						codeActionOnSave = { enable = false, mode = "all" },
						format = false,
						quiet = false,
						onIgnoredFiles = "off",
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

			require("mason-lspconfig").setup({
				ensure_installed = vim.tbl_keys(servers),
			})

		for name, config in pairs(servers) do
			config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
			vim.lsp.config(name, config)
		end

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
