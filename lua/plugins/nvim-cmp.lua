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

		-- Helper: avoid annoying auto-popup after certain characters like "{"
		-- Note: I have left this function here, but I am not using it in the enabled()
		-- block below because it breaks <C-Space> usage.
		local should_disable_cmp_here = function()
			local col = vim.fn.col(".") - 1
			if col <= 0 then
				return false
			end
			local line = vim.fn.getline(".")
			local prev = line:sub(col, col)
			return prev:match("[%{%}%(%);,%[%]]") ~= nil
		end

		cmp.setup({
			-- ✅ keep suggestions while typing words
			completion = {
				completeopt = "menu,menuone",
				autocomplete = { cmp.TriggerEvent.TextChanged },
			},

			-- ✅ stop cmp from showing up in comments
			enabled = function()
				local context = require("cmp.config.context")

				-- Disable in comments
				if context.in_treesitter_capture("comment") or context.in_syntax_group("Comment") then
					return false
				end

				-- ⚠️ FIXED: I commented this out.
				-- If active, this logic completely turns off the plugin near brackets,
				-- meaning <C-Space> would be ignored.
				-- if should_disable_cmp_here() then
				-- 	return false
				-- end

				return true
			end,

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
				["<C-i>"] = cmp.mapping.complete(),

				["<C-e>"] = cmp.mapping.abort(),

				-- ✅ Enter always confirms
				["<CR>"] = cmp.mapping.confirm({ select = true }),

			}),

			-- Sources
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "path" },
				{ name = "buffer", keyword_length = 3, max_item_count = 50 },
			}),

			-- 🎨 Formatting
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

					item.menu = string.format("[%s]", source)
					return item
				end,
			},

			performance = {
				debounce = 60,
				throttle = 30,
				fetching_timeout = 200,
			},

			experimental = {
				ghost_text = true,
			},
		})
	end,
}
