return {
	"overleaf/vim-env-syntax",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		-- Optional: Associate specific patterns with the .env filetype
		vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
			pattern = { ".env", ".env.*", "*.env" },
			callback = function()
				vim.bo.filetype = "env"
			end,
		})
	end,
}
