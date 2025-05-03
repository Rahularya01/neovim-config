return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      -- Organize formatters by file type
      formatters_by_ft = {
        -- Web development
        javascript = { "prettierd" }, -- Fallback to prettier if prettierd fails
        typescript = { "prettierd" },
        javascriptreact = { "prettierd" },
        typescriptreact = { "prettierd" },
        svelte = { "prettierd" },
        css = { "prettierd" },
        html = { "prettierd" },
        json = { "prettierd" },
        yaml = { "prettierd" },
        markdown = { "prettierd" },
        graphql = { "prettierd" },
        liquid = { "prettierd" },

        -- Lua
        lua = { "stylua" },

        -- Python
        python = { "isort", "black" },

        -- Additional formatters for common languages
        go = { "gofmt", "goimports" },
        rust = { "rustfmt" },
        sh = { "shfmt" },
      },

      -- Define formatter-specific options
      formatters = {
        prettier = {
          prepend_args = { "--prose-wrap", "always" },
        },
        shfmt = {
          prepend_args = { "-i", "2", "-ci" }, -- 2 space indentation, indent case statements
        },
      },

      -- Format on save configuration
      format_on_save = function(bufnr)
        -- Don't format on save for large files (> 100KB)
        if vim.api.nvim_buf_get_option(bufnr, "modified") and
            vim.api.nvim_buf_get_lines(bufnr, 0, -1, false):len() > 100000 then
          return
        end

        return {
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        }
      end,

      -- Set up a format notification
      notify_on_error = true,
    })

    -- Enhanced keymaps
    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format file or range (in visual mode)" })

    -- Add a keymap to format and write
    vim.keymap.set("n", "<leader>mw", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
      vim.cmd("w")
    end, { desc = "Format and save file" })
  end,
  -- Add dependencies for prettier
  dependencies = {
    "mason.nvim", -- Ensure formatter binaries are installed
  },
}
