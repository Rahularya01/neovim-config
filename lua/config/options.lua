local opt = vim.opt
local g = vim.g

-- Performance optimizations (disabled plugins are handled in init.lua via lazy.nvim)
g.have_nerd_font = true

-- UI
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
opt.laststatus = 3 -- Global statusline

-- Editing
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true
opt.completeopt = "menu,menuone,noselect"

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Files
opt.undofile = true
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.autoread = true

-- Performance
opt.updatetime = 250 -- Faster CursorHold (was 1000)
opt.timeoutlen = 300 -- Faster key sequence completion (was 500)
opt.redrawtime = 1500 -- Max time for syntax highlighting
opt.synmaxcol = 240 -- Max column for syntax highlight

-- Folding (using ufo, so disable builtin)
opt.foldenable = true
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldcolumn = "0"

-- List characters (show whitespace)
opt.list = false -- Enable with :set list
opt.listchars = {
	tab = "▸ ",
	trail = "·",
	extends = "…",
	precedes = "…",
	nbsp = "␣",
}

-- Conceal (for markdown, json, etc.)
opt.conceallevel = 0 -- 0=off, 1=one char, 2=hide, 3=hide and cursorline

-- Virtual edit for better visual block mode
opt.virtualedit = "block"

-- Spell checking
opt.spell = false -- Enable with :set spell
opt.spelllang = { "en_us" }
opt.spelloptions = { "camel" } -- Treat camelCase as separate words

-- Auto-reload files changed outside vim
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = vim.api.nvim_create_augroup("checktime", { clear = true }),
	callback = function()
		if vim.o.buftype ~= "nofile" then
			vim.cmd("checktime")
		end
	end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ timeout = 200 })
	end,
})

-- Resize splits on window resize
vim.api.nvim_create_autocmd("VimResized", {
	group = vim.api.nvim_create_augroup("resize_splits", { clear = true }),
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})
