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

    require("bufferline").setup({
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
        close_icon = "",
        left_trunc_marker = "",
        right_trunc_marker = "",
        max_name_length = 18,
        max_prefix_length = 15,
        tab_size = 18,
        diagnostics = "nvim_lsp", -- Show diagnostics in buffers (requires LSP)
        diagnostics_update_in_insert = false,
        diagnostics_indicator = function(count, level)
          local icon = level:match("error") and " " or " "
          return " " .. icon .. count
        end,
        custom_filter = function(buf_number, buf_numbers)
          -- Filter out certain filetypes from the tabline
          local excluded_ft = { "qf", "fugitive", "git", "help" }
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
        show_close_icon = false,
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
      -- Custom highlights can be defined here if needed
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

    -- Close all buffers
    map("n", "<leader>ba", function()
      local excluded = {} -- Add any buffers you want to exclude
      for _, buf in ipairs(vim.fn.getbufinfo({ buflisted = true })) do
        if not vim.tbl_contains(excluded, buf.bufnr) then
          vim.cmd("Bdelete " .. buf.bufnr)
        end
      end
      vim.cmd("enew")   -- Always open a new buffer after closing all
    end, "Close all buffers")

    -- Buffer picker with enhanced Telescope integration
    map("n", "<leader>bb", function()
      require("telescope.builtin").buffers({
        sort_mru = true,
        ignore_current_buffer = false,
        sort_lastused = true,
        previewer = false,
        theme = "dropdown",
        layout_config = {
          width = 0.5,
          height = 0.4,
        },
      })
    end, "Show buffer list")

    -- Auto-open an empty buffer if the last buffer is closed
    vim.api.nvim_create_autocmd("BufDelete", {
      callback = function()
        if #vim.fn.getbufinfo({ buflisted = true }) == 0 then
          vim.cmd("enew") -- Open a new empty buffer
        end
      end,
    })

    -- Pick specific visible buffer
    map("n", "<leader>bs", ":BufferLinePick<CR>", "Pick a buffer")

    -- Sort buffers by directory
    map("n", "<leader>bd", ":BufferLineSortByDirectory<CR>", "Sort buffers by directory")

    -- Sort buffers by extension
    map("n", "<leader>be", ":BufferLineSortByExtension<CR>", "Sort buffers by extension")

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
