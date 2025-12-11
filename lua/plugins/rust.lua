return {
	"mrcjkb/rustaceanvim",
	version = "^5",
	ft = { "rust" },
	config = function()
		local handlers = require("plugins.lsp.handlers")

		vim.g.rustaceanvim = {
			-- Plugin configuration
			tools = {},
			-- LSP configuration
			server = {
				default_settings = {
					-- rust-analyzer language server configuration
					["rust-analyzer"] = {
						cargo = { allFeatures = true },
						check = { command = "clippy" },
					},
				},
				-- Hook blink.cmp capabilities to LSP
				capabilities = handlers.capabilities,
			},
		}
	end,
}
