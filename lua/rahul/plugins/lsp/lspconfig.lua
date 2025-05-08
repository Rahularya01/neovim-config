return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",           -- Add Mason as a dependency
    "williamboman/mason-lspconfig.nvim", -- Add Mason-lspconfig as a dependency
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim",                   opts = {} },
    { "folke/lsp-colors.nvim" },    -- Better highlighting for LSP diagnostics
    { "ray-x/lsp_signature.nvim" }, -- Shows function signature when typing
    {
      "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
      config = function()
        require("lsp_lines").setup()
      end,
    }, -- Show diagnostic lines
  },
  config = function()
    -- Ensure mason is loaded first
    local mason_ok, mason = pcall(require, "mason")
    if not mason_ok then
      vim.notify("Mason not loaded! LSP functionality may be limited.", vim.log.levels.WARN)
      return
    end

    -- Initialize Mason
    mason.setup()

    -- Then try to load mason-lspconfig
    local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
    if not mason_lspconfig_ok then
      vim.notify("Mason-lspconfig not loaded! LSP servers might not be configured properly.", vim.log.levels.WARN)
      return
    end

    -- Initialize mason-lspconfig
    mason_lspconfig.setup()

    -- import lspconfig plugin
    local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
    if not lspconfig_ok then
      vim.notify("nvim-lspconfig not loaded! LSP functionality will be disabled.", vim.log.levels.ERROR)
      return
    end

    -- import cmp-nvim-lsp plugin
    local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if not cmp_nvim_lsp_ok then
      vim.notify("cmp-nvim-lsp not loaded! LSP autocompletion may be limited.", vim.log.levels.WARN)
      -- Create a fallback if cmp_nvim_lsp isn't available
      cmp_nvim_lsp = {
        default_capabilities = function()
          return vim.lsp.protocol.make_client_capabilities()
        end
      }
    end

    -- import lsp_signature plugin
    local lsp_signature_ok, lsp_signature = pcall(require, "lsp_signature")
    if not lsp_signature_ok then
      vim.notify("lsp_signature not loaded! Function signature display will be disabled.", vim.log.levels.WARN)
      -- Create a fallback if lsp_signature isn't available
      lsp_signature = {
        setup = function() end
      }
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

    -- Setup LSP signature as you type (only if available)
    if lsp_signature_ok then
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
    end

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

    -- Enhance code action functionality to include linting fixes
    local orig_code_action_handler = vim.lsp.handlers["textDocument/codeAction"]
    vim.lsp.handlers["textDocument/codeAction"] = function(...)
      local params = select(2, ...)
      -- Include all diagnostic sources for code actions
      if params and params.context and params.context.diagnostics then
        -- Keep track of all diagnostic sources seen
        local sources = {}
        for _, diagnostic in ipairs(params.context.diagnostics) do
          if diagnostic.source then
            sources[diagnostic.source] = true
          end
        end

        -- Include specific linting sources like eslint, ruff, etc.
        -- Adding common linting tools to be included in code actions
        for source, _ in pairs(sources) do
          if source:match("eslint") or source:match("ruff") or
              source:match("pylint") or source:match("mypy") then
            -- Set the only flag to nil to include all code actions, not just specific ones
            params.context.only = nil
            break
          end
        end
      end

      return orig_code_action_handler(...)
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

        -- Add a specific keybinding for linting fixes
        opts.desc = "Apply linting fixes"
        vim.keymap.set("n", "<leader>lx", function()
          vim.lsp.buf.code_action({
            context = {
              diagnostics = vim.diagnostic.get(0), -- Get all diagnostics in current buffer
              only = { "quickfix" }                -- Target quickfix actions, which most linters use
            }
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
        local settings_ok, settings = pcall(dofile, project_settings_file)
        if settings_ok and settings and settings.lsp then
          return settings.lsp
        end
      end
      return {}
    end

    -- Load project-specific settings
    local project_settings = load_project_settings()

    -- Get list of available language servers
    local available_servers = {}
    if mason_lspconfig_ok then
      -- Get servers that are available through mason-lspconfig
      available_servers = mason_lspconfig.get_installed_servers()
    end

    -- Utility function to safely setup a language server
    local function setup_server(server_name, config_func)
      -- Check if the server is available before setting it up
      if type(lspconfig[server_name]) ~= "table" or type(lspconfig[server_name].setup) ~= "function" then
        vim.notify("Language server '" .. server_name .. "' not available. Make sure it's installed via Mason.",
          vim.log.levels.WARN)
        return false
      end

      -- Setup the server with either the provided config function or default config
      if type(config_func) == "function" then
        config_func()
      else
        -- Add project-specific settings if they exist
        local server_settings = project_settings[server_name] or {}
        local default_settings = {}
        -- Merge settings
        local merged_settings = vim.tbl_deep_extend("force", default_settings, server_settings)

        lspconfig[server_name].setup({
          capabilities = capabilities,
          settings = merged_settings,
        })
      end

      return true
    end

    -- Setup basic LSP server configurations
    local function setup_servers()
      -- Define server configuration functions
      local server_configs = {
        emmet_ls = function()
          -- configure emmet language server
          lspconfig["emmet_ls"].setup({
            capabilities = capabilities,
            filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
          })
        end,

        pyright = function()
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

        ruff = function()
          -- Setup ruff for Python linting and formatting
          lspconfig["ruff"].setup({
            capabilities = capabilities,
            on_attach = function(client, _)
              -- Enable full capabilities including code actions for linting fixes
              client.server_capabilities.codeActionProvider = true

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

        lua_ls = function()
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

        ts_ls = function()
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
              -- Keep code action support for ESLint fixes
              client.server_capabilities.codeActionProvider = true

              -- Disable formatting in favor of eslint/prettier
              client.server_capabilities.documentFormattingProvider = false
              client.server_capabilities.documentRangeFormattingProvider = false
            end,
          })
        end,

        eslint = function()
          -- Setup ESLint LSP for fixable linting diagnostics
          lspconfig["eslint"].setup({
            capabilities = capabilities,
            on_attach = function(client, bufnr)
              -- Enable code actions for ESLint fixes
              client.server_capabilities.codeActionProvider = true

              -- Add specific ESLint fix command
              vim.api.nvim_buf_create_user_command(bufnr, "EslintFix", function()
                vim.cmd("EslintFixAll")
              end, { desc = "Fix all ESLint issues" })

              -- Add keymap for ESLint fixes
              vim.keymap.set("n", "<leader>ef", ":EslintFix<CR>",
                { buffer = bufnr, desc = "Fix all ESLint issues" })
            end,
            settings = {
              eslint = {
                enable = true,
                run = "onSave",
                autoFixOnSave = false, -- We'll use the command instead for more control
              }
            }
          })
        end,
      }

      -- Use mason-lspconfig handlers if available
      if mason_lspconfig_ok and mason_lspconfig.setup_handlers then
        mason_lspconfig.setup_handlers({
          -- Default handler for installed servers
          function(server_name)
            -- Use specific config function if available or default config
            local config_func = server_configs[server_name]
            setup_server(server_name, config_func)
          end,
        })
      else
        -- Fallback - manually setup servers with known configurations
        vim.notify("Using fallback LSP server configuration method", vim.log.levels.WARN)

        -- Setup servers with specific configurations
        for server_name, config_func in pairs(server_configs) do
          setup_server(server_name, config_func)
        end

        -- Setup common servers with basic configuration
        local common_servers = {
          "pyright", "lua_ls", "ts_ls", "html", "cssls", "jsonls", "bashls"
        }

        for _, server_name in ipairs(common_servers) do
          -- Only try to set up if not already set up
          if not server_configs[server_name] then
            setup_server(server_name)
          end
        end
      end
    end

    -- Set up LSP servers with error handling
    local setup_success, setup_error = pcall(setup_servers)
    if not setup_success then
      vim.notify("Failed to setup LSP servers: " .. setup_error, vim.log.levels.ERROR)

      -- Log more detailed error information to help with debugging
      vim.schedule(function()
        local debug_info = "LSP setup error details:\n"
        debug_info = debug_info .. "- Error message: " .. setup_error .. "\n"
        debug_info = debug_info .. "- Mason available: " .. tostring(mason_ok) .. "\n"
        debug_info = debug_info .. "- Mason-lspconfig available: " .. tostring(mason_lspconfig_ok) .. "\n"

        -- Log to a file in the Neovim data directory
        local log_file = vim.fn.stdpath("data") .. "/lsp_setup_error.log"
        local file = io.open(log_file, "w")
        if file then
          file:write(debug_info)
          file:close()
          vim.notify("Error details written to: " .. log_file, vim.log.levels.INFO)
        end
      end)
    end

    -- Create user command to reload project settings
    vim.api.nvim_create_user_command("LspReloadProjectSettings", function()
      vim.notify("Reloading project settings...", vim.log.levels.INFO)
      vim.cmd("LspRestart")
    end, { desc = "Reload project-specific LSP settings" })

    -- Create a command to list available language servers
    vim.api.nvim_create_user_command("LspListServers", function()
      local servers = {}
      for server_name, _ in pairs(lspconfig) do
        table.insert(servers, server_name)
      end
      table.sort(servers)

      local output = "Available language servers:\n"
      for _, server_name in ipairs(servers) do
        output = output .. "- " .. server_name .. "\n"
      end

      vim.notify(output, vim.log.levels.INFO)
    end, { desc = "List all available language servers" })
  end,
}
