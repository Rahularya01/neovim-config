return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",           -- Mason dependency
    "williamboman/mason-lspconfig.nvim", -- Mason-lspconfig dependency
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
    -- Create a dedicated namespace for LSP diagnostics - THIS IS IMPORTANT to avoid duplicates
    local lsp_ns = vim.api.nvim_create_namespace("lsp-diagnostics")

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

    -- CENTRALIZED DIAGNOSTICS HANDLER - avoids duplicates
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
      function(_, result, ctx, config)
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        local bufnr = vim.uri_to_bufnr(result.uri)

        -- Only process valid buffers
        if not vim.api.nvim_buf_is_valid(bufnr) then
          return
        end

        -- Convert LSP diagnostics to vim diagnostics format
        -- Handle the case where diagnostics might be nil
        local diagnostics = {}

        -- Check if result.diagnostics exists and is not nil before processing
        if result and result.diagnostics then
          -- Safe conversion with error handling
          local status, conv_diagnostics = pcall(vim.lsp.diagnostic.on_publish_diagnostics, _, result, ctx, config)
          if status and conv_diagnostics then
            diagnostics = conv_diagnostics

            -- Add source information only if we have diagnostics
            for _, diagnostic in ipairs(diagnostics) do
              diagnostic.source = diagnostic.source or (client and client.name or "unknown")
            end
          end
        end

        -- Set diagnostics with our dedicated namespace
        vim.diagnostic.set(lsp_ns, bufnr, diagnostics, {
          severity_sort = true,
          virtual_text = {
            spacing = 4,
            prefix = "●",
          },
          underline = true,
        })
      end,
      {
        -- Diagnostic display options
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

    -- UNIFIED CODE ACTION HANDLER - consolidates code actions from all sources
    local orig_code_action_handler = vim.lsp.handlers["textDocument/codeAction"]
    vim.lsp.handlers["textDocument/codeAction"] = function(err, result, ctx, config)
      -- Include all diagnostic sources for code actions
      local params = ctx.params
      if params and params.context and params.context.diagnostics then
        -- Remove any filtering to ensure we get all possible actions
        params.context.only = nil
      end

      -- Call the original handler with our modified context
      return orig_code_action_handler(err, result, ctx, config)
    end

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

    -- Define server configuration functions
    local server_configs = {
      emmet_ls = {
        capabilities = capabilities,
        filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
      },

      pyright = {
        capabilities = capabilities,
        filetypes = { "python" },
        settings = {
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
        },
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
      },

      ruff = {
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
      },

      lua_ls = {
        capabilities = capabilities,
        settings = {
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
        },
      },

      ts_ls = {
        capabilities = capabilities,
        settings = {
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
        },
        on_attach = function(client, _)
          -- Disable formatting in favor of eslint/prettier
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
      },

      eslint = {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
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
      },

      html = {
        capabilities = capabilities,
      },

      cssls = {
        capabilities = capabilities,
      },

      tailwindcss = {
        capabilities = capabilities,
      }
    }

    -- Get mason-lspconfig integration
    local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
    if not mason_lspconfig_ok then
      vim.notify("Mason-lspconfig not loaded! Using direct LSP setup.", vim.log.levels.WARN)

      -- Directly set up servers if mason-lspconfig is not available
      for server_name, server_config in pairs(server_configs) do
        if lspconfig[server_name] then
          -- Merge with project settings if available
          if project_settings[server_name] then
            server_config.settings = vim.tbl_deep_extend("force",
              server_config.settings or {},
              project_settings[server_name] or {})
          end

          lspconfig[server_name].setup(server_config)
        end
      end
    else
      -- Use mason-lspconfig to set up servers with our custom configurations
      mason_lspconfig.setup_handlers({
        -- Default handler for all servers
        function(server_name)
          -- Skip if server is not installed or not supported
          if not lspconfig[server_name] then
            return
          end

          -- Use specific configuration if available
          local server_config = server_configs[server_name] or { capabilities = capabilities }

          -- Merge with project settings if available
          if project_settings[server_name] then
            server_config.settings = vim.tbl_deep_extend("force",
              server_config.settings or {},
              project_settings[server_name] or {})
          end

          lspconfig[server_name].setup(server_config)
        end
      })
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
