return {
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    { 'mason-org/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- JSON schemas for better JSON/JSONC support
    'b0o/schemastore.nvim',

    -- Useful status updates for LSP.
    {
      'j-hui/fidget.nvim',
      opts = {
        notification = {
          window = { winblend = 0 },
        },
      },
    },

    -- Allows extra capabilities provided by nvim-cmp
    'hrsh7th/cmp-nvim-lsp',
  },
  config = function()
    -- Global LSP performance optimizations
    vim.lsp.set_log_level 'ERROR'

    -- Diagnostics UI
    vim.diagnostic.config {
      virtual_text = { spacing = 4 },
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        focusable = false,
        style = 'minimal',
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
        format = function(d)
          return string.format('%s (%s)', d.message, d.source)
        end,
      },
    }

    -- Diagnostic signs
    local signs = { Error = '', Warn = '', Hint = '', Info = '' }
    for type, icon in pairs(signs) do
      local hl = 'DiagnosticSign' .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
    end

    -- Dim unused variables
    vim.api.nvim_create_autocmd('ColorScheme', {
      pattern = '*',
      callback = function()
        vim.api.nvim_set_hl(0, 'DiagnosticUnnecessary', { fg = '#6c7086', italic = true, undercurl = false })
      end,
    })
    vim.cmd 'doautocmd ColorScheme'

    -- Common LSP keymaps & features
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
        map('K', vim.lsp.buf.hover, 'Hover Documentation')
        map('<leader>k', vim.lsp.buf.signature_help, 'Signature Documentation')

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })
          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(e2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = e2.buf }
            end,
          })
        end

        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    -- Capabilities (nvim-cmp)
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    -- lspconfig util
    local util = require 'lspconfig.util'

    -- Servers
    local servers = {
      ts_ls = {
        filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = 'literal',
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
            preferences = { disableSuggestions = false },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = 'all',
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
        },
        init_options = { preferences = { disableSuggestions = false } },
      },
      emmet_ls = {
        filetypes = { 'css', 'eruby', 'html', 'javascript', 'javascriptreact', 'less', 'sass', 'scss', 'pug', 'typescriptreact' },
        init_options = {
          html = { options = { ['bem.enabled'] = true } },
          showExpandedAbbreviation = 'in_markup',
          showAbbreviationSuggestions = true,
          showSuggestionsAsSnippets = false,
        },
        settings = {
          emmet = {
            includeLanguages = { javascript = 'javascriptreact', typescript = 'typescriptreact' },
            triggerExpansionOnTab = false,
          },
        },
      },
      eslint = {
        filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue', 'svelte' },
        settings = {
          eslint = {
            enable = true,
            autoFixOnSave = false,
            validate = 'probe',
            packageManager = 'npm',
            useESLintClass = false,
            experimental = { useFlatConfig = true },
            codeAction = {
              disableRuleComment = { enable = true, location = 'separateLine' },
              showDocumentation = { enable = true },
            },
            options = { cache = true, cacheLocation = '.eslintcache' },
          },
        },
        on_attach = function(client, _)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
          if client.server_capabilities.semanticTokensProvider then
            client.server_capabilities.semanticTokensProvider = nil
          end
          client.flags = client.flags or {}
          client.flags.debounce_text_changes = 500
        end,
      },
      html = { filetypes = { 'html', 'twig', 'hbs', 'javascriptreact', 'typescriptreact' } },
      cssls = {
        filetypes = { 'css', 'scss', 'less' },
        settings = {
          css = { validate = true, lint = { unknownAtRules = 'ignore' } },
          scss = { validate = true, lint = { unknownAtRules = 'ignore' } },
          less = { validate = true, lint = { unknownAtRules = 'ignore' } },
        },
      },

      -- ✅ C/C++ via clangd (with stronger root_dir + optional offsetEncoding)
      clangd = {
        filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
        cmd = { 'clangd', '--background-index', '--clang-tidy', '--completion-style=detailed', '--header-insertion=never' },
        root_dir = util.root_pattern('compile_commands.json', 'compile_flags.txt', '.clangd', '.git'),
        capabilities = { offsetEncoding = { 'utf-16' } }, -- merged with global capabilities below
      },

      tailwindcss = {
        filetypes = { 'html', 'css', 'scss', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
        settings = {
          tailwindCSS = {
            experimental = {
              classRegex = {
                { 'cva\\(([^)]*)\\)', '["\'`]([^"\'`]*).*?["\'`]' },
                { 'cx\\(([^)]*)\\)', "(?:'|\"|`)([^']*)(?:'|\"|`)" },
                { 'className\\s*=\\s*["\']([^"\']*)["\']', '([^"\'\\s]*)' },
              },
            },
          },
        },
      },
      jsonls = {
        filetypes = { 'json', 'jsonc' },
        settings = {
          json = { schemas = require('schemastore').json.schemas(), validate = { enable = true } },
        },
      },
      yamlls = {
        settings = {
          yaml = {
            validate = true,
            schemaStore = { enable = false, url = '' },
            schemas = require('schemastore').yaml.schemas(),
          },
        },
      },
      lua_ls = {
        settings = {
          Lua = {
            completion = { callSnippet = 'Replace' },
            runtime = { version = 'LuaJIT' },
            workspace = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file('', true) },
            diagnostics = { globals = { 'vim' }, disable = { 'missing-fields' }, unusedLocalExclude = { '_*' } },
            format = { enable = false },
            hint = { enable = true },
          },
        },
      },
    }

    -- Ensure servers & tools are installed (added clangd ✅)
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'prettierd',
      'stylua',
      'ruff',
      'eslint_d',
      'eslint-lsp',
      'emmet-ls',
      'clangd', -- <-- important
    })
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    -- Setup each server
    local lspconfig = require 'lspconfig'
    for server, cfg in pairs(servers) do
      cfg.capabilities = vim.tbl_deep_extend('force', {}, capabilities, cfg.capabilities or {})
      cfg.flags = cfg.flags or {}
      cfg.flags.debounce_text_changes = cfg.flags.debounce_text_changes or 300
      cfg.flags.allow_incremental_sync = cfg.flags.allow_incremental_sync or true
      lspconfig[server].setup(cfg)
    end
  end,
}
