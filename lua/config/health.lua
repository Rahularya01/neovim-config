-- Health check configuration
-- Run :checkhealth to see detailed health information

local M = {}

-- Check if required tools are available
function M.check_tools()
	local tools = {
		"git",
		"rg", -- ripgrep for telescope
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

-- Check LSP servers
function M.check_lsp()
	local ok, mason = pcall(require, "mason")
	if ok then
		-- Mason is loaded, servers should be available
		return true
	end
	return false
end

-- Run checks on startup (optional, can be called manually)
function M.setup()
	-- Run tool checks asynchronously to not block startup
	vim.defer_fn(function()
		M.check_tools()
	end, 1000)
end

return M
