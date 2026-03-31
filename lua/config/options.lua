local opt = vim.opt
local g = vim.g

g.have_nerd_font = true
g.ai_cmp = true -- enable copilot ghost text + blink source

opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.termguicolors = true
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.splitright = true
opt.splitbelow = true
opt.wrap = false
opt.linebreak = false
opt.cmdheight = 0
opt.showmode = false
opt.laststatus = 3

opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true
opt.completeopt = "menu,menuone,noselect"

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

opt.undofile = true
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.autoread = true

opt.updatetime = 250
opt.timeoutlen = 300
opt.redrawtime = 1500
opt.synmaxcol = 240

opt.foldenable = true
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldcolumn = "0"
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.lsp.foldexpr()"

opt.list = false
opt.listchars = {
	tab = "▸ ",
	trail = "·",
	extends = "…",
	precedes = "…",
	nbsp = "␣",
}

opt.conceallevel = 0

opt.virtualedit = "block"

opt.spell = false
opt.spelllang = { "en_us" }
opt.spelloptions = { "camel" }

vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = vim.api.nvim_create_augroup("checktime", { clear = true }),
	callback = function()
		if vim.o.buftype ~= "nofile" then
			vim.cmd("checktime")
		end
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	callback = function()
		vim.hl.on_yank({ timeout = 200 })
	end,
})

vim.api.nvim_create_autocmd("VimResized", {
	group = vim.api.nvim_create_augroup("resize_splits", { clear = true }),
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})
