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

    -- Integrate nvim-lint diagnostics with LSP code actions
    -- This function generates code actions from lint diagnostics
    local function register_lsp_diagnostics()
      -- Create a namespace for lint diagnostics
      local ns = vim.api.nvim_create_namespace("nvim-lint")

      -- Override publish_diagnostics to add lint diagnostics to LSP
      local orig_publish_diagnostics = lint.linters.publish_diagnostics
      lint.linters.publish_diagnostics = function(bufnr, diagnostics, linter_name)
        -- Call original function
        orig_publish_diagnostics(bufnr, diagnostics, linter_name)

        -- Add source information to all diagnostics for filtering in code actions
        for _, diagnostic in ipairs(diagnostics) do
          diagnostic.source = diagnostic.source or linter_name
        end

        -- Set diagnostics with the namespace
        vim.diagnostic.set(ns, bufnr, diagnostics, {
          source = linter_name,
          severity_sort = true,
        })
      end
    end

    -- Call the function to register the diagnostics
    register_lsp_diagnostics()

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
      parser = function(output, _)
        if output == "" then
          return {}
        end

        local diagnostics = {}
        for line in output:gmatch("[^\r\n]+") do
          local file, lnum, col, code, msg = line:match("([^:]+):(%d+):(%d+): ([%w%d]+) (.*)")
          if file and lnum and col and code and msg then
            local severity = vim.diagnostic.severity.WARN
            if code:match("^E%d") or code:match("^F%d") then
              severity = vim.diagnostic.severity.ERROR
            elseif code:match("^I%d") then
              severity = vim.diagnostic.severity.INFO
            end

            table.insert(diagnostics, {
              lnum = tonumber(lnum) - 1,
              col = tonumber(col) - 1,
              end_col = tonumber(col), -- Assume 1 character width if not specified
              severity = severity,
              message = msg,
              code = code,
              source = "ruff", -- Tag the source for code action filtering
            })
          end
        end
        return diagnostics
      end,
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
      parser = function(output, _)
        if output == "" then
          return {}
        end

        local diagnostics = {}
        for line in output:gmatch("[^\r\n]+") do
          local file, lnum, col, severity, msg = line:match("([^:]+):(%d+):(%d+): ([^:]+): (.*)")
          if file and lnum and col and severity and msg then
            local sev = vim.diagnostic.severity.WARN
            if severity == "error" then
              sev = vim.diagnostic.severity.ERROR
            elseif severity == "note" then
              sev = vim.diagnostic.severity.INFO
            end

            table.insert(diagnostics, {
              lnum = tonumber(lnum) - 1,
              col = tonumber(col) - 1,
              severity = sev,
              message = msg,
              source = "mypy", -- Tag the source for code action filtering
            })
          end
        end
        return diagnostics
      end,
      ignore_exitcode = true,
    }

    -- Advanced eslint_d configuration with better error reporting
    lint.linters.eslint_d = {
      cmd = "eslint_d",
      args = {
        "--format",
        "json",
        "--stdin",
        "--stdin-filename",
        "$FILENAME",
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
            source = "eslint_d", -- Tag the source for code action filtering
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

      timer:start(
        DEBOUNCE_MS,
        0,
        vim.schedule_wrap(function()
          lint.try_lint()
        end)
      )
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

    -- Register code actions for lint fixes
    -- This provider will be triggered when code actions are requested
    local augroup = vim.api.nvim_create_augroup("LintCodeActions", { clear = true })
    vim.api.nvim_create_autocmd("LspAttach", {
      group = augroup,
      callback = function(args)
        local bufnr = args.buf

        local function lint_code_actions(params)
          local actions = {}

          -- Get diagnostics at cursor position
          local diagnostics = vim.diagnostic.get(bufnr)

          -- Filter to only include lint diagnostics under cursor
          local line = params.range.start.line
          local col = params.range.start.character
          local linter_diagnostics = {}

          for _, diagnostic in ipairs(diagnostics) do
            if diagnostic.source and
                (diagnostic.source == "eslint_d" or
                  diagnostic.source == "ruff" or
                  diagnostic.source == "mypy" or
                  diagnostic.source == "pylint") then
              -- Check if diagnostic is at cursor position
              if diagnostic.lnum == line and
                  diagnostic.col <= col and
                  (diagnostic.end_col and diagnostic.end_col >= col or true) then
                table.insert(linter_diagnostics, diagnostic)
              end
            end
          end

          -- For each diagnostic, create a code action
          for _, diagnostic in ipairs(linter_diagnostics) do
            local source = diagnostic.source or "linter"
            local action = {
              title = "[" .. source .. "] Fix: " .. diagnostic.message,
              kind = "quickfix",
              -- Note: This is a placeholder - in a real implementation you would
              -- need integration with the actual fixer for your linters
              command = {
                title = "Fix with " .. source,
                command = "eslint.executeAutofix", -- For ESLint
                -- Could add conditional commands for other linters
              }
            }
            table.insert(actions, action)
          end

          return actions
        end

        -- Register code action provider for this buffer
        -- This only needs to be done once per buffer
        local client_id = vim.lsp.start_client({
          name = "lint-code-actions",
          root_dir = vim.fn.getcwd(),
          handlers = {},
          capabilities = {
            codeActionProvider = true
          },
          on_attach = function(_, _)
            -- This provider is only for code actions
          end
        })

        if client_id then
          vim.lsp.buf_attach_client(bufnr, client_id)
        end
      end
    })

    -- Keymaps
    vim.keymap.set("n", "<leader>l", function()
      lint.try_lint()
      vim.notify("Linting triggered", vim.log.levels.INFO)
    end, { desc = "Trigger linting for current file" })

    -- Add key mapping for automatic fixing of all linting issues
    vim.keymap.set("n", "<leader>lx", function()
      -- Get current filetype
      local ft = vim.bo.filetype

      -- Handle specific filetypes with their fixers
      if ft == "javascript" or ft == "typescript" or ft == "javascriptreact" or ft == "typescriptreact" then
        -- For JavaScript/TypeScript files, use ESLint fix
        vim.cmd("EslintFixAll")
        vim.notify("Applied ESLint fixes", vim.log.levels.INFO)
      elseif ft == "python" then
        -- For Python files, use ruff fix
        local filename = vim.api.nvim_buf_get_name(0)
        vim.fn.system("ruff check --fix " .. filename)
        vim.cmd("e") -- Reload the file to see changes
        vim.notify("Applied ruff fixes", vim.log.levels.INFO)
      else
        -- For other filetypes, try using LSP code actions
        vim.lsp.buf.code_action({
          context = {
            only = { "quickfix" },
            diagnostics = vim.diagnostic.get(0)
          }
        })
      end
    end, { desc = "Fix linting issues" })

    vim.keymap.set("n", "<leader>lf", function()
      -- Switch between available linters for the current filetype
      local current_ft = vim.bo.filetype
      local available_linters = lint.linters_by_ft[current_ft] or {}

      -- Show notification about available linters
      if #available_linters > 0 then
        vim.notify(
          "Available linters for " .. current_ft .. ": " .. table.concat(available_linters, ", "),
          vim.log.levels.INFO
        )
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
