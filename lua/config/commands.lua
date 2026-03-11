vim.api.nvim_create_user_command("RemoveComments", function()
	local bufnr = vim.api.nvim_get_current_buf()
	local ft = vim.bo[bufnr].filetype

	local ok_ts, _ = pcall(require, "nvim-treesitter")
	if not ok_ts then
		vim.notify("RemoveComments: Treesitter is not installed", vim.log.levels.WARN)
		return
	end

	local ok_parser, parser = pcall(vim.treesitter.get_parser, bufnr)
	if not ok_parser or not parser then
		vim.notify("RemoveComments: no Treesitter parser for current buffer", vim.log.levels.WARN)
		return
	end

	local ok_tree, tree = pcall(function()
		return parser:parse()[1]
	end)

	if not ok_tree or not tree then
		vim.notify(("RemoveComments: failed to parse buffer for filetype '%s'"):format(ft), vim.log.levels.WARN)
		return
	end

	local ok_query, query = pcall(
		vim.treesitter.query.parse,
		parser:lang(),
		[[
		(comment) @comment
	]]
	)

	if not ok_query or not query then
		vim.notify(("RemoveComments: could not build query for '%s'"):format(parser:lang()), vim.log.levels.WARN)
		return
	end

	local root = tree:root()
	local ranges = {}

	local function node_text(node)
		return vim.treesitter.get_node_text(node, bufnr) or ""
	end

	local function is_jsx_comment_wrapper(parent, child)
		if not parent then
			return false
		end

		local parent_type = parent:type()
		if parent_type ~= "jsx_expression" and parent_type ~= "jsx_expression_container" then
			return false
		end

		local text = node_text(parent)
		local trimmed = vim.trim(text)

		if trimmed:match("^%{%s*/%*.*%*/%s*%}$") then
			return true
		end

		return false
	end

	for _, node in query:iter_captures(root, bufnr, 0, -1) do
		local target = node
		local parent = node:parent()

		if is_jsx_comment_wrapper(parent, node) then
			target = parent
		end

		local sr, sc, er, ec = target:range()
		ranges[#ranges + 1] = { sr, sc, er, ec }
	end

	if #ranges == 0 then
		vim.notify(("RemoveComments: no comments found for filetype '%s'"):format(ft), vim.log.levels.INFO)
		return
	end

	table.sort(ranges, function(a, b)
		if a[1] ~= b[1] then
			return a[1] > b[1]
		end
		return a[2] > b[2]
	end)

	local deduped = {}
	local seen = {}

	for _, r in ipairs(ranges) do
		local key = table.concat(r, ":")
		if not seen[key] then
			seen[key] = true
			deduped[#deduped + 1] = r
		end
	end

	local view = vim.fn.winsaveview()

	for _, r in ipairs(deduped) do
		vim.api.nvim_buf_set_text(bufnr, r[1], r[2], r[3], r[4], { "" })
	end

	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	local cleaned = {}
	local prev_blank = false

	for _, line in ipairs(lines) do
		local is_blank = line:match("^%s*$") ~= nil
		if not (is_blank and prev_blank) then
			cleaned[#cleaned + 1] = line
		end
		prev_blank = is_blank
	end

	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, cleaned)
	vim.fn.winrestview(view)

	vim.notify(("RemoveComments: removed %d comment node(s)"):format(#deduped), vim.log.levels.INFO)
end, {
	desc = "Remove Treesitter comment nodes from current buffer",
})
