return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
    {
      's1n7ax/nvim-window-picker',
      version = '2.*',
      config = function()
        require('window-picker').setup {
          autoselect_one = true,
          include_current_win = false,
          filter_rules = {
            bo = { filetype = { 'neo-tree', 'notify' }, buftype = { 'terminal', 'quickfix' } },
          },
        }
      end,
    },
  },
  config = function()
    local icons = {
      default = '',
      symlink = '',
      folder = { closed = '', open = '', empty = 'ﰊ' },
      git = {
        added = '', -- added files
        modified = '', -- modified files
        deleted = '', -- deleted files
        renamed = '➜', -- renamed files
        untracked = '', -- untracked files
        ignored = '◌', -- ignored files
        staged = '✓', -- staged files
        conflict = '', -- merge conflicts
        unstaged = '✗', -- unstaged changes
      },
      diagnostics = {
        error = '',
        warn = '',
        info = '',
        hint = '',
      },
    }

    require('neo-tree').setup {
      close_if_last_window = true,
      popup_border_style = 'rounded',
      enable_git_status = true,
      enable_diagnostics = true,
      window = {
        position = 'left',
        width = 40,
        mappings = {
          ['<CR>'] = 'open',
          ['l'] = 'open',
          ['h'] = 'close_node',
          ['s'] = 'open_split',
          ['v'] = 'open_vsplit',
          ['<BS>'] = 'navigate_up',
          ['H'] = 'toggle_hidden',
          ['R'] = 'refresh',
          ['a'] = 'add',
          ['d'] = 'delete',
          ['r'] = 'rename',
          ['y'] = 'copy_to_clipboard',
          ['x'] = 'cut_to_clipboard',
          ['p'] = 'paste_from_clipboard',
          ['q'] = 'close_window',
        },
      },
      default_component_configs = {
        icon = {
          folder_closed = icons.folder.closed,
          folder_open = icons.folder.open,
          folder_empty = icons.folder.empty,
          default = icons.default,
          symlink = icons.symlink,
        },
        diagnostics = {
          symbols = icons.diagnostics,
        },
        git_status = {
          symbols = icons.git,
        },
      },
      filesystem = {
        filtered_items = { hide_dotfiles = false, hide_gitignored = false },
        hijack_netrw_behavior = 'open_current',
        follow_current_file = {
          enabled = true,
        },
      },
      buffers = { follow_current_file = {
        enabled = true,
      }, show_unloaded = true },
      git_status = { window = { position = 'float' } },
    }

    -- Note: <leader>e is used by Snacks.nvim explorer, using alternative keymap
    vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle<cr>', { silent = true, desc = 'Toggle Neotree' })
  end,
}
