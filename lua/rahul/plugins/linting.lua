return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      svelte = { "eslint_d" },
      python = { "pylint" },
    }

    -- Customize pylint to ensure correct output format
    lint.linters.pylint = {
      cmd = "pylint",
      stdin = false,
      args = {
        "--output-format=text",
        "--msg-template='{path}:{line}:{column}: {msg}'",
        "$FILENAME",
      },
      parser = require("lint.parser").from_errorformat("%f:%l:%c: %m"),
      ignore_exitcode = true,
    }

    -- Customize eslint_d if necessary (usually not required)
    -- lint.linters.eslint_d.args = { "--format", "json", "--stdin", "--stdin-filename", "$FILENAME" }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })

    vim.keymap.set("n", "<leader>l", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })
  end,
}
