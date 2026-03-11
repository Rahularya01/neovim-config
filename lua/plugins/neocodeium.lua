return {
	"monkoose/neocodeium",
	event = "VeryLazy",
	dependencies = { "saghen/blink.cmp" },
	config = function()
		local ok_blink, blink = pcall(require, "blink.cmp")
		local neocodeium = require("neocodeium")

		neocodeium.setup({
			filter = function()
				return not ok_blink or not blink.is_visible()
			end,
		})

		vim.api.nvim_create_autocmd("User", {
			group = vim.api.nvim_create_augroup("NeoCodeiumBlinkCmp", { clear = true }),
			pattern = "BlinkCmpMenuOpen",
			callback = function()
				neocodeium.clear()
			end,
		})

		vim.keymap.set("i", "<Tab>", neocodeium.accept, { desc = "Accept suggestion" })
		vim.keymap.set("i", "<M-]>", neocodeium.cycle_or_complete, { desc = "Next suggestion" })
		vim.keymap.set("i", "<M-[>", function()
			neocodeium.cycle_or_complete(-1)
		end, { desc = "Prev suggestion" })
		vim.keymap.set("i", "<M-c>", neocodeium.clear, { desc = "Clear suggestion" })
	end,
}
