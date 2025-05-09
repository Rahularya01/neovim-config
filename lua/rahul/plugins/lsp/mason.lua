return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    -- import mason
    local mason = require("mason")
    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    -- import mason-lspconfig after setting up mason
    local mason_lspconfig = require("mason-lspconfig")

    -- Configure mason-lspconfig
    mason_lspconfig.setup({
      -- list of servers for mason to install
      ensure_installed = {
        "ts_ls", -- TypeScript server
        "html",
        "cssls",
        "tailwindcss",
        "lua_ls",
        "emmet_ls",
        "pyright",
        "ruff",
        "eslint",
      },
      -- auto-install configured servers (with lspconfig)
      automatic_installation = true,
    })

    -- Important: Do NOT set up handlers here - we'll do this in lspconfig.lua

    -- import mason-tool-installer after setting up mason
    local mason_tool_installer = require("mason-tool-installer")

    -- Configure mason-tool-installer
    mason_tool_installer.setup({
      ensure_installed = {
        "prettierd", -- prettier formatter
        "black",     -- python formatter
        "eslint_d",  -- js linter
        "ruff",      -- python linter
        "mypy",      -- python type checker
      },
    })
  end,
}
