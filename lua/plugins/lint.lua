local platform = require("config.platform")

return {
  "mfussenegger/nvim-lint",
  cond = platform.not_vscode,
  ft = { "python", "lua", "go", "c", "cpp" },
  config = function()
    local lint = require("lint")
    local linters_by_ft = {
      python = { "ruff" },
      lua = { "luacheck" },
      go = { "golangci-lint" },
      c = { "cpplint" },
      cpp = { "cpplint" },
    }
    if vim.fn.executable("luacheck") == 0 then
      linters_by_ft.lua = nil
    end
    if vim.fn.executable("ruff") == 0 then
      linters_by_ft.python = nil
    end
    if vim.fn.executable("golangci-lint") == 0 then
      linters_by_ft.go = nil
    end
    if vim.fn.executable("cpplint") == 0 then
      linters_by_ft.c = nil
      linters_by_ft.cpp = nil
    end
    lint.linters_by_ft = linters_by_ft
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    -- Running external linters after every insert-mode exit makes editing feel
    -- choppy, particularly in large Python and Go projects. LSP diagnostics
    -- remain live; external linting runs when a file is saved.
    vim.api.nvim_create_autocmd("BufWritePost", {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
