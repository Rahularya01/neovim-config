local platform = require("config.platform")

return {
  "brenoprata10/nvim-highlight-colors",
  cond = platform.not_vscode,
  ft = { "css", "scss", "html", "javascript", "javascriptreact", "typescript", "typescriptreact" },
  opts = {
    render = "background",
    enable_tailwind = true,
  },
}
