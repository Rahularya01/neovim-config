return {
	"NickvanDyke/opencode.nvim",
	dependencies = {
		{ "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
	},
	event = "VeryLazy",
	config = function()
		local opencode = require("opencode")

		vim.o.autoread = true

		vim.keymap.set("n", "<leader>ac", function()
			opencode.toggle()
		end, { desc = "Toggle Opencode" })

		vim.keymap.set("n", "<leader>an", function()
			opencode.command("session.new")
		end, { desc = "Start New Opencode Session" })

		vim.keymap.set({ "n", "x" }, "<C-a>", function()
			opencode.ask("@buffer: ", { submit = false })
		end, { desc = "Ask Opencode about buffer" })

		vim.keymap.set("n", "<leader>as", function()
			opencode.select()
		end, { desc = "Select Opencode Action" })

		vim.keymap.set({ "n", "x" }, "go", function()
			return opencode.operator("@this ")
		end, { expr = true, desc = "Add range to opencode" })

		vim.keymap.set("n", "goo", function()
			return opencode.operator("@this ") .. "_"
		end, { expr = true, desc = "Add line to opencode" })

		vim.keymap.set("n", "<S-C-u>", function()
			opencode.command("session.half.page.up")
		end, { desc = "Scroll AI Up" })
		vim.keymap.set("n", "<S-C-d>", function()
			opencode.command("session.half.page.down")
		end, { desc = "Scroll AI Down" })

		vim.keymap.set("n", "+", "<C-a>", { desc = "Increment Number", noremap = true })
		vim.keymap.set("n", "_", "<C-x>", { desc = "Decrement Number", noremap = true })
	end,
}
