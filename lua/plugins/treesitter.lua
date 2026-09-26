local gh = require("config.pack").gh
vim.pack.add({
  { src = gh("nvim-treesitter/nvim-treesitter"), version = "main" },
  { src = gh("nvim-treesitter/nvim-treesitter-textobjects"), version = "main" },
  gh("windwp/nvim-ts-autotag"),
  gh("folke/ts-comments.nvim"),
})

local parsers = {
  "bash",
  "c",
  "cpp",
  "css",
  "diff",
  "dockerfile",
  "go",
  "gomod",
  "gosum",
  "graphql",
  "html",
  "javascript",
  "jsdoc",
  "json",
  "json5",
  "lua",
  "luadoc",
  "luap",
  "markdown",
  "markdown_inline",
  "prisma",
  "python",
  "query",
  "regex",
  "rust",
  "scss",
  "sql",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "xml",
  "yaml",
  "git_config",
  "gitcommit",
  "git_rebase",
  "gitignore",
  "http",
  "make",
}
require("nvim-treesitter").install(parsers)

-- Highlight / indent via treesitter for any filetype that has a parser.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
  callback = function(ev)
    local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
    if not lang or not pcall(vim.treesitter.start, ev.buf, lang) then
      return
    end
    vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- Textobjects: af/if function, ac/ic class, aa/ia argument; ]f [f ]] [[ motions.
require("nvim-treesitter-textobjects").setup({
  select = { lookahead = true },
  move = { set_jumps = true },
})
local sel = require("nvim-treesitter-textobjects.select")
for key, query in pairs({
  af = "@function.outer",
  ["if"] = "@function.inner",
  ac = "@class.outer",
  ic = "@class.inner",
  aa = "@parameter.outer",
  ia = "@parameter.inner",
}) do
  vim.keymap.set({ "x", "o" }, key, function()
    sel.select_textobject(query, "textobjects")
  end, { desc = query })
end
local move = require("nvim-treesitter-textobjects.move")
for key, spec in pairs({
  ["]f"] = { move.goto_next_start, "@function.outer", "Next function" },
  ["[f"] = { move.goto_previous_start, "@function.outer", "Prev function" },
  ["]]"] = { move.goto_next_start, "@class.outer", "Next class" },
  ["[["] = { move.goto_previous_start, "@class.outer", "Prev class" },
  ["]a"] = { move.goto_next_start, "@parameter.inner", "Next argument" },
  ["[a"] = { move.goto_previous_start, "@parameter.inner", "Prev argument" },
}) do
  vim.keymap.set({ "n", "x", "o" }, key, function()
    spec[1](spec[2], "textobjects")
  end, { desc = spec[3] })
end

-- editor.linkedEditing / auto-rename-tag
require("nvim-ts-autotag").setup({ opts = { enable_close = true, enable_rename = true } })
require("ts-comments").setup()
