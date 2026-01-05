return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")
		local linters_by_ft = {
			python = { "pylint" },
			lua = { "luacheck" },
			go = { "golangci-lint" },
		}
		if vim.fn.executable("golangci-lint") == 0 then
			linters_by_ft.go = nil
		end
		lint.linters_by_ft = linters_by_ft
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
