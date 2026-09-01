return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  lazy = false,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      transparent_background = true,
      integrations = {
        blink_cmp = {
          style = "bordered",
        },
        fidget = true,
        flash = true,
        gitsigns = true,
        grug_far = true,
        lsp_trouble = true,
        mason = true,
        native_lsp = { enabled = true },
        nvim_surround = true,
        snacks = {
          enabled = true,
        },
        treesitter = true,
        which_key = true,
      },
    })

    vim.cmd.colorscheme("catppuccin-mocha")
  end,
}
