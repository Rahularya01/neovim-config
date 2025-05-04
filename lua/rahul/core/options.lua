vim.cmd("let g:netrw_liststyle = 3")
local opt = vim.opt
opt.relativenumber = true
opt.number = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.wrap = false
opt.ignorecase = true
opt.smartcase = true
opt.cursorline = true
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.backspace = "indent,eol,start"
opt.clipboard:append("unnamedplus")
opt.splitright = true
opt.splitbelow = true
opt.mouse = "a" -- Enable mouse support
-- Enable smooth horizontal scrolling
opt.sidescroll = 1 -- Minimum horizontal scroll step
opt.sidescrolloff = 8 -- Keep context when scrolling
-- Bind Shift + Scroll Wheel to horizontal scrolling
vim.api.nvim_exec(
	[[
  nnoremap <ScrollWheelLeft>  zh
  nnoremap <ScrollWheelRight> zl
  inoremap <ScrollWheelLeft>  <C-o>zh
  inoremap <ScrollWheelRight> <C-o>zl
  vnoremap <ScrollWheelLeft>  zh
  vnoremap <ScrollWheelRight> zl
]],
	false
)
