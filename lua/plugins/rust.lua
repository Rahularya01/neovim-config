local platform = require("config.platform")

return {
  "mrcjkb/rustaceanvim",
  cond = platform.not_vscode,
  version = "^6", -- Recommended
  ft = { "rust" }, -- Only load for Rust files
}
