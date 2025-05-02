return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
    { "folke/lsp-colors.nvim" },    -- Better highlighting for LSP diagnostics
    { "ray-x/lsp_signature.nvim" }, -- Shows function signature when typing
    {
      "SmiteshP/nvim-navic",
      -- Remove the config function from here, we'll handle it in the main config
    }, -- Show code context
    {
      "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
      config = function()
        require("lsp_lines").setup()
      end,
    }, -- Show diagnostic lines
  },
  config = function()
    -- import lspconfig plugin
    local lspconfig = require("lspconfig")

    -- import mason_lspconfig plugin
    local mason_lspconfig = require("mason-lspconfig")

    -- import cmp-nvim-lsp plugin
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    -- import lsp_signature plugin
    local lsp_signature = require("lsp_signature")

    -- First ensure navic is loaded and configured
    local navic_ok, navic = pcall(require, "nvim-navic")
    if not navic_ok then
      vim.notify("navic module not found. Please ensure 'SmiteshP/nvim-navic' is installed properly.", vim.log.levels.ERROR)
      -- Create a dummy navic module to prevent further errors
      navic = {
        attach = function() end,
        setup = function() end,
      }
    else
      -- Configure navic here
      navic.setup({
        highlight = true,
        depth_limit = 5,
        icons = {
          File = " ",
          Module = " ",
          Namespace = " ",
          Package = " ",
          Class = " ",
          Method = " ",
          Property = " ",
          Field = " ",
          Constructor = " ",
          Enum = " ",
          Interface = " ",
          Function = " ",
          Variable = " ",
          Constant = " ",
          String = " ",
          Number = " ",
          Boolean = " ",
          Array = " ",
          Object = " ",
          Key = " ",
          Null = " ",
          EnumMember = " ",
          Struct = " ",
          Event = " ",
          Operator = " ",
          TypeParameter = " ",
        },
      })
    end

    local keymap = vim.keymap -- for conciseness

    -- Performance tweaks for LSP
    vim.lsp.set_log_level("error") -- Reduce log noise
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
        -- Reduce update rate for better performance
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          prefix = "●",
        },
        severity_sort = true,
      }
    )

    -- Enhanced hover/signature experience
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
      vim.lsp.handlers.hover, {
        border = "rounded",
        width = 60,
        silent = true,
      }
    )
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
      vim.lsp.handlers.signature_help, {
        border = "rounded",
        width = 60,
        silent = true,
      }
    )

    -- Setup LSP signature as you type
    lsp_signature.setup({
      bind = true,
      handler_opts = {
        border = "rounded",
      },
      hint_enable = false,
      floating_window = true,
      toggle_key = "<C-s>",           -- Toggle signature on/off
      select_signature_key = "<C-n>", -- Cycle between signatures
    })

    -- Toggle between virtual text and virtual lines for diagnostics
    local diagnostic_mode = "virtual_text" -- Start with virtual text by default
    local function toggle_diagnostic_mode()
      if diagnostic_mode == "virtual_text" then
        vim.diagnostic.config({
          virtual_text = false,
          virtual_lines = true,
        })
        diagnostic_mode = "virtual_lines"
        vim.notify("Diagnostic mode: virtual lines", vim.log.levels.INFO)
      else
        vim.diagnostic.config({
          virtual_text = true,
          virtual_lines = false,
        })
        diagnostic_mode = "virtual_text"
        vim.notify("Diagnostic mode: virtual text", vim.log.levels.INFO)
      end
    end


    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        -- Buffer local mappings.
        -- See :help vim.lsp.* for documentation on any of the below functions
        local opts = { buffer = ev.buf, silent = true }

        -- set keybinds
        opts.desc = "Show LSP references"
        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts)

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

        opts.desc = "Trigger source code action"
        vim.keymap.set("n", "<leader>oi", function()
          vim.lsp.buf.code_action({
            context = { only = { "source" } },
          })
        end, opts)

        -- New keymaps
        opts.desc = "Toggle diagnostic mode (virtual text vs lines)"
        keymap.set("n", "<leader>dt", toggle_diagnostic_mode, opts)

        opts.desc = "Format document"
        keymap.set("n", "<leader>cf", function()
          vim.lsp.buf.format({ async = true })
        end, opts)

        opts.desc = "Show workspace diagnostics"
        keymap.set("n", "<leader>dw", "<cmd>Telescope diagnostics<CR>", opts)

        opts.desc = "Show all LSP symbols in current buffer"
        keymap.set("n", "<leader>sy", "<cmd>Telescope lsp_document_symbols<CR>", opts)

        opts.desc = "Show all LSP symbols in workspace"
        keymap.set("n", "<leader>swy", "<cmd>Telescope lsp_workspace_symbols<CR>", opts)

        -- Setup navic (breadcrumbs) if supported and available
        if navic_ok and client.server_capabilities.documentSymbolProvider then
          navic.attach(client, ev.buf)
        end
      end,
    })

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Speed up lsp by limiting the size of files to analyze
    capabilities.textDocument.semanticTokens = nil
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
      properties = {
        "documentation",
        "detail",
        "additionalTextEdits",
      },
    }

    -- Change the Diagnostic symbols in the sign column (gutter)
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.HINT] = "󰠠 ",
          [vim.diagnostic.severity.INFO] = " ",
        },
      },
      virtual_text = true,
      virtual_lines = false,
      update_in_insert = false,
      underline = true,
      severity_sort = true,
      float = {
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    })

    -- Load .nvim.lua project configuration if present
    local function load_project_settings()
      local project_settings_file = vim.fn.getcwd() .. "/.nvim.lua"
      if vim.fn.filereadable(project_settings_file) == 1 then
        local settings = dofile(project_settings_file)
        if settings and settings.lsp then
          return settings.lsp
        end
      end
      return {}
    end

    -- Load project-specific settings
    local project_settings = load_project_settings()

    mason_lspconfig.setup_handlers({
      -- default handler for installed servers
      function(server_name)
        -- Add project-specific settings if they exist
        local server_settings = project_settings[server_name] or {}
        local default_settings = {}

        -- Merge settings
        local merged_settings = vim.tbl_deep_extend("force", default_settings, server_settings)

        lspconfig[server_name].setup({
          capabilities = capabilities,
          settings = merged_settings,
        })
      end,

      ["emmet_ls"] = function()
        -- configure emmet language server
        lspconfig["emmet_ls"].setup({
          capabilities = capabilities,
          filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
        })
      end,

      ["pyright"] = function()
        -- Load project-specific settings
        local server_settings = project_settings["pyright"] or {}
        local default_settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace", -- or "openFilesOnly" for better performance
              -- Ignore specific issues (customize as needed)
              diagnosticSeverityOverrides = {
                reportMissingTypeStubs = "information",
                reportUnknownMemberType = "information",
                reportUnknownParameterType = "information",
                reportUnknownVariableType = "information",
                reportGeneralTypeIssues = "warning",
              },
              stubPath = vim.fn.stdpath("data") .. "/stubs",
            },
          },
        }

        -- Merge settings
        local merged_settings = vim.tbl_deep_extend("force", default_settings, server_settings)

        lspconfig["pyright"].setup({
          capabilities = capabilities,
          filetypes = { "python" },
          settings = merged_settings,
          -- Additional configuration for Python work
          on_attach = function(client, bufnr)
            -- Add special handler for organizing imports
            vim.api.nvim_buf_create_user_command(bufnr, "OrganizeImports", function()
              vim.lsp.buf.execute_command({
                command = "pyright.organizeimports",
                arguments = { vim.api.nvim_buf_get_name(bufnr) },
              })
            end, { desc = "Organize Python Imports" })

            -- Add keymap for organizing imports
            vim.keymap.set("n", "<leader>oi", ":OrganizeImports<CR>",
              { buffer = bufnr, desc = "Organize Python Imports" })
          end,
        })
      end,

      ["ruff_lsp"] = function()
        -- Setup ruff_lsp for Python linting and formatting
        lspconfig["ruff_lsp"].setup({
          capabilities = capabilities,
          on_attach = function(client, _)
            -- Disable hover in favor of Pyright
            client.server_capabilities.hoverProvider = false
          end,
          settings = {
            ruff = {
              lint = {
                run = "onSave",
              },
              format = {
                args = { "--line-length=100" },
              },
            },
          }
        })
      end,

      ["lua_ls"] = function()
        -- configure lua server (with special settings)
        -- Load project-specific settings
        local server_settings = project_settings["lua_ls"] or {}
        local default_settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            completion = {
              callSnippet = "Replace",
            },
            workspace = {
              checkThirdParty = false,
              library = {
                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                [vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy"] = true,
              },
              maxPreload = 2000,
              preloadFileSize = 1000,
            },
            telemetry = {
              enable = false,
            },
          },
        }

        -- Merge settings
        local merged_settings = vim.tbl_deep_extend("force", default_settings, server_settings)

        lspconfig["lua_ls"].setup({
          capabilities = capabilities,
          settings = merged_settings,
        })
      end,

      ["ts_ls"] = function()
        -- TypeScript configuration
        local server_settings = project_settings["ts_ls"] or {}
        local default_settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
            updateImportsOnFileMove = {
              enabled = "always",
            },
            suggestionActions = {
              enabled = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
            updateImportsOnFileMove = {
              enabled = "always",
            },
            suggestionActions = {
              enabled = true,
            },
          },
        }

        -- Merge settings
        local merged_settings = vim.tbl_deep_extend("force", default_settings, server_settings)

        lspconfig["ts_ls"].setup({
          capabilities = capabilities,
          settings = merged_settings,
          on_attach = function(client, _)
            -- Disable formatting in favor of eslint/prettier
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end,
        })
      end,
    })

    -- Create user command to reload project settings
    vim.api.nvim_create_user_command("LspReloadProjectSettings", function()
      vim.notify("Reloading project settings...", vim.log.levels.INFO)
      vim.cmd("LspRestart")
    end, { desc = "Reload project-specific LSP settings" })
  end,
}
