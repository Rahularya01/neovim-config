local M = {}

-- Configure global diagnostics look and feel
function M.setup()
	local signs = { Error = "E", Warn = "W", Hint = "H", Info = "I" }
	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
	end

	vim.diagnostic.config({
		severity_sort = true,
		float = { border = "rounded" },
		virtual_text = { prefix = "●" },
	})
end

-- Hook blink.cmp capabilities into LSP if available
local ok, blink = pcall(require, "blink.cmp")
if ok then
	M.capabilities = blink.get_lsp_capabilities()
else
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	M.capabilities = capabilities
end

function M.on_attach(client, bufnr)
	vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

	local map = function(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
	end

	map("n", "gd", vim.lsp.buf.definition, "LSP: Go to definition")
	map("n", "gD", vim.lsp.buf.declaration, "LSP: Go to declaration")
	map("n", "gi", vim.lsp.buf.implementation, "LSP: Go to implementation")
	map("n", "gr", vim.lsp.buf.references, "LSP: List references")
	map("n", "K", vim.lsp.buf.hover, "LSP: Hover documentation")
	map("n", "<leader>ls", vim.lsp.buf.signature_help, "LSP: Signature help")
	map("n", "<leader>rn", vim.lsp.buf.rename, "LSP: Rename symbol")
	map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "LSP: Code action")
	map("n", "[d", vim.diagnostic.goto_prev, "LSP: Prev diagnostic")
	map("n", "]d", vim.diagnostic.goto_next, "LSP: Next diagnostic")
	map("n", "gl", vim.diagnostic.open_float, "LSP: Line diagnostics")

	if client.supports_method("textDocument/inlayHint") then
		local ih = vim.lsp.inlay_hint
		if type(ih) == "table" and ih.enable then
			ih.enable(bufnr, true)
		elseif type(ih) == "function" then
			pcall(ih, bufnr, true)
		end
	end
end

return M
