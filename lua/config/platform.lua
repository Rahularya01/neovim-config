local M = {}

--- True when not running inside VSCode / Cursor (vscode-neovim sets `vim.g.vscode`).
function M.not_vscode()
  return not vim.g.vscode
end

return M
