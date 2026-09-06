local platform = require("config.platform")

return {
  "vuki656/package-info.nvim",
  cond = platform.not_vscode,
  event = { "BufRead package.json", "BufNewFile package.json" },
  opts = {
    icons = {
      enable = true,
      style = {
        up_to_date = "  ",
        outdated = "  ",
      },
    },
    autostart = true,
  },
  keys = {
    { "<leader>ns", "<cmd>lua require('package-info').show()<cr>", desc = "Show package versions" },
    { "<leader>nu", "<cmd>lua require('package-info').update()<cr>", desc = "Update package" },
    { "<leader>nd", "<cmd>lua require('package-info').delete()<cr>", desc = "Delete package" },
    { "<leader>ni", "<cmd>lua require('package-info').install()<cr>", desc = "Install package" },
    { "<leader>nc", "<cmd>lua require('package-info').change_version()<cr>", desc = "Change package version" },
  },
}
