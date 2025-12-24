vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.wrap = false
vim.opt.linebreak = false

vim.opt.undofile = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.updatetime = 1000
vim.opt.timeoutlen = 500
vim.opt.cmdheight = 0
vim.opt.lazyredraw = false

vim.opt.completeopt = "menu,menuone,noselect"

vim.o.autoread = true

vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
	command = "if mode() != 'c' | checktime | endif",
	pattern = { "*" },
})
