return {
  "saghen/blink.cmp",
  dependencies = {
    "rafamadriz/friendly-snippets",
    "fang2hou/blink-copilot",
  },
  version = "1.*",
  opts = {
    keymap = {
      preset = "super-tab",
      ["<Tab>"] = {
        function(cmp)
          if require("sidekick").nes_jump_or_apply() then
            return true
          end

          if cmp.is_menu_visible() then
            if cmp.snippet_active() then
              return cmp.accept()
            else
              return cmp.select_and_accept()
            end
          end

          local ok, suggestion = pcall(vim.fn["copilot#GetDisplayedSuggestion"])
          if ok and suggestion.text and suggestion.text ~= "" then
            local accept = vim.fn["copilot#Accept"]("")
            if accept ~= "" then
              vim.api.nvim_feedkeys(accept, "n", false)
              return true
            end
          end

          if cmp.snippet_active() then
            return cmp.accept()
          else
            return cmp.select_and_accept()
          end
        end,
        "snippet_forward",
        "fallback",
      },
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-space>"] = { "show", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
      ["<C-b>"] = { "cancel", "fallback" },
    },
    appearance = {
      nerd_font_variant = "mono",
    },
    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = {
          border = "single",
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
        },
      },
      menu = {
        border = "single",
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
        draw = {
          columns = {
            { "kind_icon" },
            { "label", "label_description", gap = 1 },
            { "kind" },
          },
        },
      },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer", "copilot" },
      providers = {
        copilot = {
          name = "copilot",
          module = "blink-copilot",
          score_offset = 100,
          async = true,
        },
      },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" },
}
