local opt = vim.opt

-- Editing (Cursor: editor.tabSize = 2, insertSpaces)
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.shiftround = true

-- UI
opt.number = true
opt.relativenumber = true -- editor.lineNumbers = relative
opt.numberwidth = 3
opt.signcolumn = "yes" -- editor.glyphMargin
opt.cursorline = true
opt.scrolloff = 8 -- editor.cursorSurroundingLines = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.showmode = false
opt.laststatus = 3
opt.cmdheight = 0 -- cmdline and messages are drawn by noice.nvim (plugins/ui.lua)
opt.pumheight = 12
opt.winborder = "rounded"
opt.splitright = true
opt.splitbelow = true
opt.splitkeep = "screen"
opt.list = false -- editor.renderWhitespace = selection; toggle with <leader>ul
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣", space = "·" }
opt.fillchars = { eob = " ", fold = " ", foldopen = "▾", foldclose = "▸", foldsep = " " }
opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20" -- cursorBlinking = solid
opt.shortmess:append({ I = true, c = true, W = true })

-- Folding (treesitter); editor.showFoldingControls = never → no foldcolumn
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldtext = ""
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldcolumn = "0"

-- Search (search.smartCase)
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split"
opt.grepprg = "rg --vimgrep --smart-case"

-- Behaviour
opt.clipboard = "unnamedplus" -- vim.useSystemClipboard
opt.mouse = "a"
opt.undofile = true
opt.undolevels = 10000
opt.swapfile = false
opt.autowrite = false -- files.autoSave = off
opt.confirm = true
opt.updatetime = 250
opt.timeoutlen = 400
opt.completeopt = { "menu", "menuone", "noselect", "popup" }
opt.virtualedit = "block"
opt.spelllang = { "en" }
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.jumpoptions = "view"

vim.g.markdown_recommended_style = 0
vim.g.loaded_netrw = 1 -- neo-tree / oil handle directories
vim.g.loaded_netrwPlugin = 1
