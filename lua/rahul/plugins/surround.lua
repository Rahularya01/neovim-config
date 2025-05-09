return {
  "kylechui/nvim-surround",
  event = { "BufReadPre", "BufNewFile" },
  version = "*", -- Use for stability; omit to use `main` branch for the latest features
  config = function()
    -- Safely require the module with error handling
    local ok, surround = pcall(require, "nvim-surround")
    if not ok then
      vim.notify("Failed to load nvim-surround", vim.log.levels.ERROR)
      return
    end

    -- Setup with customized options
    surround.setup({
      -- Use more intuitive keymaps (optional)
      keymaps = {
        insert = "<C-g>s",       -- Insert mode
        insert_line = "<C-g>S",  -- Insert mode, line-wise
        normal = "ys",           -- Normal mode
        normal_cur = "yss",      -- Normal mode, current line
        normal_line = "yS",      -- Normal mode, line-wise
        normal_cur_line = "ySS", -- Normal mode, current line, line-wise
        visual = "S",            -- Visual mode
        visual_line = "gS",      -- Visual mode, line-wise
        delete = "ds",           -- Delete surroundings
        change = "cs",           -- Change surroundings
      },
      -- Default settings are good, but you can customize further:
      -- Move cursor to the end after surrounding in visual mode
      move_cursor = "end",
      -- Enable highlighting during surround operations
      highlight = { duration = 500 },
    })
  end,
}
