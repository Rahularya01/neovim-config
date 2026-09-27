local gh = require("config.pack").gh
local M = {}
vim.pack.add({
  gh("neovim/nvim-lspconfig"), -- server defaults in lsp/*.lua, consumed by vim.lsp.enable()
  gh("mason-org/mason.nvim"),
  gh("b0o/SchemaStore.nvim"),
  gh("folke/lazydev.nvim"),
})

-- Supply chain: the registry is pinned to a fixed release, so package download
-- URLs/versions can't change underneath us. Tool versions are pinned in
-- plugins/tools.lua. Bump both deliberately (see README.md → Updating).
require("mason").setup({
  registries = { "github:mason-org/mason-registry@2026-09-26-watery-cerium" },
  ui = { border = "rounded" },
})
require("lazydev").setup({
  library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } }, { path = "snacks.nvim", words = { "Snacks" } } },
})

-- Server overrides (merged on top of nvim-lspconfig's defaults) ----------------
-- Completion capabilities for "*" are registered by blink.cmp's plugin/ file.
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      workspace = { checkThirdParty = false },
      completion = { callSnippet = "Replace" },
      hint = { enable = true },
      diagnostics = { globals = { "vim", "Snacks" } },
    },
  },
})

local ts_settings = {
  preferGoToSourceDefinition = true,
  updateImportsOnFileMove = { enabled = "always" },
  preferences = { includePackageJsonAutoImports = "off" },
  suggest = { completeFunctionCalls = true, autoImports = true },
  inlayHints = {
    parameterNames = { enabled = "literals" },
    variableTypes = { enabled = false },
    functionLikeReturnTypes = { enabled = true },
  },
}
vim.lsp.config("vtsls", {
  settings = {
    complete_function_calls = true,
    vtsls = { enableMoveToFileCodeAction = true, autoUseWorkspaceTsdk = true },
    typescript = ts_settings,
    javascript = ts_settings,
  },
})

vim.lsp.config("tailwindcss", {
  settings = {
    tailwindCSS = {
      experimental = {
        classRegex = {
          { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
          { "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
        },
      },
    },
  },
})

-- SchemaStore's catalog is large: load it only when the server starts.
vim.lsp.config("jsonls", {
  settings = { json = { validate = { enable = true } } },
  before_init = function(_, config)
    config.settings.json.schemas = require("schemastore").json.schemas()
  end,
})
vim.lsp.config("yamlls", {
  settings = { yaml = { schemaStore = { enable = false, url = "" }, keyOrdering = false } },
  before_init = function(_, config)
    config.settings.yaml.schemas = require("schemastore").yaml.schemas()
  end,
})

vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      check = { command = "clippy" }, -- rust-analyzer.check.command = clippy
      checkOnSave = true,
      diagnostics = { enable = true, experimental = { enable = true } },
      cargo = { allFeatures = true },
    },
  },
})

vim.lsp.config("gopls", {
  settings = { gopls = { gofumpt = true, usePlaceholders = true, staticcheck = true, semanticTokens = true } },
})

vim.lsp.config("basedpyright", {
  settings = { basedpyright = { analysis = { typeCheckingMode = "standard" } } },
})

vim.lsp.config("clangd", {
  cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu", "--completion-style=detailed" },
})

-- Enable servers ---------------------------------------------------------------
-- Only servers whose binary exists are enabled; plugins/tools.lua re-runs this
-- after Mason finishes installing, so new servers attach without a restart.
M.servers = {
  "lua_ls",
  "vtsls",
  "eslint",
  "tailwindcss",
  "cssls",
  "html",
  "emmet_language_server",
  "jsonls",
  "yamlls",
  "basedpyright",
  "ruff",
  "gopls",
  "rust_analyzer",
  "clangd",
  "bashls",
  "dockerls",
  "docker_compose_language_service",
  "marksman",
  "taplo",
  "prismals",
  "copilot_ls", -- config comes from copilot-lsp, added in plugins/ai.lua
}

function M.enable_installed()
  for _, name in ipairs(M.servers) do
    local cmd = (vim.lsp.config[name] or {}).cmd
    if type(cmd) == "function" or (type(cmd) == "table" and vim.fn.executable(cmd[1]) == 1) then
      vim.lsp.enable(name)
    end
  end
end
M.enable_installed()

-- Keymaps on attach (Cursor: K, gd, gD, gi, gr, <leader>rn, <leader>ca, <leader>oi)
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local function map(mode, lhs, rhs, desc, extra)
      vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", { buffer = ev.buf, desc = desc }, extra or {}))
    end

    map("n", "K", function()
      vim.lsp.buf.hover()
    end, "Hover")
    map("n", "gd", function()
      Snacks.picker.lsp_definitions()
    end, "Goto definition")
    map("n", "gD", function()
      Snacks.picker.lsp_declarations()
    end, "Goto declaration")
    map("n", "gi", function()
      Snacks.picker.lsp_implementations()
    end, "Goto implementation")
    map("n", "gy", function()
      Snacks.picker.lsp_type_definitions()
    end, "Goto type definition")
    map("n", "gr", function()
      Snacks.picker.lsp_references()
    end, "References", { nowait = true })
    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
    map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("n", "<leader>cA", function()
      vim.lsp.buf.code_action({ context = { only = { "source" }, diagnostics = {} } })
    end, "Source action")
    map("n", "<leader>oi", function()
      vim.lsp.buf.code_action({ context = { only = { "source.fixAll" }, diagnostics = {} } })
    end, "Fix all")
    map("n", "<leader>li", "<cmd>checkhealth vim.lsp<cr>", "LSP info")
    map("n", "<leader>lr", "<cmd>lsp restart<cr>", "Restart LSP")

    if client and client.name == "vtsls" then
      map("n", "<leader>cM", function()
        vim.lsp.buf.code_action({
          context = { only = { "source.addMissingImports.ts" }, diagnostics = {} },
          apply = true,
        })
      end, "Add missing imports")
      map("n", "<leader>cu", function()
        vim.lsp.buf.code_action({ context = { only = { "source.removeUnused.ts" }, diagnostics = {} }, apply = true })
      end, "Remove unused imports")
      map("n", "<leader>cR", function()
        client:exec_cmd({ command = "typescript.selectTypeScriptVersion", title = "Select TS version" })
      end, "Select TS version")
    end
    if client and client.name == "ruff" then
      client.server_capabilities.hoverProvider = false -- leave hover to basedpyright
    end
  end,
})

return M
