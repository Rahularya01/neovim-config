return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    -- import mason
    local mason_ok, mason = pcall(require, "mason")
    if not mason_ok then
      vim.notify("Mason not loaded! Some language servers may not be available.", vim.log.levels.ERROR)
      return
    end

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

    -- import mason-lspconfig with error handling
    local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
    if not mason_lspconfig_ok then
      vim.notify("Mason-lspconfig not loaded! Manual server setup will be required.", vim.log.levels.WARN)
      return
    end

    -- Configure mason-lspconfig
    mason_lspconfig.setup({
      -- list of servers for mason to install
      ensure_installed = {
        "ts_ls", -- TypeScript server (corrected from "ts_ls")
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

    -- import mason-tool-installer with error handling
    local mason_tool_installer_ok, mason_tool_installer = pcall(require, "mason-tool-installer")
    if not mason_tool_installer_ok then
      vim.notify("Mason-tool-installer not loaded! Manual tool setup will be required.", vim.log.levels.WARN)
      return
    end

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
