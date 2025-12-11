local function in_suppress_dir()
	local suppress_dirs = { "~", "~/Downloads", "~/Documents", "~/Desktop", "/" }
	local cwd = vim.loop.cwd()

	for _, dir in ipairs(suppress_dirs) do
		if cwd == vim.fn.expand(dir) then
			return true
		end
	end

	return false
end

return {
	"folke/persistence.nvim",
	event = "BufReadPre",
	opts = {
		options = { "buffers", "curdir", "tabpages", "winsize" },
		pre_save = function()
			return not in_suppress_dir()
		end,
	},
	keys = {
		{
			"<leader>qs",
			function()
				require("persistence").load()
			end,
			desc = "Restore session for cwd",
		},
		{
			"<leader>ql",
			function()
				require("persistence").load({ last = true })
			end,
			desc = "Restore previous session",
		},
		{
			"<leader>qS",
			function()
				require("persistence").select()
			end,
			desc = "Select session",
		},
		{
			"<leader>qd",
			function()
				require("persistence").stop()
			end,
			desc = "Stop tracking session",
		},
	},
	config = function(_, opts)
		local persistence = require("persistence")
		persistence.setup(opts)

		-- Auto-load the last session when starting without arguments
		if vim.fn.argc(-1) == 0 and not vim.g.started_by_firenvim and not in_suppress_dir() then
			persistence.load()
		end
	end,
}
