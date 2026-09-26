local gh = require("config.pack").gh
vim.pack.add({ { src = gh("catppuccin/nvim"), name = "catppuccin" } })

-- Catppuccin Mocha, italics matching Cursor's tokenColorCustomizations.
require("catppuccin").setup({
  flavour = "mocha",
  transparent_background = true,
  float = { transparent = true, solid = false },
  term_colors = true,
  styles = {
    comments = { "italic" },
    keywords = { "italic" },
    conditionals = { "italic" },
    loops = { "italic" },
    types = {},
  },
  auto_integrations = true,
  custom_highlights = function(c)
    return {
      -- Cursor: structural borders use surface1
      WinSeparator = { fg = c.surface1 },
      FloatBorder = { fg = c.surface1, bg = "NONE" },
      NormalFloat = { bg = "NONE" },
      Pmenu = { bg = "NONE" },
      StatusLine = { bg = "NONE" },
      StatusLineNC = { bg = "NONE" },
      TabLineFill = { bg = "NONE" },
      CursorLine = { bg = c.surface0 },
      ["@variable.builtin"] = { style = { "italic" } }, -- this / self / super
      ["@attribute"] = { style = { "italic" } },
      ["@tag.attribute"] = { style = { "italic" } },
    }
  end,
})
vim.cmd.colorscheme("catppuccin")
