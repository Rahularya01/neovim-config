return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- For file icons
    "famiu/bufdelete.nvim",        -- Handle buffer deletion gracefully
    "tiagovla/scope.nvim",         -- Better tab-local buffers
  },
  event = "VeryLazy",              -- Load after startup for better performance
  config = function()
    -- Initialize scope.nvim for tab-local buffers
    require("scope").setup()

    -- Setup with Catppuccin integration
    require("bufferline").setup({
      highlights = require("catppuccin.groups.integrations.bufferline").get(),
      options = {
        mode = "buffers",
        numbers = "ordinal", -- Show buffer numbers for easier navigation
        close_command = "Bdelete! %d",
        right_mouse_command = "Bdelete! %d",
        left_mouse_command = "buffer %d",
        middle_mouse_command = nil,
        indicator = {
          icon = "▎", -- Indicator for current buffer
          style = "icon",
        },
        buffer_close_icon = "󰅖",
        modified_icon = "●",
        close_icon = "󰅗",
        left_trunc_marker = "",
        right_trunc_marker = "",
        max_name_length = 18,
        max_prefix_length = 15,
        tab_size = 18,
        diagnostics = "nvim_lsp", -- Show diagnostics in buffers (requires LSP)
        diagnostics_update_in_insert = false,
        diagnostics_indicator = function(count, level)
          local icons = {
            error = " ",
            warning = " ",
            info = " ",
            hint = " ",
          }
          local icon = icons[level:lower()] or icons.hint
          return " " .. icon .. count
        end,
        custom_filter = function(buf_number, buf_numbers)
          -- Filter out certain filetypes from the tabline
          local excluded_ft = { "qf", "fugitive", "git", "help", "TelescopePrompt", "TelescopeResults" }
          local buf_ft = vim.bo[buf_number].filetype
          if vim.tbl_contains(excluded_ft, buf_ft) then
            return false
          end
          return true
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            text_align = "center",
            separator = true,
            highlight = "Directory",
          },
          {
            filetype = "NvimTree",
            text = "File Explorer",
            text_align = "center",
            separator = true,
          },
          {
            filetype = "aerial",
            text = "Outline",
            text_align = "center",
            separator = true,
          },
        },
        color_icons = true,
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        persist_buffer_sort = true,
        separator_style = "slant", -- "slant", "thick", "thin", or {"any", "any"}
        enforce_regular_tabs = false,
        always_show_bufferline = true,
        sort_by = "insert_after_current", -- Better ordering for new buffers
        hover = {
          enabled = true,
          delay = 100,
          reveal = { "close" }
        },
      },
    })

    -- Advanced keymaps for bufferline with descriptions
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
    end

    -- Navigation
    map("n", "<S-h>", ":BufferLineCyclePrev<CR>", "Previous buffer")
    map("n", "<S-l>", ":BufferLineCycleNext<CR>", "Next buffer")
    map("n", "[b", ":BufferLineCyclePrev<CR>", "Previous buffer")
    map("n", "]b", ":BufferLineCycleNext<CR>", "Next buffer")

    -- Reordering
    map("n", "[B", ":BufferLineMovePrev<CR>", "Move buffer left")
    map("n", "]B", ":BufferLineMoveNext<CR>", "Move buffer right")

    -- Go to buffer by number (1-9)
    for i = 1, 9 do
      map("n", "<leader>" .. i, function()
        require("bufferline").go_to_buffer(i, true)
      end, "Go to buffer " .. i)
    end

    -- Go to last buffer
    map("n", "<leader>0", function()
      require("bufferline").go_to_buffer(-1, true)
    end, "Go to last buffer")

    -- Close buffers
    map("n", "<C-x>", ":Bdelete<CR>", "Close current buffer")
    map("n", "<leader>bc", ":Bdelete<CR>", "Close current buffer")
    map("n", "<leader>bl", ":BufferLineCloseLeft<CR>", "Close all buffers to the left")
    map("n", "<leader>br", ":BufferLineCloseRight<CR>", "Close all buffers to the right")
    map("n", "<leader>bo", ":BufferLineCloseOthers<CR>", "Close all other buffers")
    map("n", "<leader>bp", ":BufferLineTogglePin<CR>", "Toggle pin buffer")
    map("n", "<leader>bP", ":BufferLineCloseRight<CR>:BufferLineCloseLeft<CR>", "Close all except current")

    -- Close all buffers command fix
    map("n", "<leader>ba", function()
      -- Get all listed buffers
      local buffers = vim.fn.getbufinfo({ buflisted = true })

      -- Store current buffer to prevent errors if it gets deleted
      local current = vim.fn.bufnr('%')

      -- Delete all buffers except the current one first
      for _, buf in ipairs(buffers) do
        if buf.bufnr ~= current then
          vim.cmd(string.format("silent! Bdelete! %d", buf.bufnr))
        end
      end

      -- Then delete the current buffer and create a new one
      vim.cmd("enew")
      vim.cmd(string.format("silent! Bdelete! %d", current))
    end, "Close all buffers")

    -- Buffer picker with enhanced Telescope integration
    map("n", "<leader>bb", function()
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")

      require("telescope.builtin").buffers({
        sort_mru = true,
        sort_lastused = true,
        previewer = false,
        theme = "dropdown",
        layout_config = {
          width = 0.5,
          height = 0.4,
        },
        attach_mappings = function(prompt_bufnr, map)
          -- Delete all buffers with <C-a> (this will close Telescope)
          local delete_all_bufs = function()
            -- Close the telescope window first
            actions.close(prompt_bufnr)

            -- Schedule the deletion to happen after telescope is closed
            vim.schedule(function()
              -- Get all listed buffers
              local buffers = vim.fn.getbufinfo({ buflisted = true })

              -- Delete all buffers one by one
              for _, buf in ipairs(buffers) do
                -- Try Bdelete first (from bufdelete.nvim)
                pcall(function()
                  vim.cmd(string.format("silent! Bdelete! %d", buf.bufnr))
                end)

                -- Fallback to native deletion if buffer still exists
                if vim.api.nvim_buf_is_valid(buf.bufnr) then
                  pcall(vim.api.nvim_buf_delete, buf.bufnr, { force = true })
                end
              end

              -- Create a new empty buffer
              vim.cmd("enew")
              print("All buffers closed")
            end)
          end

          map("i", "<C-a>", delete_all_bufs)
          map("n", "<C-a>", delete_all_bufs)

          -- Add multi-delete with <Tab> to mark and <C-d> to delete marked
          local toggle_selection = function()
            actions.toggle_selection(prompt_bufnr)
            actions.move_selection_next(prompt_bufnr)
          end

          -- Tab to select multiple buffers
          map("i", "<Tab>", toggle_selection)
          map("n", "<Tab>", toggle_selection)

          -- Delete all selected buffers with <C-d>
          local delete_selected = function()
            local selection = action_state.get_selected_entry(prompt_bufnr)
            local picker = action_state.get_current_picker(prompt_bufnr)
            local selections = picker:get_multi_selection()

            if #selections == 0 then
              -- If nothing is explicitly selected, just delete current selection
              if selection then
                local bufnr = selection.bufnr
                pcall(function() vim.cmd(string.format("silent! Bdelete! %d", bufnr)) end)
                if vim.api.nvim_buf_is_valid(bufnr) then
                  pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
                end
              end
            else
              -- Delete all selected buffers
              for _, sel in ipairs(selections) do
                local bufnr = sel.bufnr
                pcall(function() vim.cmd(string.format("silent! Bdelete! %d", bufnr)) end)
                if vim.api.nvim_buf_is_valid(bufnr) then
                  pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
                end
              end
            end

            -- Close and reopen Telescope to refresh buffer list
            actions.close(prompt_bufnr)
            vim.defer_fn(function()
              require("telescope.builtin").buffers({
                sort_mru = true,
                sort_lastused = true,
                previewer = false,
                theme = "dropdown",
                layout_config = {
                  width = 0.5,
                  height = 0.4,
                }
              })
            end, 10) -- Small delay to ensure buffer is deleted first
          end

          map("i", "<C-d>", delete_selected)
          map("n", "<C-d>", delete_selected)

          -- Keep default mappings
          return true
        end,
      })
    end, "Show buffer list with enhanced delete actions")
    -- Add a separate keymap specifically for closing all buffers from telescope
    -- Pick specific visible buffer
    map("n", "<leader>bs", ":BufferLinePick<CR>", "Pick a buffer")

    -- Sort buffers by directory
    map("n", "<leader>bd", ":BufferLineSortByDirectory<CR>", "Sort buffers by directory")

    -- Sort buffers by extension
    map("n", "<leader>be", ":BufferLineSortByExtension<CR>", "Sort buffers by extension")

    -- Quickly toggle buffer groups
    map("n", "<leader>bg", ":BufferLineToggleGroups<CR>", "Toggle buffer groups")

    -- Handle buffer closing with tab closing if empty
    vim.api.nvim_create_autocmd("BufEnter", {
      nested = true,
      callback = function()
        -- Don't close if this is the last buffer and is a file explorer
        if #vim.api.nvim_list_wins() == 1 and
            (vim.bo.filetype == "neo-tree" or vim.bo.filetype == "NvimTree") then
          vim.cmd("quit")
        end
      end,
    })
  end,
}
