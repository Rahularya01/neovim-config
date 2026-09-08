local platform = require("config.platform")

return {
  "mfussenegger/nvim-dap",
  cond = platform.not_vscode,
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "theHamsta/nvim-dap-virtual-text",
    {
      "jay-babu/mason-nvim-dap.nvim",
      dependencies = { "mason-org/mason.nvim" },
      opts = {
        -- Default handlers fully configure adapters/configurations for
        -- these; JS/TS (js-debug-adapter) needs the hand-written setup
        -- below instead, so it's installed via mason-tool-installer.
        ensure_installed = { "debugpy", "delve", "codelldb" },
        automatic_installation = true,
        handlers = {},
      },
    },
  },
  keys = {
    {
      "<leader>db",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "Toggle breakpoint",
    },
    {
      "<leader>dc",
      function()
        require("dap").continue()
      end,
      desc = "Continue / start",
    },
    {
      "<leader>di",
      function()
        require("dap").step_into()
      end,
      desc = "Step into",
    },
    {
      "<leader>do",
      function()
        require("dap").step_over()
      end,
      desc = "Step over",
    },
    {
      "<leader>dO",
      function()
        require("dap").step_out()
      end,
      desc = "Step out",
    },
    {
      "<leader>dr",
      function()
        require("dap").repl.toggle()
      end,
      desc = "Toggle REPL",
    },
    {
      "<leader>dl",
      function()
        require("dap").run_last()
      end,
      desc = "Run last",
    },
    {
      "<leader>dt",
      function()
        require("dap").terminate()
      end,
      desc = "Terminate",
    },
    {
      "<leader>du",
      function()
        require("dapui").toggle()
      end,
      desc = "Toggle DAP UI",
    },
    {
      "<leader>de",
      function()
        require("dapui").eval()
      end,
      desc = "Eval expression under cursor",
      mode = { "n", "v" },
    },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup()
    require("nvim-dap-virtual-text").setup()

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    -- JS/TS debugging goes through js-debug-adapter (vscode-js-debug), which
    -- speaks the Chrome DevTools Protocol rather than plain DAP, so pwa-*
    -- adapters and per-filetype launch/attach configs have to be wired up by
    -- hand instead of via mason-nvim-dap's default handlers.
    for _, adapter_type in ipairs({ "node", "chrome", "msedge" }) do
      local pwa_type = "pwa-" .. adapter_type

      if not dap.adapters[pwa_type] then
        dap.adapters[pwa_type] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "js-debug-adapter",
            args = { "${port}" },
          },
        }
      end

      if not dap.adapters[adapter_type] then
        dap.adapters[adapter_type] = function(cb, config)
          local native_adapter = dap.adapters[pwa_type]
          config.type = pwa_type
          if type(native_adapter) == "function" then
            native_adapter(cb, config)
          else
            cb(native_adapter)
          end
        end
      end
    end

    local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

    local vscode = require("dap.ext.vscode")
    vscode.type_to_filetypes["node"] = js_filetypes
    vscode.type_to_filetypes["pwa-node"] = js_filetypes

    for _, language in ipairs(js_filetypes) do
      if not dap.configurations[language] then
        local runtime_executable = nil
        if language:find("typescript") then
          runtime_executable = vim.fn.executable("tsx") == 1 and "tsx" or "ts-node"
        end
        dap.configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            runtimeExecutable = runtime_executable,
            skipFiles = { "<node_internals>/**", "node_modules/**" },
            resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            runtimeExecutable = runtime_executable,
            skipFiles = { "<node_internals>/**", "node_modules/**" },
            resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
          },
        }
      end
    end
  end,
}
