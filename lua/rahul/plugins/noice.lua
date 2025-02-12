return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  config = function()
    local notify_ok, notify = pcall(require, "notify")
    if notify_ok then
      notify.setup({
        background_colour = "#000000", -- Fix: Corrected the spelling
        render = "compact",
        stages = "fade",
        top_down = false
      })
      vim.notify = notify
    end

    local noice_ok, noice = pcall(require, "noice")
    if noice_ok then
      noice.setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = false,
        },
      })
    end
  end
}
