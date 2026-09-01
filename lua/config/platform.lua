local M = {}

--- True when not running inside VSCode / Cursor (vscode-neovim sets `vim.g.vscode`).
function M.not_vscode()
  return not vim.g.vscode
end

--- True when Neovim was launched in a Herdr-managed pane.
function M.in_herdr()
  return vim.env.HERDR_ENV == "1" or vim.env.HERDR_SOCKET_PATH ~= nil
end

function M.not_herdr()
  return not M.in_herdr()
end

return M
