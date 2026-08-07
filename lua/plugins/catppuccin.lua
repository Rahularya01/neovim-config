return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  event = "VimEnter",
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      transparent_background = true,
      integrations = {
        cmp = true,
        gitsigns = true,
        native_lsp = { enabled = true },
        telescope = { enabled = true },
        treesitter = true,
        which_key = true,
      },
    })

    vim.cmd.colorscheme("catppuccin-mocha")
  end,
}
