local gh = require("config.pack").gh
vim.pack.add({ gh("folke/snacks.nvim"), gh("nvim-tree/nvim-web-devicons") })

require("snacks").setup({
  bigfile = { enabled = true },
  quickfile = { enabled = true },
  notifier = { enabled = true, timeout = 3000 },
  input = { enabled = true },
  picker = {
    enabled = true,
    ui_select = true,
    sources = {
      files = { hidden = true },
      grep = { hidden = true },
      explorer = { enabled = false },
    },
  },
  words = { enabled = true }, -- ]r / [r
  lazygit = { enabled = true },
  terminal = { enabled = true },
  statuscolumn = { enabled = true, folds = { open = false } },
  scope = { enabled = true },
  indent = { enabled = false }, -- editor.guides.indentation = false
  scroll = { enabled = false },
  dashboard = {
    enabled = true,
    preset = {
      keys = {
        { icon = "\u{f002} ", key = "f", desc = "Find File", action = ":lua Snacks.picker.files()" },
        { icon = "\u{f15b} ", key = "n", desc = "New File", action = ":ene | startinsert" },
        { icon = "\u{f0b0} ", key = "g", desc = "Find Text", action = ":lua Snacks.picker.grep()" },
        { icon = "\u{f017} ", key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent()" },
        { icon = "\u{f0c7} ", key = "s", desc = "Restore Session", section = "session" },
        {
          icon = "\u{f013} ",
          key = "c",
          desc = "Config",
          action = ":lua Snacks.picker.files({ cwd = vim.fn.stdpath('config') })",
        },
        { icon = "\u{f021} ", key = "u", desc = "Update Plugins", action = ":PackUpdate" },
        { icon = "\u{f08b} ", key = "q", desc = "Quit", action = ":qa" },
      },
    },
    sections = {
      { section = "header" },
      { section = "keys", gap = 1, padding = 1 },
      { icon = "\u{f017} ", title = "Recent Files", section = "recent_files", cwd = true, indent = 2, padding = 1 },
    },
  },
})

local map = vim.keymap.set
local P = function(name, opts)
  return function()
    Snacks.picker[name](opts)
  end
end

-- Find (Cursor: quickOpen, findInFiles, showAllEditors)
map("n", "<C-p>", P("files"), { desc = "Find files" })
map("n", "<leader>ff", P("files"), { desc = "Find files" })
map("n", "<leader><space>", P("smart"), { desc = "Smart find" })
map("n", "<leader>fr", P("recent"), { desc = "Recent files" })
map("n", "<leader>fc", P("files", { cwd = vim.fn.stdpath("config") }), { desc = "Config files" })
map("n", "<leader>fg", P("git_files"), { desc = "Git files" })
map("n", "<leader>,", P("buffers"), { desc = "Buffers" })
map("n", "<leader>/", P("grep"), { desc = "Grep" })

-- Search
map("n", "<leader>sg", P("grep"), { desc = "Grep" })
map({ "n", "x" }, "<leader>sw", P("grep_word"), { desc = "Grep word / selection" })
map("n", "<leader>sb", P("lines"), { desc = "Buffer lines" })
map("n", "<leader>sh", P("help"), { desc = "Help" })
map("n", "<leader>sk", P("keymaps"), { desc = "Keymaps" })
map("n", "<leader>sc", P("commands"), { desc = "Commands" })
map("n", "<leader>sd", P("diagnostics"), { desc = "Diagnostics" })
map("n", "<leader>sD", P("diagnostics_buffer"), { desc = "Buffer diagnostics" })
map("n", "<leader>ss", P("lsp_symbols"), { desc = "Document symbols" })
map("n", "<leader>sS", P("lsp_workspace_symbols"), { desc = "Workspace symbols" })
map("n", "<leader>sm", P("marks"), { desc = "Marks" })
map("n", "<leader>su", P("undo"), { desc = "Undo history" })
map("n", "<leader>sq", P("qflist"), { desc = "Quickfix" })
map("n", "<leader>s:", P("command_history"), { desc = "Command history" })
map("n", '<leader>s"', P("registers"), { desc = "Registers" })
map("n", "<leader>sp", P("resume"), { desc = "Resume last picker" })
map("n", "<leader>uC", P("colorschemes"), { desc = "Colorschemes" })

-- Git / GitHub (Cursor: SCM view, PRs, issues)
map("n", "<leader>gg", function()
  Snacks.lazygit()
end, { desc = "Lazygit" })
map("n", "<leader>gs", P("git_status"), { desc = "Git status" })
map("n", "<leader>gb", P("git_branches"), { desc = "Git branches" })
map("n", "<leader>gl", P("git_log"), { desc = "Git log" })
map("n", "<leader>gL", P("git_log_file"), { desc = "Git log (file)" })
map({ "n", "x" }, "<leader>gB", function()
  Snacks.gitbrowse()
end, { desc = "Open in browser" })
map("n", "<leader>gp", P("gh_pr"), { desc = "GitHub PRs (open)" })
map("n", "<leader>gP", P("gh_pr", { state = "all" }), { desc = "GitHub PRs (all)" })
map("n", "<leader>gi", P("gh_issue"), { desc = "GitHub issues (open)" })
map("n", "<leader>gI", P("gh_issue", { state = "all" }), { desc = "GitHub issues (all)" })

-- Terminal (Cursor: ctrl+\ toggles terminal)
map({ "n", "t" }, "<C-\\>", function()
  Snacks.terminal.toggle()
end, { desc = "Toggle terminal" })
map("n", "<leader>tt", function()
  Snacks.terminal.toggle()
end, { desc = "Toggle terminal" })
map("n", "<leader>tl", function()
  Snacks.terminal.open()
end, { desc = "New terminal" })

-- References (Cursor: ]r / [r)
map("n", "]r", function()
  Snacks.words.jump(vim.v.count1)
end, { desc = "Next reference" })
map("n", "[r", function()
  Snacks.words.jump(-vim.v.count1)
end, { desc = "Prev reference" })

-- Notifications / scratch
map("n", "<leader>un", function()
  Snacks.notifier.hide()
end, { desc = "Dismiss notifications" })
map("n", "<leader>nh", function()
  Snacks.notifier.show_history()
end, { desc = "Notification history" })
map("n", "<leader>S", function()
  Snacks.scratch()
end, { desc = "Scratch buffer" })
map("n", "<leader>z", function()
  Snacks.zen()
end, { desc = "Zen mode" })

-- Toggles
Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
Snacks.toggle.option("relativenumber", { name = "Relative number" }):map("<leader>uL")
Snacks.toggle.diagnostics():map("<leader>ud")
Snacks.toggle.inlay_hints():map("<leader>uh")
Snacks.toggle.treesitter():map("<leader>uT")
Snacks.toggle.dim():map("<leader>uD")
