local platform = require("config.platform")

return {
  "nvim-tree/nvim-tree.lua",
  cond = platform.not_vscode,
  cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file explorer (sidebar)" },
    { "<leader>E", "<cmd>NvimTreeFindFile<cr>", desc = "Reveal current file in explorer" },
  },
  opts = {
    on_attach = function(bufnr)
      local api = require("nvim-tree.api")
      api.config.mappings.default_on_attach(bufnr)

      local function map(key, action, desc)
        vim.keymap.set("n", key, action, { desc = "nvim-tree: " .. desc, buffer = bufnr, silent = true, nowait = true })
      end

      -- vim-motion-style navigation: l/h expand/collapse instead of the
      -- default <CR>-only open (j/k already move the cursor, no rebind needed)
      map("l", api.node.open.edit, "Open file/expand directory")
      map("h", api.node.navigate.parent_close, "Collapse directory")
      map("/", api.live_filter.start, "Filter/search tree")
      -- r (rename) and d (delete) are already nvim-tree's defaults.
    end,
    view = {
      width = 32,
      side = "left",
    },
    renderer = {
      group_empty = true,
      highlight_git = true,
      indent_markers = { enable = true },
      icons = {
        show = {
          git = true,
          diagnostics = true,
          folder_arrow = true,
        },
      },
    },
    diagnostics = {
      enable = true,
      show_on_dirs = true,
    },
    git = {
      enable = true,
      ignore = false,
    },
    filters = {
      dotfiles = false,
    },
    actions = {
      open_file = {
        quit_on_open = false,
      },
    },
    update_focused_file = {
      enable = true,
    },
  },
}
