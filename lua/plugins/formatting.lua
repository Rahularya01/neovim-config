local gh = require("config.pack").gh
vim.pack.add({ gh("stevearc/conform.nvim") })

local web = { "prettierd", "prettier", stop_after_first = true }

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = web,
    javascriptreact = web,
    typescript = web,
    typescriptreact = web,
    vue = web,
    svelte = web,
    astro = web,
    css = web,
    scss = web,
    less = web,
    html = web,
    json = web,
    jsonc = web,
    json5 = web,
    yaml = web,
    markdown = web,
    graphql = web,
    python = { "ruff_organize_imports", "ruff_format" },
    go = { "goimports", "gofumpt" },
    rust = { lsp_format = "prefer" }, -- rust-analyzer (rustfmt)
    c = { "clang-format" },
    cpp = { "clang-format" },
    sh = { "shfmt" },
    bash = { "shfmt" },
    zsh = { "shfmt" },
    toml = { "taplo" },
    ["_"] = { "trim_whitespace" },
  },
  default_format_opts = { lsp_format = "fallback" },
  -- editor.formatOnSave = true
  format_on_save = function(buf)
    if vim.g.autoformat == false or vim.b[buf].autoformat == false then
      return
    end
    return { timeout_ms = 1500 }
  end,
})
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

vim.keymap.set({ "n", "x" }, "<leader>cf", function()
  require("conform").format({ async = true })
end, { desc = "Format" })
Snacks.toggle({
  name = "Format on save",
  get = function()
    return vim.g.autoformat ~= false
  end,
  set = function(on)
    vim.g.autoformat = on
  end,
}):map("<leader>uf")
