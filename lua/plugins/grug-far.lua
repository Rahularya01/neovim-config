return {
  "MagicDuck/grug-far.nvim",
  opts = {},
  keys = {
    {
      "<leader>sr",
      function()
        require("grug-far").open()
      end,
      mode = { "n", "x" },
      desc = "Grug-far: Search and replace",
    },
    {
      "<leader>sR",
      function()
        require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
      end,
      mode = "n",
      desc = "Grug-far: Replace word under cursor",
    },
    {
      "<leader>sR",
      function()
        require("grug-far").with_visual_selection()
      end,
      mode = "x",
      desc = "Grug-far: Replace visual selection",
    },
    {
      "<leader>sw",
      function()
        require("grug-far").open({ visualSelectionUsage = "operate-within-range" })
      end,
      mode = { "n", "x" },
      desc = "Grug-far: Search within range",
    },
  },
}
