return {
  "mfussenegger/nvim-jdtls",
  ft = { "java" },
  dependencies = {
    "williamboman/mason.nvim",
    "saghen/blink.cmp",
  },
  config = function()
    local jdtls = require("jdtls")
    local mason_registry = require("mason-registry")

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "java",
      callback = function()
        local jdtls_pkg = mason_registry.get_package("jdtls")
        local jdtls_path = jdtls_pkg and jdtls_pkg.get_install_path and jdtls_pkg:get_install_path()
          or (vim.fn.stdpath("data") .. "/mason/packages/jdtls")

        local lombok_jar = vim.fn.glob(jdtls_path .. "/lombok-*.jar", 1, 1)[1] or ""

        local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar", 1, 1)[1]
        if not launcher_jar then
          vim.notify("JDTLS launcher jar not found. Run :MasonInstall jdtls", vim.log.levels.ERROR)
          return
        end

        local os_config = "config_linux"
        if vim.fn.has("mac") == 1 then
          os_config = "config_mac"
        elseif vim.fn.has("win32") == 1 then
          os_config = "config_win"
        end

        local workspace_dir = vim.fn.stdpath("data")
          .. "/jdtls-workspace/"
          .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

        local ok_blink, blink = pcall(require, "blink.cmp")
        local capabilities
        if ok_blink then
          capabilities = blink.get_lsp_capabilities()
        else
          capabilities = vim.lsp.protocol.make_client_capabilities()
        end

        local config = {
          cmd = {
            "java",
            "-Declipse.application=org.eclipse.jdt.ls.core.id1",
            "-Dosgi.bundles.defaultStartLevel=4",
            "-Declipse.product=org.eclipse.jdt.ls.core.product",
            "-Dlog.protocol=true",
            "-Dlog.level=ALL",
            "-Xmx1g",
            "--add-modules=ALL-SYSTEM",
            "--add-opens",
            "java.base/java.util=ALL-UNNAMED",
            "--add-opens",
            "java.base/java.lang=ALL-UNNAMED",
          },
          root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),
          settings = {
            java = {
              configuration = {
                updateBuildConfiguration = "interactive",
              },
              maven = {
                downloadSources = true,
              },
              implementationsCodeLens = {
                enabled = true,
              },
              referencesCodeLens = {
                enabled = true,
              },
              format = {
                enabled = false,
              },
            },
          },
          init_options = {
            bundles = {},
            extendedClientCapabilities = {
              progressReportProvider = true,
              classFileContentsSupport = true,
              generateToStringPromptSupport = true,
              hashCodeEqualsPromptSupport = true,
              advancedOrganizeImportsSupport = true,
              advancedExtractRefactoringSupport = true,
              inferSelectionSupport = {
                "extractMethod",
                "extractVariable",
                "extractConstant",
              },
              moveRefactoringSupport = true,
              clientHoverProvider = true,
              clientDocumentSymbolProvider = true,
            },
          },
          capabilities = capabilities,
          on_attach = function(client, bufnr)
            if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
              vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            end

            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false

            local opts = { buffer = bufnr, silent = true }
            vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover" }))
            vim.keymap.set(
              "n",
              "gd",
              vim.lsp.buf.definition,
              vim.tbl_extend("force", opts, { desc = "Go to definition" })
            )
            vim.keymap.set(
              "n",
              "gD",
              vim.lsp.buf.declaration,
              vim.tbl_extend("force", opts, { desc = "Go to declaration" })
            )
            vim.keymap.set(
              "n",
              "gi",
              vim.lsp.buf.implementation,
              vim.tbl_extend("force", opts, { desc = "Go to implementation" })
            )
            vim.keymap.set(
              "n",
              "gr",
              vim.lsp.buf.references,
              vim.tbl_extend("force", opts, { desc = "List references" })
            )
            vim.keymap.set(
              "n",
              "<leader>rn",
              vim.lsp.buf.rename,
              vim.tbl_extend("force", opts, { desc = "Rename symbol" })
            )
            vim.keymap.set(
              "n",
              "<leader>ca",
              vim.lsp.buf.code_action,
              vim.tbl_extend("force", opts, { desc = "Code action" })
            )
            vim.keymap.set("n", "[d", function()
              vim.diagnostic.jump({ count = -1 })
            end, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
            vim.keymap.set("n", "]d", function()
              vim.diagnostic.jump({ count = 1 })
            end, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
            vim.keymap.set(
              "n",
              "<leader>ld",
              vim.diagnostic.open_float,
              vim.tbl_extend("force", opts, { desc = "Line diagnostics" })
            )

            -- Java specific
            vim.keymap.set(
              "n",
              "<leader>co",
              jdtls.organize_imports,
              vim.tbl_extend("force", opts, { desc = "Organize imports" })
            )
            vim.keymap.set(
              "n",
              "<leader>cv",
              jdtls.extract_variable,
              vim.tbl_extend("force", opts, { desc = "Extract variable" })
            )
            vim.keymap.set("v", "<leader>cv", function()
              jdtls.extract_variable(true)
            end, vim.tbl_extend("force", opts, { desc = "Extract variable" }))
            vim.keymap.set(
              "n",
              "<leader>cc",
              jdtls.extract_constant,
              vim.tbl_extend("force", opts, { desc = "Extract constant" })
            )
            vim.keymap.set("v", "<leader>cc", function()
              jdtls.extract_constant(true)
            end, vim.tbl_extend("force", opts, { desc = "Extract constant" }))
            vim.keymap.set("v", "<leader>cm", function()
              jdtls.extract_method(true)
            end, vim.tbl_extend("force", opts, { desc = "Extract method" }))
          end,
        }

        -- Add lombok if available
        if lombok_jar ~= "" then
          table.insert(config.cmd, 2, "-javaagent:" .. lombok_jar)
        end

        -- Add launcher jar
        table.insert(config.cmd, "-jar")
        table.insert(config.cmd, launcher_jar)

        -- Add configuration
        table.insert(config.cmd, "-configuration")
        table.insert(config.cmd, jdtls_path .. "/" .. os_config)

        -- Add workspace
        table.insert(config.cmd, "-data")
        table.insert(config.cmd, workspace_dir)

        jdtls.start_or_attach(config)
      end,
    })
  end,
}
