-- Enhanced Neovim Options Configuration

-- File browser settings
vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 0 -- Hide banner
vim.g.netrw_browse_split = 0 -- Open files in current window
vim.g.netrw_winsize = 25 -- Set explorer width to 25%

-- UI Settings
local opt = vim.opt
opt.number = true -- Show line numbers
opt.relativenumber = true -- Show relative line numbers
opt.cursorline = true -- Highlight current line
opt.showmatch = true -- Highlight matching brackets
opt.termguicolors = true -- True color support
opt.background = "dark" -- Dark background
opt.signcolumn = "yes" -- Always show sign column
opt.colorcolumn = "80" -- Highlight column 80
opt.scrolloff = 8 -- Keep 8 lines above/below cursor when scrolling
opt.conceallevel = 0 -- Show text normally
opt.showmode = false -- Don't show mode (use statusline instead)
opt.laststatus = 3 -- Global statusline
opt.title = true -- Set window title to filename
opt.list = true -- Show invisible characters
opt.listchars = { -- Custom symbols for invisible characters
	tab = "» ",
	trail = "·",
	extends = "›",
	precedes = "‹",
	nbsp = "␣",
}

-- Editor Settings
opt.tabstop = 2 -- 2 spaces for tabs
opt.softtabstop = 2 -- 2 spaces when pressing tab
opt.shiftwidth = 2 -- 2 spaces for indentation
opt.expandtab = true -- Use spaces instead of tabs
opt.smartindent = true -- Smart indentation
opt.autoindent = true -- Automatically indent new lines
opt.wrap = false -- No line wrapping
opt.linebreak = true -- Break lines at word boundaries (when wrap is on)
opt.breakindent = true -- Preserve indentation in wrapped lines
opt.formatoptions = "jcroqlnt" -- Formatting options

-- Search Settings
opt.ignorecase = true -- Ignore case in search
opt.smartcase = true -- Case sensitive if uppercase is used
opt.hlsearch = true -- Highlight search results
opt.incsearch = true -- Incremental search

-- System Settings
opt.clipboard:append("unnamedplus") -- Use system clipboard
opt.mouse = "a" -- Enable mouse in all modes
opt.updatetime = 250 -- Faster updates
opt.timeoutlen = 300 -- Time to wait for mapped sequence
opt.backup = false -- No backup files
opt.swapfile = false -- No swap files
opt.undofile = true -- Persistent undo history
opt.undodir = vim.fn.stdpath("data") .. "/undodir" -- Undo directory
opt.hidden = true -- Allow unsaved buffers in background
opt.backspace = "indent,eol,start" -- Modern backspace behavior

-- Window Settings
opt.splitright = true -- Split windows to the right
opt.splitbelow = true -- Split windows below
opt.pumheight = 10 -- Limit popup menu height
opt.shortmess:append("c") -- Don't pass messages to completion menu

-- Performance Settings
opt.lazyredraw = true -- Don't redraw during macros
opt.synmaxcol = 240 -- Only highlight 240 columns

-- Horizontal scrolling
opt.sidescroll = 1 -- Minimum horizontal scroll step
opt.sidescrolloff = 8 -- Keep context when scrolling horizontally

-- Bind Shift + Scroll Wheel to horizontal scrolling (with more modes covered)
vim.cmd([[
  nnoremap <ScrollWheelLeft>      zh
  nnoremap <ScrollWheelRight>     zl
  inoremap <ScrollWheelLeft>      <C-o>zh
  inoremap <ScrollWheelRight>     <C-o>zl
  vnoremap <ScrollWheelLeft>      zh
  vnoremap <ScrollWheelRight>     zl
  snoremap <ScrollWheelLeft>      <C-o>zh
  snoremap <ScrollWheelRight>     <C-o>zl
  xnoremap <ScrollWheelLeft>      zh
  xnoremap <ScrollWheelRight>     zl
]])

-- Basic keymaps for convenience
vim.g.mapleader = " " -- Set leader key to space
vim.keymap.set("n", "<Esc>", ":nohl<CR>", { silent = true }) -- Clear search highlight with Esc
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" }) -- Quick save with leader+w
vim.keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save file" }) -- Save with Ctrl+S

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Navigate to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Navigate to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Navigate to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Navigate to right window" })

-- Resize with arrows
vim.keymap.set("n", "<C-Up>", ":resize -2<CR>", { silent = true, desc = "Decrease window height" })
vim.keymap.set("n", "<C-Down>", ":resize +2<CR>", { silent = true, desc = "Increase window height" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { silent = true, desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { silent = true, desc = "Increase window width" })

-- Stay in visual mode when indenting
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and stay in visual mode" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and stay in visual mode" })

-- Move text up and down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected text down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected text up" })

-- File browser toggle
vim.keymap.set("n", "<leader>e", ":Explore<CR>", { desc = "Open file explorer" })
