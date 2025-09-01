-- Enhanced GitHub Copilot configuration for Neovim
-- Optimized for better performance and integration

return {
  {
    -- Core Copilot engine - handles AI completions
    'zbirenbaum/copilot.lua',
    event = 'InsertEnter', -- Load when entering insert mode
    cmd = 'Copilot',
    build = ':Copilot auth', -- Automatic authentication
    opts = {
      panel = {
        enabled = true,
        auto_refresh = true,
        keymap = {
          jump_prev = '[[',
          jump_next = ']]',
          accept = '<CR>',
          refresh = 'gr',
          open = '<M-CR>', -- Alt+Enter to open panel
        },
        layout = {
          position = 'bottom',
          ratio = 0.4,
        },
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = true,
        debounce = 50, -- Reduced debounce for faster suggestions
        keymap = {
          accept = '<Tab>', -- Tab to accept suggestion
          accept_word = '<M-w>', -- Alt+w to accept word
          accept_line = '<M-j>', -- Alt+j to accept line
          next = '<M-]>', -- Alt+] for next suggestion
          prev = '<M-[>', -- Alt+[ for previous suggestion
          dismiss = '<C-]>', -- Ctrl+] to dismiss
        },
      },
      filetypes = {
        -- Enable for most file types
        ['*'] = true,
        -- Disable for specific file types
        yaml = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ['.'] = false,
        -- Enable for documentation
        markdown = true,
        tex = true,
        -- Enable for config files
        json = true,
        toml = true,
        -- Enable for web development
        html = true,
        css = true,
        scss = true,
        javascript = true,
        typescript = true,
        vue = true,
        svelte = true,
      },
      copilot_node_command = 'node', -- Use Node.js from PATH
      server_opts_overrides = {
        -- Performance optimizations
        trace = 'off', -- Disable tracing for better performance
        settings = {
          advanced = {
            length = 500, -- Limit suggestion length
            inlineSuggestCount = 3, -- Limit number of suggestions
            listCount = 10, -- Limit list suggestions
          },
        },
      },
    },
  },

  {
    -- Enhanced Copilot completion source for nvim-cmp
    'zbirenbaum/copilot-cmp',
    dependencies = { 'zbirenbaum/copilot.lua' },
    config = function()
      require('copilot_cmp').setup {
        formatters = {
          label = require('copilot_cmp.format').format_label_text,
          insert_text = require('copilot_cmp.format').format_insert_text,
          preview = require('copilot_cmp.format').deindent,
        },
      }
    end,
  },

  {
    -- Copilot Chat for interactive AI assistance
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'main',
    dependencies = {
      { 'zbirenbaum/copilot.lua' },
      { 'nvim-lua/plenary.nvim' },
    },
    build = 'make tiktoken', -- Build tiktoken for better performance
    event = 'VeryLazy', -- Load when needed
    opts = {
      debug = false, -- Disable debug for better performance
      model = 'gpt-4', -- Use GPT-4 for better responses
      temperature = 0.1, -- Lower temperature for more consistent responses

      -- Window configuration
      window = {
        layout = 'vertical', -- vertical, horizontal, float, replace
        width = 0.5, -- fractional width
        height = 0.5, -- fractional height
        -- Options for floating window
        relative = 'editor', -- 'editor', 'win', 'cursor', 'mouse'
        border = 'rounded', -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
        row = nil, -- row position of the window, default is centered
        col = nil, -- column position of the window, default is centered
        title = 'Copilot Chat', -- title of the window
        footer = nil, -- footer of the window
        zindex = 1, -- determines if window is on top or below other floating windows
      },

      -- Enhanced mappings
      mappings = {
        complete = {
          detail = 'Use @<Tab> or /<Tab> for options.',
          insert = '<Tab>',
        },
        close = {
          normal = 'q',
          insert = '<C-c>',
        },
        reset = {
          normal = '<C-r>',
          insert = '<C-r>',
        },
        submit_prompt = {
          normal = '<CR>',
          insert = '<C-s>',
        },
        accept_diff = {
          normal = '<C-y>',
          insert = '<C-y>',
        },
        yank_diff = { normal = 'gy' },
        show_diff = { normal = 'gd' },
        show_info = { normal = 'gp' },
        show_context = { normal = 'gs' },
      },

      -- Auto-follow cursor
      auto_follow_cursor = true,

      -- Show help actions with telescope
      show_help = true,

      -- Prompts configuration
      prompts = {
        Explain = {
          prompt = '/COPILOT_EXPLAIN Write an explanation for the active selection as paragraphs of text.',
        },
        Review = {
          prompt = '/COPILOT_REVIEW Review the selected code.',
          callback = function(response, source)
            -- Custom callback for review
          end,
        },
        Fix = {
          prompt = '/COPILOT_GENERATE There is a problem in this code. Rewrite the code to show it with the bug fixed.',
        },
        Optimize = {
          prompt = '/COPILOT_GENERATE Optimize the selected code to improve performance and readability.',
        },
        Docs = {
          prompt = '/COPILOT_GENERATE Please add documentation comment for the selection.',
        },
        Tests = {
          prompt = '/COPILOT_GENERATE Please generate tests for my code.',
        },
        FixDiagnostic = {
          prompt = 'Please assist with the following diagnostic issue in file:',
          selection = function(source)
            return require('CopilotChat.select').diagnostics(source)
          end,
        },
        Commit = {
          prompt = 'Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.',
          selection = function(source)
            return require('CopilotChat.select').gitdiff(source)
          end,
        },
        CommitStaged = {
          prompt = 'Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.',
          selection = function(source)
            return require('CopilotChat.select').gitdiff(source, true)
          end,
        },
      },
    },
    keys = {
      -- Main chat commands
      {
        '<leader>aa',
        function()
          local input = vim.fn.input 'Quick Chat: '
          if input ~= '' then
            require('CopilotChat').ask(input, { selection = require('CopilotChat.select').buffer })
          end
        end,
        desc = 'CopilotChat - Quick chat',
      },
      {
        '<leader>ac',
        '<cmd>CopilotChat<cr>',
        desc = 'CopilotChat - Open chat',
      },
      {
        '<leader>ax',
        '<cmd>CopilotChatClose<cr>',
        desc = 'CopilotChat - Close chat',
      },
      {
        '<leader>ar',
        '<cmd>CopilotChatReset<cr>',
        desc = 'CopilotChat - Reset chat',
      },
      {
        '<leader>as',
        '<cmd>CopilotChatSave<cr>',
        desc = 'CopilotChat - Save chat',
      },
      {
        '<leader>al',
        '<cmd>CopilotChatLoad<cr>',
        desc = 'CopilotChat - Load chat',
      },

      -- Code actions
      {
        '<leader>ae',
        '<cmd>CopilotChatExplain<cr>',
        mode = 'v',
        desc = 'CopilotChat - Explain code',
      },
      {
        '<leader>at',
        '<cmd>CopilotChatTests<cr>',
        mode = 'v',
        desc = 'CopilotChat - Generate tests',
      },
      {
        '<leader>af',
        '<cmd>CopilotChatFix<cr>',
        mode = 'v',
        desc = 'CopilotChat - Fix code',
      },
      {
        '<leader>ao',
        '<cmd>CopilotChatOptimize<cr>',
        mode = 'v',
        desc = 'CopilotChat - Optimize code',
      },
      {
        '<leader>ad',
        '<cmd>CopilotChatDocs<cr>',
        mode = 'v',
        desc = 'CopilotChat - Generate docs',
      },
      {
        '<leader>av',
        '<cmd>CopilotChatReview<cr>',
        mode = 'v',
        desc = 'CopilotChat - Review code',
      },

      -- Diagnostic and Git
      {
        '<leader>aD',
        '<cmd>CopilotChatFixDiagnostic<cr>',
        desc = 'CopilotChat - Fix diagnostic',
      },
      {
        '<leader>ag',
        '<cmd>CopilotChatCommit<cr>',
        desc = 'CopilotChat - Generate commit message',
      },
      {
        '<leader>aG',
        '<cmd>CopilotChatCommitStaged<cr>',
        desc = 'CopilotChat - Generate commit message for staged',
      },

      -- Prompts and help
      {
        '<leader>ap',
        '<cmd>CopilotChatPrompts<cr>',
        desc = 'CopilotChat - Prompt actions',
      },
      {
        '<leader>ah',
        '<cmd>CopilotChatHelp<cr>',
        desc = 'CopilotChat - Help actions',
      },
    },
  },
}
