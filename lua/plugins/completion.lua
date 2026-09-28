local gh = require("config.pack").gh
vim.pack.add({
  -- Tagged releases only (never main).
  { src = gh("saghen/blink.cmp"), version = vim.version.range("1.*") },
  gh("rafamadriz/friendly-snippets"),
})

require("blink.cmp").setup({
  keymap = {
    preset = "enter",
    -- Cursor: ctrl+j / ctrl+k move through suggestions
    ["<C-j>"] = { "select_next", "fallback" },
    ["<C-k>"] = { "select_prev", "fallback_to_mappings" },
    -- Tab: accept Copilot ghost text first, then a next edit suggestion, then
    -- snippet jump, then a real tab. Copilot loads after startup (init.lua).
    ["<Tab>"] = {
      function()
        return vim.lsp.inline_completion.get()
      end,
      function(cmp)
        if vim.b.nes_state then
          cmp.hide()
          local nes = require("copilot-lsp.nes")
          return nes.apply_pending_nes() and nes.walk_cursor_end_edit()
        end
      end,
      "snippet_forward",
      "fallback",
    },
    ["<S-Tab>"] = { "snippet_backward", "fallback" },
  },
  appearance = { nerd_font_variant = "mono" },
  completion = {
    accept = { auto_brackets = { enabled = true } },
    list = { selection = { preselect = true, auto_insert = false } },
    menu = {
      border = "rounded",
      draw = {
        treesitter = { "lsp" },
        columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "source_name" } },
      },
    },
    documentation = { auto_show = true, auto_show_delay_ms = 200, window = { border = "rounded" } },
    ghost_text = { enabled = false }, -- Copilot owns ghost text
  },
  signature = { enabled = true, window = { border = "rounded" } },
  sources = {
    default = { "lazydev", "lsp", "path", "snippets", "buffer" },
    providers = {
      lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
    },
  },
  cmdline = { enabled = true, completion = { menu = { auto_show = true } } },
  -- Supply chain: never download the prebuilt binary; config/pack.lua builds it
  -- from source with `cargo build --locked`. Lua matcher is used until built.
  fuzzy = { implementation = "prefer_rust", prebuilt_binaries = { download = false } },
})
