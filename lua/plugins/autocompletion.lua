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

    -- Enhanced highlighting setup with Gruvbox integration and transparency
    local function setup_highlights()
      -- Check if Gruvbox is available and get the palette
      local has_gruvbox, gruvbox_palette = pcall(require, 'gruvbox.palette')

      if has_gruvbox then
        local colors = gruvbox_palette.get_base_colors(vim.o.background or 'dark', 'medium')

        -- Always use transparent background for completion menu
        local transparent_bg = true
        local bg_color = 'NONE'
        local menu_bg = 'NONE'

        -- Main completion menu with transparency support
        vim.api.nvim_set_hl(0, 'CmpPmenu', {
          bg = menu_bg,
          fg = colors.light1,
        })
        vim.api.nvim_set_hl(0, 'CmpPmenuBorder', {
          bg = menu_bg,
          fg = colors.bright_blue,
        })
        vim.api.nvim_set_hl(0, 'CmpPmenuSel', {
          bg = colors.dark2,
          fg = colors.light0,
          bold = true,
        })

        -- Documentation window with transparency
        vim.api.nvim_set_hl(0, 'CmpDocumentation', {
          bg = menu_bg,
          fg = colors.light1,
        })
        vim.api.nvim_set_hl(0, 'CmpDocumentationBorder', {
          bg = menu_bg,
          fg = colors.bright_aqua,
        })

        -- Scrollbar with proper contrast
        vim.api.nvim_set_hl(0, 'PmenuSbar', {
          bg = 'NONE',
        })
        vim.api.nvim_set_hl(0, 'PmenuThumb', {
          bg = colors.dark4,
        })

        -- Ghost text with theme-appropriate opacity
        vim.api.nvim_set_hl(0, 'CmpGhostText', {
          fg = colors.dark4,
          italic = true,
        })

        -- Item highlights that respect the theme
        vim.api.nvim_set_hl(0, 'CmpItemAbbr', { fg = colors.light1 })
        vim.api.nvim_set_hl(0, 'CmpItemAbbrDeprecated', {
          fg = colors.gray,
          strikethrough = true,
        })
        vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', {
          fg = colors.bright_blue,
          bold = true,
        })
        vim.api.nvim_set_hl(0, 'CmpItemAbbrMatchFuzzy', {
          fg = colors.bright_blue,
          bold = true,
        })
        vim.api.nvim_set_hl(0, 'CmpItemMenu', {
          fg = colors.gray,
          italic = true,
        })

        -- Kind-specific highlights using Gruvbox's semantic colors
        local kind_highlights = {
          CmpItemKindFunction = colors.bright_purple,
          CmpItemKindMethod = colors.bright_purple,
          CmpItemKindConstructor = colors.bright_aqua,
          CmpItemKindVariable = colors.bright_blue,
          CmpItemKindField = colors.bright_aqua,
          CmpItemKindProperty = colors.bright_aqua,
          CmpItemKindClass = colors.bright_yellow,
          CmpItemKindInterface = colors.bright_yellow,
          CmpItemKindStruct = colors.bright_yellow,
          CmpItemKindModule = colors.neutral_blue,
          CmpItemKindKeyword = colors.bright_red,
          CmpItemKindSnippet = colors.bright_green,
          CmpItemKindText = colors.light1,
          CmpItemKindEnum = colors.bright_orange,
          CmpItemKindEnumMember = colors.bright_orange,
          CmpItemKindConstant = colors.bright_orange,
          CmpItemKindValue = colors.bright_orange,
          CmpItemKindUnit = colors.bright_green,
          CmpItemKindFile = colors.neutral_blue,
          CmpItemKindFolder = colors.neutral_blue,
          CmpItemKindColor = colors.bright_purple,
          CmpItemKindReference = colors.gray,
          CmpItemKindOperator = colors.neutral_aqua,
          CmpItemKindTypeParameter = colors.neutral_yellow,
          CmpItemKindEvent = colors.neutral_red,
        }

        for group, color in pairs(kind_highlights) do
          vim.api.nvim_set_hl(0, group, { fg = color })
        end
      else
        -- Fallback highlights with Gruvbox colors when palette is not available
        -- Always use transparent background
        local fallback_bg = 'NONE'

        vim.api.nvim_set_hl(0, 'CmpPmenu', {
          bg = fallback_bg,
          fg = '#ebdbb2',
        })
        vim.api.nvim_set_hl(0, 'CmpPmenuBorder', {
          bg = fallback_bg,
          fg = '#83a598',
        })
        vim.api.nvim_set_hl(0, 'CmpPmenuSel', {
          bg = '#504945',
          fg = '#fbf1c7',
          bold = true,
        })
        vim.api.nvim_set_hl(0, 'CmpDocumentation', {
          bg = fallback_bg,
          fg = '#ebdbb2',
        })
        vim.api.nvim_set_hl(0, 'CmpDocumentationBorder', {
          bg = fallback_bg,
          fg = '#8ec07c',
        })
        vim.api.nvim_set_hl(0, 'CmpGhostText', {
          fg = '#928374',
          italic = true,
        })
        vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', {
          fg = '#83a598',
          bold = true,
        })
        vim.api.nvim_set_hl(0, 'CmpItemMenu', {
          fg = '#928374',
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
