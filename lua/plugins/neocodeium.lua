return {
	"monkoose/neocodeium",
	event = "VeryLazy",
	config = function()
		local neocodeium = require("neocodeium")
		neocodeium.setup()
		vim.keymap.set("i", "<Tab>", neocodeium.accept, { desc = "Accept suggestion" })
		vim.keymap.set("i", "<M-]>", neocodeium.cycle_or_complete, { desc = "Next suggestion" })
		vim.keymap.set("i", "<M-[>", function()
			neocodeium.cycle_or_complete(-1)
		end, { desc = "Prev suggestion" })
		vim.keymap.set("i", "<M-c>", neocodeium.clear, { desc = "Clear suggestion" })
	end,
}
