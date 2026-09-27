local gh = require("config.pack").gh
vim.pack.add({ gh("mfussenegger/nvim-lint") })

-- JS/TS use the eslint LSP and Python uses ruff LSP; nvim-lint covers the rest.
local lint = require("lint")
lint.linters_by_ft = {
  go = { "golangcilint" },
  sh = { "shellcheck" },
  bash = { "shellcheck" },
  dockerfile = { "hadolint" },
  markdown = { "markdownlint-cli2" },
}

local function try_lint()
  -- Skip linters that aren't installed yet (mason may still be fetching them).
  local names = vim.tbl_filter(function(name)
    local l = lint.linters[name]
    local cmd = type(l) == "table" and l.cmd or name
    cmd = type(cmd) == "function" and cmd() or cmd
    return vim.fn.executable(cmd) == 1
  end, lint.linters_by_ft[vim.bo.filetype] or {})
  if #names > 0 then
    lint.try_lint(names)
  end
end

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("user_lint", { clear = true }),
  callback = try_lint,
})
-- This module loads after startup, so the initial buffer missed BufReadPost.
try_lint()
