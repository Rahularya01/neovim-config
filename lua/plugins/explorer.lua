local gh = require("config.pack").gh
vim.pack.add({
  { src = gh("nvim-neo-tree/neo-tree.nvim"), version = vim.version.range("3.*") },
  gh("MunifTanjim/nui.nvim"),
  gh("stevearc/oil.nvim"),
})

-- Sidebar explorer (Cursor: explorer + a/A/d/r/y/x/p/l/h keys) -------------------
require("neo-tree").setup({
  close_if_last_window = true,
  popup_border_style = "rounded",
  enable_git_status = true,
  enable_diagnostics = false, -- explorer.decorations.* = false
  default_component_configs = {
    indent = { indent_size = 2, with_markers = false, with_expanders = true }, -- no indent guides
    git_status = { symbols = { unstaged = "M", staged = "S", untracked = "U", ignored = "◌" } },
  },
  window = {
    width = 32,
    mappings = {
      ["l"] = "open",
      ["h"] = "close_node",
      ["<space>"] = "none",
      ["a"] = { "add", config = { show_path = "relative" } },
      ["A"] = "add_directory",
      ["d"] = "delete",
      ["r"] = "rename",
      ["y"] = "copy_to_clipboard",
      ["x"] = "cut_to_clipboard",
      ["p"] = "paste_from_clipboard",
      ["Y"] = {
        function(state)
          local path = state.tree:get_node():get_id()
          vim.fn.setreg("+", path)
          vim.notify("Copied: " .. path)
        end,
        desc = "Copy path",
      },
      ["P"] = { "toggle_preview", config = { use_float = true } },
    },
  },
  filesystem = {
    bind_to_cwd = false,
    follow_current_file = { enabled = true },
    use_libuv_file_watcher = true,
    group_empty_dirs = false, -- explorer.compactFolders = false
    filtered_items = {
      visible = false,
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_by_name = { ".DS_Store", ".git" },
      never_show = { ".DS_Store" },
    },
  },
})
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle reveal_force_cwd<cr>", { desc = "Explorer" })
vim.keymap.set("n", "<leader>O", "<cmd>Neotree reveal<cr>", { desc = "Reveal file in explorer" })
vim.keymap.set("n", "<leader>ge", "<cmd>Neotree float git_status<cr>", { desc = "Git explorer" })

-- Edit the filesystem like a buffer -----------------------------------------------
require("oil").setup({
  default_file_explorer = false, -- neo-tree handles directories
  view_options = { show_hidden = true },
  float = { padding = 4, max_width = 100, border = "rounded" },
  keymaps = { ["q"] = "actions.close", ["<C-h>"] = false, ["<C-l>"] = false },
})
vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Oil (parent dir)" })
vim.keymap.set("n", "<leader>E", function()
  require("oil").toggle_float()
end, { desc = "Oil float" })

-- `nvim .` — this module loads after startup, so check the initial buffer.
local start = vim.api.nvim_buf_get_name(0)
if start ~= "" and vim.fn.isdirectory(start) == 1 then
  vim.cmd("Neotree current dir=" .. vim.fn.fnameescape(start))
end
