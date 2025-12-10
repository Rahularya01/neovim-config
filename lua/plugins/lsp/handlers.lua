local M = {}

local ok, blink = pcall(require, "blink.cmp")
if ok then
	M.capabilities = blink.get_lsp_capabilities()
else
	M.capabilities = vim.lsp.protocol.make_client_capabilities()
end

function M.setup()
	local signs = {
		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn", text = "" },
		{ name = "DiagnosticSignHint", text = "" },
		{ name = "DiagnosticSignInfo", text = "" },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	local config = {
		virtual_text = true,
		signs = {
			active = signs,
		},
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = false,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	}

	vim.diagnostic.config(config)
end

function M.on_attach(client, bufnr)
	local map = function(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
	end

	-- Prefer external formatters (Conform/null-ls) to avoid conflicts with LSP defaults.
	local disable_format = {
		tsserver = true,
		ts_ls = true,
		lua_ls = true,
		pyright = true,
		clangd = true,
		rust_analyzer = true,
	}

	if disable_format[client.name] then
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end

	map("n", "K", vim.lsp.buf.hover, "Hover")
	map("n", "gd", vim.lsp.buf.definition, "Go to definition")
	map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
	map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
	map("n", "gr", vim.lsp.buf.references, "List references")
	map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
	map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
	map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
	map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
	map("n", "<leader>ld", vim.diagnostic.open_float, "Line diagnostics")
end

return M
