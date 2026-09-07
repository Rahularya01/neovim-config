local platform = require("config.platform")

return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  cond = platform.not_vscode,
  cmd = "Neotree",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<leader>e", "<cmd>Neotree toggle filesystem left<cr>", desc = "Toggle file explorer (sidebar)" },
    { "<leader>E", "<cmd>Neotree reveal_force_cwd filesystem left<cr>", desc = "Reveal current file in explorer" },
  },
  opts = {
    close_if_last_window = false,
    enable_git_status = true,
    enable_diagnostics = true,
    source_selector = {
      winbar = false,
      statusline = false,
    },
    window = {
      position = "left",
      width = 32,
      mappings = {
        ["l"] = "open",
        ["h"] = "close_node",
        ["/"] = "fuzzy_finder",
      },
    },
    filesystem = {
      follow_current_file = {
        enabled = true,
        leave_dirs_open = true,
      },
      use_libuv_file_watcher = true,
      hijack_netrw_behavior = "open_default",
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_hidden = false,
      },
    },
  },
  config = function(_, opts)
    require("neo-tree").setup(opts)

    local function set_transparent_highlights()
      vim.api.nvim_set_hl(0, "NeoTreeNormal", { link = "Normal" })
      vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { link = "NormalNC" })
      vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { link = "EndOfBuffer" })
      vim.api.nvim_set_hl(0, "NeoTreeWinSeparator", { link = "WinSeparator" })
    end

    set_transparent_highlights()
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("NeoTreeTransparentHighlights", { clear = true }),
      callback = set_transparent_highlights,
    })
  end,
}
