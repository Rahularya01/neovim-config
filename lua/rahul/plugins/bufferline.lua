return {
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = {
    'nvim-tree/nvim-web-devicons', -- optional dependency for icons
    'famiu/bufdelete.nvim',        -- handle buffer deletion gracefully
  },
  config = function()
    require('bufferline').setup({
      options = {
        mode = "buffers",              -- set to "tabs" to only show tabpages instead
        numbers = "none",              -- can also be "buffer_id" or "ordinal"
        close_command = "Bdelete! %d", -- use Bdelete from bufdelete.nvim
        right_mouse_command = "Bdelete! %d",
        left_mouse_command = "buffer %d",
        middle_mouse_command = nil,
        indicator = {
          icon = '▎',
        },
        buffer_close_icon = '',
        modified_icon = '●',
        close_icon = '',
        left_trunc_marker = '',
        right_trunc_marker = '',
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            text_align = "center",
            separator = true,
          },
        },
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = false,
        persist_buffer_sort = true,
        separator_style = "thin",
        enforce_regular_tabs = false,
        always_show_bufferline = true,
      },
    })

    -- Keymaps for bufferline
    vim.keymap.set("n", "<S-h>", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<S-l>", ":BufferLineCycleNext<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>bl", ":BufferLineCloseLeft<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>bq", ":BufferLineCloseOthers<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>bp", ":BufferLineTogglePin<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>bP", ":BufferLineCloseRight<CR>:BufferLineCloseLeft<CR>",
      { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>br", ":BufferLineCloseRight<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "[b", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "[B", ":BufferLineMovePrev<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "]b", ":BufferLineCycleNext<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "]B", ":BufferLineMoveNext<CR>", { noremap = true, silent = true })

    -- Graceful buffer deletion using bufdelete.nvim
    vim.keymap.set('n', '<C-x>', ':Bdelete<CR>', { noremap = true, silent = true })

    -- Auto-open an empty buffer if the last buffer is closed
    vim.api.nvim_create_autocmd("BufDelete", {
      callback = function()
        if #vim.fn.getbufinfo({ buflisted = true }) == 0 then
          vim.cmd("enew") -- Open a new empty buffer
        end
      end,
    })

    vim.keymap.set("n", "<leader>ba", function()
      for _, buf in ipairs(vim.fn.getbufinfo({ buflisted = true })) do
        vim.cmd("Bdelete " .. buf.bufnr) -- Delete each listed buffer
      end
    end, { noremap = true, silent = true })


    vim.keymap.set('n', '<leader>bb', function()
      require('telescope.builtin').buffers({
        sort_mru = true,              -- sort by most recently used
        ignore_current_buffer = true, -- hide the current buffer from the list
      })
    end, { noremap = true, silent = true })
  end,
}

