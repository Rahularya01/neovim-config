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
		"williamboman/mason-lspconfig.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"neovim/nvim-lspconfig",
			"williamboman/mason.nvim",
			"hrsh7th/cmp-nvim-lsp",
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
					local disable_format = {
						ts_ls = true,
						lua_ls = true,
						pyright = true,
						clangd = true,
						eslint = true,
					}

					if client and disable_format[client.name] then
						client.server_capabilities.documentFormattingProvider = false
						client.server_capabilities.documentRangeFormattingProvider = false
					end

					if client and client.name == "eslint" then
						local root_dir = client.config.root_dir or vim.fn.getcwd()
						local workspace_folder = {
							uri = vim.uri_from_fname(root_dir),
							name = vim.fn.fnamemodify(root_dir, ":t"),
						}
						if not client.config.settings then
							client.config.settings = {}
						end
						client.config.settings.workspaceFolder = workspace_folder
						client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
					end
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
				},
				clangd = {
					cmd = { get_mason_bin("clangd"), "--header-insertion=never" },
					filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
				},
				ts_ls = {
					cmd = { get_mason_bin("typescript-language-server"), "--stdio" },
					filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
					init_options = {
						preferences = {
							disableSuggestions = true,
						},
					},
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
						showAbbreviationSuggestions = false,
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
				virtual_text = true,
				severity_sort = true,
				float = { border = "rounded", source = "always" },
				update_in_insert = false,
			})

			local signs = { Error = "", Warn = "", Hint = "", Info = "" }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end
		end,
	},
}
