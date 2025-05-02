return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    -- Configure linters by filetype
    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      svelte = { "eslint_d" },
      python = { "ruff", "mypy" }, -- Using ruff as primary, mypy for type checking
    }

    -- Custom pylint configuration with more relaxed rules for docstrings
    -- Only kept as a reference in case you want to switch back
    lint.linters.pylint = {
      cmd = "pylint",
      stdin = false,
      args = {
        "--output-format=text",
        "--msg-template='{path}:{line}:{column}: {msg_id}: {msg} ({symbol})'",
        "--disable=C0111,C0103,C0303,C0330,C0326",  -- Disable docstring warnings and some formatting issues
        "--disable=missing-docstring,invalid-name", -- Alternative way to disable common warnings
        "--ignore-patterns=test_*,conftest.py",     -- Ignore test files
        "$FILENAME",
      },
      parser = require("lint.parser").from_errorformat("%f:%l:%c: %t%n: %m"),
      ignore_exitcode = true,
    }

    -- Configure ruff - a fast Python linter
    lint.linters.ruff = {
      cmd = "ruff",
      args = {
        "--format=text",
        "--select=E,F,W,I,N,D,UP,S,BLE,FBT,B,A,COM,C4,T10,EM,FA,ISC,ICN,G,PIE,T20,PYI,PT,RSE,SLF,SIM,TID,ARG,PTH,ERA,PD,PGH,PL,TRY,FLY,PERF,LOG,RUF",
        "--ignore=D100,D101,D102,D103,D104,D105,D107,D203,D213", -- Ignore most missing docstring rules
        "--line-length=100",
        "$FILENAME",
      },
      stdin = false,
      parser = require("lint.parser").from_pattern(
        "[^:]+:([0-9]+):([0-9]+): ([A-Z][0-9]+) (.*)",
        { "lnum", "col", "code", "message" },
        { severity = { E = vim.diagnostic.severity.ERROR, W = vim.diagnostic.severity.WARN, I = vim.diagnostic.severity.INFO } }
      ),
      ignore_exitcode = true,
    }

    -- Configure mypy for Python type checking
    lint.linters.mypy = {
      cmd = "mypy",
      args = {
        "--show-column-numbers",
        "--no-error-summary",
        "--no-pretty",
        "--ignore-missing-imports",
        "--disallow-untyped-defs=False", -- Don't require type annotations on every function
        "--disallow-incomplete-defs=False",
        "$FILENAME",
      },
      parser = require("lint.parser").from_pattern(
        "([^:]+):([0-9]+):([0-9]+): ([^:]+): (.*)",
        { "file", "lnum", "col", "severity", "message" },
        {
          severity = {
            error = vim.diagnostic.severity.ERROR,
            warning = vim.diagnostic.severity.WARN,
            note = vim.diagnostic.severity.INFO,
          },
        }
      ),
      ignore_exitcode = true,
    }

    -- Advanced eslint_d configuration with better error reporting
    lint.linters.eslint_d = {
      cmd = "eslint_d",
      args = {
        "--format", "json",
        "--stdin",
        "--stdin-filename", "$FILENAME"
      },
      parser = function(output, bufnr)
        if output == "" then
          return {}
        end
        local diagnostics = {}
        local decoded = vim.json.decode(output)
        if not decoded[1] then
          return {}
        end
        local result = decoded[1]
        for _, message in ipairs(result.messages) do
          local severity = message.severity
          if severity == 1 then
            severity = vim.diagnostic.severity.WARN
          else
            severity = vim.diagnostic.severity.ERROR
          end

          table.insert(diagnostics, {
            lnum = message.line - 1,
            col = message.column - 1,
            end_lnum = message.endLine and (message.endLine - 1) or nil,
            end_col = message.endColumn and (message.endColumn - 1) or nil,
            severity = severity,
            message = message.message,
            code = message.ruleId,
            source = "eslint_d",
          })
        end
        return diagnostics
      end,
      ignore_exitcode = true,
    }

    -- Create a dedicated augroup for lint events
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    -- Trigger linting on key events with debounce
    local timer = vim.loop.new_timer()
    local DEBOUNCE_MS = 300 -- Adjust as needed

    local function debounced_lint()
      if timer:is_active() then
        timer:stop()
      end

      timer:start(DEBOUNCE_MS, 0, vim.schedule_wrap(function()
        lint.try_lint()
      end))
    end

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }, {
      group = lint_augroup,
      callback = function()
        debounced_lint()
      end,
    })

    -- Clear diagnostics when leaving buffer
    vim.api.nvim_create_autocmd({ "BufLeave" }, {
      group = lint_augroup,
      callback = function(args)
        vim.diagnostic.reset(nil, args.buf)
      end,
    })

    -- Keymaps
    vim.keymap.set("n", "<leader>l", function()
      lint.try_lint()
      vim.notify("Linting triggered", vim.log.levels.INFO)
    end, { desc = "Trigger linting for current file" })

    vim.keymap.set("n", "<leader>lf", function()
      -- Switch between available linters for the current filetype
      local current_ft = vim.bo.filetype
      local available_linters = lint.linters_by_ft[current_ft] or {}

      -- Show notification about available linters
      if #available_linters > 0 then
        vim.notify("Available linters for " .. current_ft .. ": " .. table.concat(available_linters, ", "),
          vim.log.levels.INFO)
      else
        vim.notify("No linters available for " .. current_ft, vim.log.levels.WARN)
      end
    end, { desc = "List available linters for current filetype" })

    -- Skip linting in certain directories (like node_modules, virtual environments)
    vim.api.nvim_create_autocmd({ "BufEnter" }, {
      group = lint_augroup,
      callback = function(args)
        local filepath = vim.api.nvim_buf_get_name(args.buf)
        local skip_patterns = {
          "node_modules/",
          "venv/",
          ".venv/",
          "dist/",
          "build/",
          "__pycache__/",
          ".git/",
        }

        for _, pattern in ipairs(skip_patterns) do
          if filepath:match(pattern) then
            -- Skip linting for this buffer
            return
          end
        end

        -- Lint for non-skipped buffers
        debounced_lint()
      end,
    })
  end,
}
