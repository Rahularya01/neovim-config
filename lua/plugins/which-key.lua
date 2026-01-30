return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    -- Register key groups
    wk.register({
      ["<leader>b"] = { name = "+buffer", desc = "Buffer" },
      ["<leader>c"] = { name = "+code", desc = "Code/LSP" },
      ["<leader>d"] = { name = "+debug", desc = "Debug" },
      ["<leader>f"] = { name = "+find/files", desc = "Find" },
      ["<leader>g"] = { name = "+git", desc = "Git" },
      ["<leader>l"] = { name = "+lsp", desc = "LSP" },
      ["<leader>s"] = { name = "+search", desc = "Search" },
      ["<leader>u"] = { name = "+ui/toggles", desc = "UI" },
      ["<leader>w"] = { name = "+workspace/session", desc = "Workspace" },
      ["<leader>x"] = { name = "+diagnostics/trouble", desc = "Diagnostics" },
    }, { mode = { "n", "v" } })
  end,
  opts = {
    plugins = {
      marks = true,
      registers = true,
      spelling = {
        enabled = true,
        suggestions = 20,
      },
      presets = {
        operators = true,
        motions = true,
        text_objects = true,
        windows = true,
        nav = true,
        z = true,
        g = true,
      },
    },
    win = {
      border = "rounded",
      padding = { 2, 2 },
    },
  },
}