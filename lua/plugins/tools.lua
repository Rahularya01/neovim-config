-- External tools (LSP servers, formatters, linters, debug adapters), installed
-- by Mason at EXACT versions. Pinned versions are enforced: if an installed
-- tool drifts, it is reinstalled at the pinned version. auto_update is off, so
-- nothing is upgraded without editing this file.
local gh = require("config.pack").gh
vim.pack.add({ gh("WhoIsSethDaniel/mason-tool-installer.nvim") })

local function pin(name, version)
  return { name, version = version }
end

require("mason-tool-installer").setup({
  auto_update = false,
  run_on_start = true,
  start_delay = 1000,
  ensure_installed = {
    -- LSP servers
    pin("lua-language-server", "3.19.1"),
    pin("vtsls", "0.3.0"),
    pin("eslint-lsp", "4.10.0"),
    pin("tailwindcss-language-server", "0.16.0"),
    pin("css-lsp", "4.10.0"),
    pin("html-lsp", "4.10.0"),
    pin("json-lsp", "4.10.0"),
    pin("emmet-language-server", "2.8.0"),
    pin("yaml-language-server", "1.24.0"),
    pin("basedpyright", "1.40.1"),
    pin("ruff", "0.16.9"),
    pin("gopls", "v0.23.0"),
    pin("rust-analyzer", "2026-09-21"),
    pin("clangd", "23.1.0"),
    pin("bash-language-server", "5.8.1"),
    pin("dockerfile-language-server", "0.15.0"),
    pin("docker-compose-language-service", "1.0.0"),
    pin("marksman", "2026-02-08"),
    pin("taplo", "0.10.0"),
    pin("prisma-language-server", "31.12.10"),
    pin("copilot-language-server", "1.549.0"), -- copilot_ls (plugins/ai.lua)
    -- Formatters / linters (conform + nvim-lint)
    pin("prettierd", "0.29.0"),
    pin("stylua", "v2.5.2"),
    pin("shfmt", "v3.14.1"),
    pin("goimports", "v0.50.0"),
    pin("gofumpt", "v0.12.0"),
    pin("clang-format", "23.1.1"),
    pin("shellcheck", "v0.11.0"),
    pin("hadolint", "v2.15.1"),
    pin("golangci-lint", "v2.14.0"),
    pin("markdownlint-cli2", "0.23.3"),
    -- Debug adapters (plugins/dap.lua)
    pin("js-debug-adapter", "v1.140.0"),
  },
})

vim.api.nvim_create_autocmd("User", {
  pattern = "MasonToolsUpdateCompleted",
  group = vim.api.nvim_create_augroup("user_mason_tools", { clear = true }),
  callback = function()
    vim.schedule(require("plugins.lsp").enable_installed)
  end,
})
