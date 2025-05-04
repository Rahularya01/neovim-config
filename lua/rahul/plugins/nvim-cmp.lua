return {
	"hrsh7th/nvim-cmp",
	event = { "InsertEnter", "CmdlineEnter" }, -- Enable completion in command mode too
	dependencies = {

		"hrsh7th/cmp-buffer", -- source for text in buffer
		"hrsh7th/cmp-path", -- source for file system paths
		"hrsh7th/cmp-cmdline", -- source for vim command line
		"hrsh7th/cmp-nvim-lsp", -- source for neovim's built-in LSP
		"hrsh7th/cmp-nvim-lua", -- source for Neovim Lua API
		{
			"L3MON4D3/LuaSnip",
			version = "v2.*",
			build = "make install_jsregexp",
			dependencies = {
				"rafamadriz/friendly-snippets", -- useful snippets
			},
		},
		"saadparwaiz1/cmp_luasnip", -- for autocompletion
		"onsails/lspkind.nvim", -- vs-code like pictograms
		"windwp/nvim-autopairs", -- auto close brackets, quotes, etc.
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local lspkind = require("lspkind")
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")

		-- Configure nvim-autopairs
		require("nvim-autopairs").setup({
			check_ts = true, -- Use treesitter to check for pairs
			fast_wrap = {
				map = "<M-e>", -- Alt+e to fast wrap
				chars = { "{", "[", "(", '"', "'" },
				pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
				offset = 0, -- Offset from pattern match
				end_key = "$",
				keys = "qwertyuiopzxcvbnmasdfghjkl",
				check_comma = true,
				highlight = "PmenuSel",
				highlight_grey = "LineNr",
			},
		})

		-- Hook autopairs into cmp
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

		-- Load VSCode snippets
		require("luasnip.loaders.from_vscode").lazy_load()

		-- Add some useful snippets programmatically
		luasnip.add_snippets("all", {
			luasnip.snippet("date", {
				luasnip.function_node(function()
					return os.date("%Y-%m-%d")
				end, {}),
			}),
		})

		-- Helper function for super-tab functionality
		local has_words_before = function()
			unpack = unpack or table.unpack
			local line, col = unpack(vim.api.nvim_win_get_cursor(0))
			return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
		end

		-- Setup completion
		cmp.setup({
			completion = {
				completeopt = "menu,menuone,preview,noselect",
			},
			window = {
				completion = cmp.config.window.bordered({
					winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
					border = "rounded",
					scrollbar = true,
				}),
				documentation = cmp.config.window.bordered({
					winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
					border = "rounded",
					scrollbar = true,
				}),
			},
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-k>"] = cmp.mapping.select_prev_item(),
				["<C-j>"] = cmp.mapping.select_next_item(),
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),
				["<CR>"] = cmp.mapping.confirm({ select = false }),
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					elseif has_words_before() then
						cmp.complete()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp", priority = 1000 },
				{ name = "nvim_lua", priority = 900 },
				{ name = "luasnip", priority = 800 },
				{ name = "buffer", priority = 700 },
				{ name = "path", priority = 600 },
			}),
			formatting = {
				format = lspkind.cmp_format({
					mode = "symbol_text", -- Show both symbol and text
					maxwidth = 50,
					ellipsis_char = "...",
					menu = {
						buffer = "[Buffer]",
						nvim_lsp = "[LSP]",
						nvim_lua = "[API]",
						path = "[Path]",
						luasnip = "[Snippet]",
					},
					before = function(entry, vim_item)
						-- Get the full snippet text
						if entry.source.name == "luasnip" then
							vim_item.abbr = string.format("%s %s", vim_item.abbr, "[Snippet]")
						end
						return vim_item
					end,
				}),
			},
			sorting = {
				comparators = {
					cmp.config.compare.offset,
					cmp.config.compare.exact,
					cmp.config.compare.score,
					-- Prioritize snippets
					function(entry1, entry2)
						local types = require("cmp.types")
						if entry1.source.name == "luasnip" and entry2.source.name ~= "luasnip" then
							return true
						elseif entry1.source.name ~= "luasnip" and entry2.source.name == "luasnip" then
							return false
						end
						return nil
					end,
					cmp.config.compare.kind,
					cmp.config.compare.sort_text,
					cmp.config.compare.length,
					cmp.config.compare.order,
				},
			},
			experimental = {
				ghost_text = true, -- Show future text as ghost text
			},
		})

		-- Set up special configuration for specific filetypes
		cmp.setup.filetype("gitcommit", {
			sources = cmp.config.sources({
				{ name = "buffer" },
			}),
		})

		-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore)
		cmp.setup.cmdline({ "/", "?" }, {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "buffer" },
			},
		})

		-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore)
		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
				{ name = "cmdline" },
			}),
		})
	end,
}
