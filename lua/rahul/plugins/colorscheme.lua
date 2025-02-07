return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",             -- Set the theme flavor
        transparent_background = true, -- Enable transparency if needed
      })
      -- Load the colorscheme
      vim.cmd([[colorscheme catppuccin]])
    end,
  },
}

