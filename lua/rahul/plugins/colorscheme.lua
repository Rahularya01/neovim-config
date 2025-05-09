return {
  -- Catppuccin (your existing setup)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = true,
      })
      -- vim.cmd([[colorscheme catppuccin]])
    end,
  },
  -- Tokyo Night
  {
    "folke/tokyonight.nvim",
    name = "tokyonight",
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night",    -- night | storm | day
        transparent = true, -- disables setting background color
        terminal_colors = true,
      })
      vim.cmd([[colorscheme tokyonight]]) -- enable to use
    end,
  },

  -- Kanagawa
  {
    "rebelot/kanagawa.nvim",
    name = "kanagawa",
    priority = 850,
    config = function()
      require("kanagawa").setup({
        compile = false,
        background = { -- map backgrounds to transparent
          dark = "transparent",
          light = "transparent",
        },
        transparent = true,
        dimInactive = true,
      })
      -- vim.cmd([[colorscheme kanagawa]])  -- enable to use
    end,
  },

  -- Rose Pine
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 800,
    config = function()
      require("rose-pine").setup({
        dark_variant = "moon", -- pine | moon
        disable_background = true,
      })
      -- vim.cmd([[colorscheme rose-pine]]) -- enable to use
    end,
  },

  -- Gruvbox Material
  {
    "sainnhe/gruvbox-material",
    name = "gruvbox-material",
    priority = 750,
    config = function()
      vim.g.gruvbox_material_background = "hard" -- hard | medium | soft
      vim.g.gruvbox_material_transparent_background = 1
      -- vim.cmd([[colorscheme gruvbox-material]])  -- enable to use
    end,
  },
}
