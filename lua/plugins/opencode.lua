return {
	"NickvanDyke/opencode.nvim",
	dependencies = {
		{ "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
	},
	event = "VeryLazy",
	keys = {
		{ "<leader>ac", desc = "Open/Toggle opencode" },
	},
	config = function()
		local opencode = require("opencode")

		-- Initialize opencode if setup is available
		if opencode.setup then
			opencode.setup({})
		end

		vim.g.opencode_opts = {}

		vim.o.autoread = true

		-- Leader keybinding to open/toggle opencode
		vim.keymap.set("n", "<leader>ac", function()
			opencode.toggle()
		end, { desc = "Open/Toggle opencode" })

		vim.keymap.set({ "n", "x" }, "<C-a>", function()
			opencode.ask("@this: ", { submit = true })
		end, { desc = "Ask opencode" })
		vim.keymap.set({ "n", "x" }, "<C-x>", function()
			opencode.select()
		end, { desc = "Execute opencode action…" })
		vim.keymap.set({ "n", "t" }, "<C-.>", function()
			opencode.toggle()
		end, { desc = "Toggle opencode" })

		vim.keymap.set({ "n", "x" }, "go", function()
			return opencode.operator("@this ")
		end, { expr = true, desc = "Add range to opencode" })
		vim.keymap.set("n", "goo", function()
			return opencode.operator("@this ") .. "_"
		end, { expr = true, desc = "Add line to opencode" })

		vim.keymap.set("n", "<S-C-u>", function()
			opencode.command("session.half.page.up")
		end, { desc = "opencode half page up" })
		vim.keymap.set("n", "<S-C-d>", function()
			opencode.command("session.half.page.down")
		end, { desc = "opencode half page down" })

		vim.keymap.set("n", "+", "<C-a>", { desc = "Increment", noremap = true })
		vim.keymap.set("n", "_", "<C-x>", { desc = "Decrement", noremap = true })
	end,
}
