return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    -- Snippet Engine & its associated nvim-cmp source
    {
      'L3MON4D3/LuaSnip',
      build = (function()
        -- Build Step is needed for regex support in snippets.
        -- This step is not supported in many windows environments.
        -- Remove the below condition to re-enable on windows.
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
      dependencies = {
        -- `friendly-snippets` contains a variety of premade snippets.
        --    See the README about individual language/framework/plugin snippets:
        --    https://github.com/rafamadriz/friendly-snippets
        {
          'rafamadriz/friendly-snippets',
          config = function()
            require('luasnip.loaders.from_vscode').lazy_load()
          end,
        },
      },
    },
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-nvim-lsp-signature-help', -- Function signature help
    'hrsh7th/cmp-emoji', -- Emoji completion
  },
  config = function()
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    luasnip.config.setup {}

    -- Enhanced kind icons with better visual hierarchy
    local kind_icons = {
      Text = '󰉿',
      Method = '󰆧',
      Function = '󰊕',
      Constructor = '',
      Field = '󰜢',
      Variable = '󰀫',
      Class = '󰠱',
      Interface = '',
      Module = '',
      Property = '󰜢',
      Unit = '󰑭',
      Value = '󰎠',
      Enum = '',
      Keyword = '󰌋',
      Snippet = '',
      Color = '󰏘',
      File = '󰈙',
      Reference = '󰈇',
      Folder = '󰉋',
      EnumMember = '',
      Constant = '󰏿',
      Struct = '󰙅',
      Event = '',
      Operator = '󰆕',
      TypeParameter = '',
    }

    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      completion = {
        completeopt = 'menu,menuone,noinsert',
        keyword_length = 1,
      },
      window = {
        completion = {
          border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
          winhighlight = 'Normal:CmpPmenu,FloatBorder:CmpPmenuBorder,CursorLine:CmpPmenuSel,Search:None',
          scrollbar = true,
          col_offset = -3,
          side_padding = 1,
          max_width = 60,
          max_height = 15,
          -- Enable transparency support
          blend = vim.o.pumblend or 0,
        },
        documentation = {
          border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
          winhighlight = 'Normal:CmpDocumentation,FloatBorder:CmpDocumentationBorder',
          max_width = 80,
          max_height = 15,
          -- Enable transparency support
          blend = vim.o.pumblend or 0,
        },
      },
      experimental = {
        ghost_text = {
          hl_group = 'CmpGhostText',
        },
      },

      -- Enhanced keymaps with better UX
      mapping = cmp.mapping.preset.insert {
        -- Navigate with Ctrl+J and Ctrl+K
        ['<C-j>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item { behavior = cmp.SelectBehavior.Insert }
          else
            fallback()
          end
        end, { 'i', 's' }),

        ['<C-k>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item { behavior = cmp.SelectBehavior.Insert }
          else
            fallback()
          end
        end, { 'i', 's' }),

        -- Scroll documentation
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),

        -- Alternative navigation with Shift-Tab
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item { behavior = cmp.SelectBehavior.Insert }
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),

        -- Confirm with Enter
        ['<CR>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = false, -- Only confirm if explicitly selected
        },

        -- Cancel completion
        ['<C-e>'] = cmp.mapping.abort(),

        -- Manually trigger completion
        ['<C-Space>'] = cmp.mapping.complete(),

        -- Enhanced snippet navigation
        ['<C-l>'] = cmp.mapping(function()
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          end
        end, { 'i', 's' }),
        ['<C-h>'] = cmp.mapping(function()
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          end
        end, { 'i', 's' }),
      },

      sources = cmp.config.sources({
        {
          name = 'lazydev',
          group_index = 0,
        },
        {
          name = 'nvim_lsp',
          priority = 1000,
          max_item_count = 20,
        },
        {
          name = 'nvim_lsp_signature_help',
          priority = 900,
          max_item_count = 5,
        },
        {
          name = 'luasnip',
          priority = 750,
          max_item_count = 5,
        },
      }, {
        {
          name = 'buffer',
          priority = 500,
          max_item_count = 5,
          option = {
            get_bufnrs = function()
              return vim.api.nvim_list_bufs()
            end,
          },
        },
        {
          name = 'path',
          priority = 250,
          max_item_count = 10,
        },
        {
          name = 'emoji',
          priority = 100,
          max_item_count = 3,
        },
      }),

      formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        format = function(entry, vim_item)
          local max_width = 50
          local max_abbr_width = 35
          local max_menu_width = 15

          -- Truncate abbreviation if too long
          if string.len(vim_item.abbr) > max_abbr_width then
            vim_item.abbr = string.sub(vim_item.abbr, 1, max_abbr_width - 3) .. '...'
          end

          -- Kind icons with better formatting
          local kind_icon = kind_icons[vim_item.kind] or ''
          vim_item.kind = string.format(' %s ', kind_icon)

          -- Source labels with color coding
          local source_mapping = {
            nvim_lsp = 'LSP',
            luasnip = 'Snip',
            buffer = 'Buf',
            path = 'Path',
            lazydev = 'Lazy',
          }

          local source_name = source_mapping[entry.source.name] or entry.source.name
          vim_item.menu = string.format('[%s]', source_name)

          -- Truncate menu if too long
          if string.len(vim_item.menu) > max_menu_width then
            vim_item.menu = string.sub(vim_item.menu, 1, max_menu_width - 3) .. '...'
          end

          -- Ensure consistent width
          local total_width = string.len(vim_item.abbr) + string.len(vim_item.menu) + string.len(vim_item.kind)
          if total_width > max_width then
            local available_abbr_width = max_width - string.len(vim_item.menu) - string.len(vim_item.kind)
            if available_abbr_width > 10 then
              vim_item.abbr = string.sub(vim_item.abbr, 1, available_abbr_width - 3) .. '...'
            end
          end

          return vim_item
        end,
      },

      -- Performance optimizations
      performance = {
        debounce = 60,
        throttle = 30,
        fetching_timeout = 500,
        confirm_resolve_timeout = 80,
        async_budget = 1,
        max_view_entries = 200,
      },
    }

    -- Enhanced highlighting setup with Catppuccin integration and transparency
    local function setup_highlights()
      -- Check if Catppuccin is available and get the current flavor
      local has_catppuccin, catppuccin = pcall(require, 'catppuccin')

      if has_catppuccin then
        -- Get the current Catppuccin flavor (mocha, macchiato, frappe, latte)
        local current_flavor = vim.g.catppuccin_flavour or 'mocha'
        local colors = require('catppuccin.palettes').get_palette(current_flavor)

        -- Check if transparency is enabled
        local transparent_bg = require('catppuccin').options.transparent_background or false
        local bg_color = transparent_bg and 'NONE' or colors.base
        local menu_bg = transparent_bg and 'NONE' or colors.surface0

        -- Main completion menu with transparency support
        vim.api.nvim_set_hl(0, 'CmpPmenu', {
          bg = menu_bg,
          fg = colors.text,
        })
        vim.api.nvim_set_hl(0, 'CmpPmenuBorder', {
          bg = menu_bg,
          fg = colors.blue,
        })
        vim.api.nvim_set_hl(0, 'CmpPmenuSel', {
          bg = colors.surface2,
          fg = colors.text,
          bold = true,
        })

        -- Documentation window with transparency
        vim.api.nvim_set_hl(0, 'CmpDocumentation', {
          bg = menu_bg,
          fg = colors.text,
        })
        vim.api.nvim_set_hl(0, 'CmpDocumentationBorder', {
          bg = menu_bg,
          fg = colors.sapphire,
        })

        -- Scrollbar with proper contrast
        vim.api.nvim_set_hl(0, 'PmenuSbar', {
          bg = transparent_bg and colors.surface0 or colors.surface1,
        })
        vim.api.nvim_set_hl(0, 'PmenuThumb', {
          bg = colors.overlay0,
        })

        -- Ghost text with theme-appropriate opacity
        vim.api.nvim_set_hl(0, 'CmpGhostText', {
          fg = colors.overlay0,
          italic = true,
        })

        -- Item highlights that respect the theme
        vim.api.nvim_set_hl(0, 'CmpItemAbbr', { fg = colors.text })
        vim.api.nvim_set_hl(0, 'CmpItemAbbrDeprecated', {
          fg = colors.overlay1,
          strikethrough = true,
        })
        vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', {
          fg = colors.blue,
          bold = true,
        })
        vim.api.nvim_set_hl(0, 'CmpItemAbbrMatchFuzzy', {
          fg = colors.blue,
          bold = true,
        })
        vim.api.nvim_set_hl(0, 'CmpItemMenu', {
          fg = colors.overlay1,
          italic = true,
        })

        -- Kind-specific highlights using Catppuccin's semantic colors
        local kind_highlights = {
          CmpItemKindFunction = colors.mauve,
          CmpItemKindMethod = colors.mauve,
          CmpItemKindConstructor = colors.sapphire,
          CmpItemKindVariable = colors.lavender,
          CmpItemKindField = colors.teal,
          CmpItemKindProperty = colors.teal,
          CmpItemKindClass = colors.yellow,
          CmpItemKindInterface = colors.yellow,
          CmpItemKindStruct = colors.yellow,
          CmpItemKindModule = colors.blue,
          CmpItemKindKeyword = colors.red,
          CmpItemKindSnippet = colors.green,
          CmpItemKindText = colors.text,
          CmpItemKindEnum = colors.peach,
          CmpItemKindEnumMember = colors.peach,
          CmpItemKindConstant = colors.peach,
          CmpItemKindValue = colors.peach,
          CmpItemKindUnit = colors.green,
          CmpItemKindFile = colors.blue,
          CmpItemKindFolder = colors.blue,
          CmpItemKindColor = colors.pink,
          CmpItemKindReference = colors.overlay2,
          CmpItemKindOperator = colors.sky,
          CmpItemKindTypeParameter = colors.maroon,
          CmpItemKindEvent = colors.flamingo,
        }

        for group, color in pairs(kind_highlights) do
          vim.api.nvim_set_hl(0, group, { fg = color })
        end
      else
        -- Fallback highlights when Catppuccin is not available
        -- Check if user prefers transparency
        local use_transparent = vim.g.transparent_enabled or false
        local fallback_bg = use_transparent and 'NONE' or '#1e1e2e'

        vim.api.nvim_set_hl(0, 'CmpPmenu', {
          bg = fallback_bg,
          fg = '#cdd6f4',
        })
        vim.api.nvim_set_hl(0, 'CmpPmenuBorder', {
          bg = fallback_bg,
          fg = '#89b4fa',
        })
        vim.api.nvim_set_hl(0, 'CmpPmenuSel', {
          bg = '#313244',
          fg = '#cdd6f4',
          bold = true,
        })
        vim.api.nvim_set_hl(0, 'CmpDocumentation', {
          bg = fallback_bg,
          fg = '#cdd6f4',
        })
        vim.api.nvim_set_hl(0, 'CmpDocumentationBorder', {
          bg = fallback_bg,
          fg = '#74c7ec',
        })
        vim.api.nvim_set_hl(0, 'CmpGhostText', {
          fg = '#6c7086',
          italic = true,
        })
        vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', {
          fg = '#89b4fa',
          bold = true,
        })
        vim.api.nvim_set_hl(0, 'CmpItemMenu', {
          fg = '#6c7086',
          italic = true,
        })
      end
    end

    -- Set up autocmd to apply highlights when colorscheme changes
    vim.api.nvim_create_autocmd({ 'ColorScheme', 'VimEnter' }, {
      pattern = '*',
      callback = setup_highlights,
      desc = 'Setup nvim-cmp highlights',
    })

    -- Apply highlights immediately
    setup_highlights()

    -- Additional performance tweaks
    vim.opt.pumheight = 15 -- Limit popup menu height
    vim.opt.updatetime = 300 -- Faster completion trigger
  end,
}
