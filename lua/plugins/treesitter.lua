return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    -- Install parsers for all languages used in this config.
    -- This is a no-op if parsers are already up to date.
    require("nvim-treesitter").install({
      "bash",
      "c",
      "cpp",
      "css",
      "diff",
      "go",
      "gomod",
      "html",
      "javascript",
      "json",
      "lua",
      "luadoc",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "regex",
      "rust",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "yaml",
    })

    -- Enable treesitter highlighting and folding for all filetypes that have a parser.
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter_attach", { clear = true }),
      callback = function(ev)
        local ok = pcall(vim.treesitter.start, ev.buf)
        if ok then
          -- Use treesitter-based folding when a parser is available
          local win = vim.api.nvim_get_current_win()
          vim.wo[win][0].foldmethod = "expr"
          vim.wo[win][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        end
      end,
    })
  end,
}
