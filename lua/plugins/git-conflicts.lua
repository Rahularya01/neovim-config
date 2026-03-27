return {
	"sindrets/diffview.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local actions = require("diffview.actions")
		require("diffview").setup({
			keymaps = {
				file_panel = {
					{ "n", "co", actions.conflict_choose("ours"), { desc = "Choose ours" } },
					{ "n", "ct", actions.conflict_choose("theirs"), { desc = "Choose theirs" } },
					{ "n", "cb", actions.conflict_choose("all"), { desc = "Choose both" } },
					{ "n", "c0", actions.conflict_choose("none"), { desc = "Choose none" } },
					{ "n", "[x", actions.prev_conflict, { desc = "Previous conflict" } },
					{ "n", "]x", actions.next_conflict, { desc = "Next conflict" } },
				},
				view = {
					{ "n", "co", actions.conflict_choose("ours"), { desc = "Choose ours" } },
					{ "n", "ct", actions.conflict_choose("theirs"), { desc = "Choose theirs" } },
					{ "n", "cb", actions.conflict_choose("all"), { desc = "Choose both" } },
					{ "n", "c0", actions.conflict_choose("none"), { desc = "Choose none" } },
					{ "n", "[x", actions.prev_conflict, { desc = "Previous conflict" } },
					{ "n", "]x", actions.next_conflict, { desc = "Next conflict" } },
				},
			},
		})
	end,
	keys = {
		{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
		{ "<leader>gc", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
		{ "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview File History" },
	},
}
