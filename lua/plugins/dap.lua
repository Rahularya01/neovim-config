-- Debugging (JS/TS via vscode-js-debug). Also reads .vscode/launch.json.
local gh = require("config.pack").gh
vim.pack.add({
  gh("mfussenegger/nvim-dap"),
  gh("rcarriga/nvim-dap-ui"),
  gh("nvim-neotest/nvim-nio"),
})

local dap, dapui = require("dap"), require("dapui")

-- js-debug-adapter is installed at a pinned version by plugins/tools.lua.
for _, adapter in ipairs({ "pwa-node", "pwa-chrome" }) do
  dap.adapters[adapter] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = { command = "js-debug-adapter", args = { "${port}" } },
  }
end
-- launch.json files often use the plain "node" / "chrome" types.
dap.adapters.node = function(cb, config)
  config.type = "pwa-node"
  cb(dap.adapters["pwa-node"])
end
dap.adapters.chrome = function(cb, config)
  config.type = "pwa-chrome"
  cb(dap.adapters["pwa-chrome"])
end

local js_configs = {
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch current file (node)",
    program = "${file}",
    cwd = "${workspaceFolder}",
    sourceMaps = true,
  },
  {
    type = "pwa-node",
    request = "attach",
    name = "Attach to node process",
    processId = function()
      return require("dap.utils").pick_process({ filter = "node" })
    end,
    cwd = "${workspaceFolder}",
    sourceMaps = true,
  },
  {
    type = "pwa-chrome",
    request = "launch",
    name = "Launch Chrome (localhost:3000)",
    url = function()
      local url = vim.fn.input("URL: ", "http://localhost:3000")
      return url ~= "" and url or dap.ABORT
    end,
    webRoot = "${workspaceFolder}",
    sourceMaps = true,
  },
}
for _, ft in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
  dap.configurations[ft] = js_configs
end

-- UI opens/closes with the session
dapui.setup()
dap.listeners.after.event_initialized.dapui = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui = function()
  dapui.close()
end

vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
vim.fn.sign_define("DapLogPoint", { text = "◉", texthl = "DiagnosticInfo" })
vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "Visual" })
vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DiagnosticHint" })

-- VS Code-style function keys + <leader>d
local map = vim.keymap.set
map("n", "<F5>", dap.continue, { desc = "Debug: continue / start" })
map("n", "<F10>", dap.step_over, { desc = "Debug: step over" })
map("n", "<F11>", dap.step_into, { desc = "Debug: step into" })
map("n", "<S-F11>", dap.step_out, { desc = "Debug: step out" })
map("n", "<S-F5>", dap.terminate, { desc = "Debug: stop" })
-- Many terminals send Shift+F5 / Shift+F11 as F17 / F23.
map("n", "<F23>", dap.step_out, { desc = "Debug: step out" })
map("n", "<F17>", dap.terminate, { desc = "Debug: stop" })
map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
map("n", "<leader>dB", function()
  dap.set_breakpoint(vim.fn.input("Condition: "))
end, { desc = "Conditional breakpoint" })
map("n", "<leader>dL", function()
  dap.set_breakpoint(nil, nil, vim.fn.input("Log message: "))
end, { desc = "Log point" })
map("n", "<leader>dc", dap.continue, { desc = "Continue / start" })
map("n", "<leader>dC", dap.run_to_cursor, { desc = "Run to cursor" })
map("n", "<leader>di", dap.step_into, { desc = "Step into" })
map("n", "<leader>do", dap.step_over, { desc = "Step over" })
map("n", "<leader>dO", dap.step_out, { desc = "Step out" })
map("n", "<leader>dl", dap.run_last, { desc = "Run last" })
map("n", "<leader>dr", dap.repl.toggle, { desc = "REPL" })
map("n", "<leader>dt", dap.terminate, { desc = "Terminate" })
map("n", "<leader>du", function()
  dapui.toggle()
end, { desc = "Debug UI" })
map({ "n", "x" }, "<leader>de", function()
  dapui.eval()
end, { desc = "Eval expression" })
map("n", "<leader>dx", dap.clear_breakpoints, { desc = "Clear breakpoints" })
