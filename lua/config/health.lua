local M = {}

function M.check_tools()
	local tools = {
		"git",
		"rg",
	}

	local missing = {}
	for _, tool in ipairs(tools) do
		if vim.fn.executable(tool) == 0 then
			table.insert(missing, tool)
		end
	end

	if #missing > 0 then
		vim.notify(string.format("Missing recommended tools: %s", table.concat(missing, ", ")), vim.log.levels.WARN)
	end
end

function M.check_lsp()
	local ok, mason = pcall(require, "mason")
	if ok then
		return true
	end
	return false
end

function M.setup()
	vim.defer_fn(function()
		M.check_tools()
	end, 1000)
end

return M
