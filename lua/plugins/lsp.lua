return {
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
				"clang-format",
				"codelldb",
				"prettier",
				"prettierd",
				"eslint_d",
				"black",
				"isort",
				"pylint",
				"gopls",
				"goimports",
				"gofumpt",
				"golangci-lint",
				"delve",
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
			"p00f/clangd_extensions.nvim", -- Added dependency
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

					-- C/C++ specific: Switch Source/Header
					map("n", "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", "Switch Source/Header")

					local client = vim.lsp.get_client_by_id(event.data.client_id)

					-- Enable Inlay Hints if the server supports it (Clangd does)
					if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
						vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
					end

					-- Disable formatting for LSPs that we'll handle with conform.nvim
					local disable_format = {
						ts_ls = true,
						lua_ls = true,
						pyright = true,
						eslint = true,
						clangd = true,
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
							analyses = { unusedparams = true },
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

			local ok_mason, mason_lspconfig = pcall(require, "mason-lspconfig")
			if not ok_mason then
				vim.notify("Failed to load mason-lspconfig", vim.log.levels.ERROR)
				return
			end

			mason_lspconfig.setup({
				ensure_installed = vim.tbl_keys(servers),
				handlers = {
					-- Default handler for most servers
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
					-- Special handler for clangd with extensions
					clangd = function()
						local config = servers.clangd
						if config then
							config.capabilities =
								vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
							local ok_clangd, clangd_ext = pcall(require, "clangd_extensions")
							if ok_clangd then
								clangd_ext.setup({
									server = config,
									inlay_hints = {
										inline = vim.fn.has("nvim-0.10") == 1,
									},
								})
							else
								-- Fallback to regular clangd setup if extensions fail
								lspconfig.clangd.setup(config)
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
