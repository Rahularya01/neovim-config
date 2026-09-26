local gh = require("config.pack").gh
vim.pack.add({
  gh("nvim-lualine/lualine.nvim"),
  gh("akinsho/bufferline.nvim"),
  gh("folke/which-key.nvim"),
  gh("rachartier/tiny-inline-diagnostic.nvim"),
  gh("folke/todo-comments.nvim"),
  gh("nvim-lua/plenary.nvim"),
})

-- Statusline -----------------------------------------------------------------
local function lsp_clients()
  local names = vim
    .iter(vim.lsp.get_clients({ bufnr = 0 }))
    :map(function(c)
      return c.name
    end)
    :filter(function(n)
      return n ~= "copilot"
    end)
    :totable()
  return #names > 0 and ("\u{f0ad} " .. table.concat(names, ", ")) or ""
end

-- Transparent middle section so the terminal background shows through.
local lualine_theme = require("lualine.themes.catppuccin-mocha")
for _, mode in pairs(lualine_theme) do
  if mode.c then
    mode.c.bg = "NONE"
  end
end

require("lualine").setup({
  options = {
    theme = lualine_theme,
    globalstatus = true,
    component_separators = "",
    section_separators = { left = "\u{e0b4}", right = "\u{e0b6}" },
    disabled_filetypes = { statusline = { "snacks_dashboard" } },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff" },
    lualine_c = {
      { "diagnostics", symbols = { error = "\u{f057} ", warn = "\u{f071} ", info = "\u{f05a} ", hint = "\u{f0eb} " } },
      { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
      { "filename", path = 1, symbols = { modified = " ●", readonly = " \u{f023}" } },
    },
    lualine_x = {
      { lsp_clients },
      {
        function()
          return "\u{f4b8}"
        end,
        cond = function()
          return #vim.lsp.get_clients({ bufnr = 0, name = "copilot" }) > 0
        end,
      },
      "encoding",
    },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  extensions = { "neo-tree", "oil", "trouble", "quickfix", "man" },
})

-- Tabs (Cursor editor tabs) ---------------------------------------------------
local ok_hl, cat_bl = pcall(require, "catppuccin.special.bufferline")
if not ok_hl then
  ok_hl, cat_bl = pcall(require, "catppuccin.groups.integrations.bufferline")
end
require("bufferline").setup({
  highlights = ok_hl and (cat_bl.get_theme or cat_bl.get)() or nil,
  options = {
    close_command = function(n)
      Snacks.bufdelete(n)
    end,
    right_mouse_command = function(n)
      Snacks.bufdelete(n)
    end,
    diagnostics = "nvim_lsp",
    always_show_bufferline = false,
    show_buffer_close_icons = true,
    separator_style = "thin",
    offsets = {
      { filetype = "neo-tree", text = "Explorer", highlight = "Directory", text_align = "left", separator = true },
    },
  },
})
vim.keymap.set("n", "<leader>bp", "<cmd>BufferLineTogglePin<cr>", { desc = "Pin buffer" })
vim.keymap.set("n", "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", { desc = "Close buffers left" })
vim.keymap.set("n", "<leader>br", "<cmd>BufferLineCloseRight<cr>", { desc = "Close buffers right" })
vim.keymap.set("n", "<leader>b<", "<cmd>BufferLineMovePrev<cr>", { desc = "Move buffer left" })
vim.keymap.set("n", "<leader>b>", "<cmd>BufferLineMoveNext<cr>", { desc = "Move buffer right" })
for i = 1, 9 do
  vim.keymap.set("n", "<leader>" .. i, "<cmd>BufferLineGoToBuffer " .. i .. "<cr>", { desc = "Buffer " .. i })
end

-- Keymap hints ----------------------------------------------------------------
local wk = require("which-key")
wk.setup({ preset = "helix", delay = 300 })
wk.add({
  { "<leader>a", group = "ai" },
  { "<leader>b", group = "buffer" },
  { "<leader>c", group = "code / conflict" },
  { "<leader>d", group = "debug" },
  { "<leader>f", group = "find" },
  { "<leader>g", group = "git" },
  { "<leader>h", group = "hunks" },
  { "<leader>l", group = "lsp / lazygit" },
  { "<leader>n", group = "notifications" },
  { "<leader>o", group = "organize" },
  { "<leader>p", group = "plugins" },
  { "<leader>r", group = "rename" },
  { "<leader>s", group = "search" },
  { "<leader>t", group = "terminal / toggle" },
  { "<leader>u", group = "ui" },
  { "<leader>w", group = "session" },
  { "<leader>x", group = "diagnostics" },
  { "[", group = "prev" },
  { "]", group = "next" },
  { "g", group = "goto" },
  { "z", group = "fold" },
})
vim.keymap.set("n", "<leader>uu", "<cmd>Undotree<cr>", { desc = "Undo tree" })
vim.keymap.set("n", "<leader>?", function()
  wk.show({ global = false })
end, { desc = "Buffer keymaps" })

-- Diagnostics (Cursor: ErrorLens) ---------------------------------------------
vim.diagnostic.config({
  virtual_text = false, -- rendered by tiny-inline-diagnostic
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "\u{f057} ",
      [vim.diagnostic.severity.WARN] = "\u{f071} ",
      [vim.diagnostic.severity.INFO] = "\u{f05a} ",
      [vim.diagnostic.severity.HINT] = "\u{f0eb} ",
    },
  },
})
require("tiny-inline-diagnostic").setup({
  preset = "modern",
  options = { show_source = { if_many = true }, multilines = { enabled = true }, use_icons_from_diagnostic = true },
})
vim.keymap.set("n", "<leader>uc", function()
  require("tiny-inline-diagnostic").toggle()
end, { desc = "Toggle inline diagnostics" })

-- TODO / FIXME ----------------------------------------------------------------
require("todo-comments").setup({ signs = false })
vim.keymap.set("n", "]t", function()
  require("todo-comments").jump_next()
end, { desc = "Next todo" })
vim.keymap.set("n", "[t", function()
  require("todo-comments").jump_prev()
end, { desc = "Prev todo" })
vim.keymap.set("n", "<leader>st", function()
  Snacks.picker.todo_comments()
end, { desc = "Todos" })
vim.keymap.set("n", "<leader>sT", function()
  Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
end, { desc = "Todo / Fix / Fixme" })
