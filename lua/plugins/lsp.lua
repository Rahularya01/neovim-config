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
				"stylua",
				"luacheck",
				"prettier",
				"black",
				"isort",
				"clang-format",
				"pylint",
				"prettierd",
				"eslint_d",
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

			local function get_mason_bin(bin_name)
				return vim.fn.stdpath("data") .. "/mason/bin/" .. bin_name
			end

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
					}

					if client and disable_format[client.name] then
						client.server_capabilities.documentFormattingProvider = false
						client.server_capabilities.documentRangeFormattingProvider = false
					end

					-- Inlay hints are disabled by default
					-- Uncomment to enable:
					-- if client and client.server_capabilities.inlayHintProvider then
					-- 	vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
					-- end
				end,
			})

			local servers = {
				lua_ls = {
					cmd = { get_mason_bin("lua-language-server") },
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
					cmd = { get_mason_bin("pyright-langserver"), "--stdio" },
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
					cmd = {
						get_mason_bin("clangd"),
						"--background-index",
						"--clang-tidy",
						"--header-insertion=iwyu",
						"--completion-style=detailed",
						"--function-arg-placeholders",
					},
					filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
					capabilities = vim.tbl_deep_extend("force", capabilities, {
						offsetEncoding = { "utf-16" },
					}),
				},
				ts_ls = {
					cmd = { get_mason_bin("typescript-language-server"), "--stdio" },
					filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
				},
				eslint = {
					cmd = { get_mason_bin("vscode-eslint-language-server"), "--stdio" },
					filetypes = {
						"javascript",
						"javascriptreact",
						"typescript",
						"typescriptreact",
						"vue",
						"svelte",
						"astro",
					},
					root_dir = function(bufnr, on_dir)
						local fname = vim.api.nvim_buf_get_name(bufnr)
						local root = vim.fs.root(fname, {
							".eslintrc",
							".eslintrc.js",
							".eslintrc.json",
							".eslintrc.cjs",
							".eslintrc.yml",
							".eslintrc.yaml",
							"eslint.config.js",
							"eslint.config.mjs",
							"eslint.config.cjs",
							"eslint.config.ts",
							"package.json",
						})
						if root then
							on_dir(root)
						end
					end,
					on_new_config = function(config, new_root_dir)
						config.settings.workspaceFolder = {
							uri = vim.uri_from_fname(new_root_dir),
							name = vim.fn.fnamemodify(new_root_dir, ":t"),
						}
					end,
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
						codeActionOnSave = {
							enable = false,
							mode = "all",
						},
						format = false,
						quiet = false,
						onIgnoredFiles = "off",
					},
				},
				emmet_language_server = {
					cmd = { get_mason_bin("emmet-language-server"), "--stdio" },
					filetypes = {
						"html",
						"css",
						"scss",
						"javascript",
						"javascriptreact",
						"typescript",
						"typescriptreact",
					},
					init_options = {
						showAbbreviationSuggestions = true,
						showSuggestionsAsSnippets = true,
						showExpandedAbbreviation = "always",
					},
				},
				tailwindcss = {
					cmd = { get_mason_bin("tailwindcss-language-server"), "--stdio" },
					filetypes = {
						"html",
						"css",
						"scss",
						"javascript",
						"javascriptreact",
						"typescript",
						"typescriptreact",
					},
					settings = {
						tailwindCSS = {
							experimental = {
								classRegex = {
									{ "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
									{ "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
								},
							},
						},
					},
				},
			}

			require("mason-lspconfig").setup({
				ensure_installed = vim.tbl_keys(servers),
			})

			for name, config in pairs(servers) do
				config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})

				if vim.lsp.config then
					vim.lsp.config[name] = config
					vim.lsp.enable(name)
				else
					require("lspconfig")[name].setup(config)
				end
			end

			vim.diagnostic.config({
				virtual_text = {
					spacing = 4,
					prefix = "●",
				},
				severity_sort = true,
				float = {
					border = "rounded",
					source = "always",
					header = "",
					prefix = "",
				},
				update_in_insert = false,
				underline = true,
				signs = true,
			})

			local signs = { Error = "", Warn = "", Hint = "", Info = "" }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end
		end,
	},
}
