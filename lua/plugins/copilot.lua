return {
	"github/copilot.vim",
	-- laod immidiately
	event = "InsertEnter",
	cmd = "Copilot",
	config = function()
		vim.api.nvim_set_keymap("i", "<Tab>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
	end,
}
