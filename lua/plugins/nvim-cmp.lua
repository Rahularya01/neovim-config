return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"saadparwaiz1/cmp_luasnip",

		{
			"L3MON4D3/LuaSnip",
			version = "v2.*",
			build = "make install_jsregexp",
			dependencies = {
				"rafamadriz/friendly-snippets",
			},
		},

		"onsails/lspkind.nvim",
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local lspkind = require("lspkind")

		-- Load snippets
		require("luasnip.loaders.from_vscode").lazy_load()

		-- Helper: check if there are words before cursor
		local has_words_before = function()
			local line, col = unpack(vim.api.nvim_win_get_cursor(0))
			if col == 0 then
				return false
			end
			local text = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
			return text:sub(col, col):match("%s") == nil
		end

		cmp.setup({
			completion = {
				-- ✅ allow first item to be selected (remove "noselect")
				completeopt = "menu,menuone",
			},

			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},

			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},

			-- ✅ preselect the first suggestion
			preselect = cmp.PreselectMode.Item,

			mapping = cmp.mapping.preset.insert({
				["<C-k>"] = cmp.mapping.select_prev_item(),
				["<C-j>"] = cmp.mapping.select_next_item(),
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),

				-- ✅ Enter always confirms; if nothing explicitly selected, it picks the first
				["<CR>"] = cmp.mapping.confirm({ select = true }),

				-- Tab behavior: cmp → snippet → complete → fallback
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

			-- Sources
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "path" },
				{ name = "buffer", keyword_length = 3, max_item_count = 50 },
			}),

			-- 🎨 Formatting: FIX duplicate icons
			formatting = {
				fields = { "kind", "abbr", "menu" },
				format = function(entry, item)
					-- Icon ONLY in kind column
					item.kind = lspkind.symbolic(item.kind, { mode = "symbol" })

					local source = ({
						nvim_lsp = "LSP",
						luasnip = "SNIP",
						buffer = "BUF",
						path = "PATH",
					})[entry.source.name] or entry.source.name

					-- Put readable info in menu column
					item.menu = string.format("[%s]", source)
					return item
				end,
			},

			-- Optional perf tuning
			performance = {
				debounce = 60,
				throttle = 30,
				fetching_timeout = 200,
			},

			-- Optional VS Code–like inline hint
			experimental = {
				ghost_text = true,
			},
		})
	end,
}
