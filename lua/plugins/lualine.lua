local platform = require("config.platform")

return {
  "nvim-lualine/lualine.nvim",
  cond = platform.not_vscode,
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local function show_macro_recording()
      local recording_register = vim.fn.reg_recording()
      if recording_register == "" then
        return ""
      end
      return "● Recording @" .. recording_register
    end

    local lualine_augroup = vim.api.nvim_create_augroup("LualineRecording", { clear = true })
    vim.api.nvim_create_autocmd("RecordingEnter", {
      group = lualine_augroup,
      callback = function()
        require("lualine").refresh({ place = { "statusline" } })
      end,
    })
    vim.api.nvim_create_autocmd("RecordingLeave", {
      group = lualine_augroup,
      callback = function()
        local timer = vim.uv.new_timer()
        timer:start(
          50,
          0,
          vim.schedule_wrap(function()
            require("lualine").refresh({ place = { "statusline" } })
          end)
        )
      end,
    })

    local hide_in_width = function()
      return vim.fn.winwidth(0) > 80
    end

    require("lualine").setup({
      options = {
        theme = "gruvbox",
        
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        globalstatus = true,
        disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
      },
      extensions = { "trouble" },
      sections = {
        lualine_a = { { "mode", separator = { left = " " }, right_padding = 2 } },
        lualine_b = {
          { "branch", icon = "" },
          { "diff", symbols = { added = " ", modified = " ", removed = " " } },
        },
        lualine_c = {
          { "filename", file_status = true, path = 1 }, 
        },
        lualine_x = {
          {
            show_macro_recording,
            color = { fg = "#ff9e64", gui = "bold" },
          },
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = { error = " ", warn = " ", info = " ", hint = "󰛩 " },
          },
          { "filetype", cond = hide_in_width },
        },
        lualine_y = { "progress" },
        lualine_z = {
          { "location", separator = { right = " " }, left_padding = 2 },
          {
            function()
              return ""
            end,
            color = function()
              local status = require("sidekick.status").get()
              if status then
                return status.kind == "Error" and "DiagnosticError" or status.busy and "DiagnosticWarn" or "Special"
              end
            end,
            cond = function()
              return require("sidekick.status").get() ~= nil
            end,
          },
        },
      },
      inactive_sections = {
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "location" },
      },
    })
  end,
}
