return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
    "nvim-telescope/telescope-ui-select.nvim",    -- better UI for code actions
    "debugloop/telescope-undo.nvim",              -- visualize and explore undo tree
    {
      "nvim-telescope/telescope-frecency.nvim",   -- intelligent file history
      dependencies = { "kkharji/sqlite.lua" }     -- needed for frecency
    },
    "nvim-telescope/telescope-file-browser.nvim", -- file browser integration
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local builtin = require("telescope.builtin")
    local themes = require("telescope.themes")

    -- Configure telescope
    telescope.setup({
      defaults = {
        prompt_prefix = " 󰍉 ", -- nicer prompt
        selection_caret = " ", -- selection indicator
        path_display = { "smart" }, -- smart path display
        file_ignore_patterns = { -- files to ignore
          ".git/", "node_modules/", "target/", "docs/", "vendor/*",
          "%.lock", "%.sqlite3", "%.otf", "%.ttf", "%.DS_Store"
        },
        layout_strategy = "horizontal", -- default layout
        layout_config = {
          horizontal = {
            prompt_position = "top", -- prompt at top
            preview_width = 0.55,    -- wider preview
            results_width = 0.8,     -- wider results
          },
          vertical = {
            mirror = false,     -- don't mirror
          },
          width = 0.87,         -- use most of screen
          height = 0.80,        -- use most of screen
          preview_cutoff = 120, -- don't show preview if window too small
        },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous,                              -- move to prev result
            ["<C-j>"] = actions.move_selection_next,                                  -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<C-s>"] = actions.select_horizontal,                                    -- open in horizontal split
            ["<C-v>"] = actions.select_vertical,                                      -- open in vertical split
            ["<C-t>"] = actions.select_tab,                                           -- open in new tab
            ["<C-u>"] = actions.preview_scrolling_up,                                 -- scroll preview up
            ["<C-d>"] = actions.preview_scrolling_down,                               -- scroll preview down
            ["<C-c>"] = actions.close,                                                -- close with Ctrl-c too
            ["<C-/>"] = actions.which_key,                                            -- show mappings
            ["<C-f>"] = actions.toggle_selection + actions.move_selection_next,       -- add item to selection and move
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_next,       -- alternate add to selection
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous, -- add and move up
            ["<C-l>"] = actions.complete_tag,                                         -- complete tag
          },
          n = {
            ["<Esc>"] = actions.close,                                                -- close with Esc in normal mode
            ["q"] = actions.close,                                                    -- close with q in normal mode
            ["<C-c>"] = actions.close,                                                -- close with Ctrl-c
            ["<CR>"] = actions.select_default,                                        -- select with Enter
            ["<C-x>"] = actions.select_horizontal,                                    -- open in horizontal split
            ["<C-v>"] = actions.select_vertical,                                      -- open in vertical split
            ["<C-t>"] = actions.select_tab,                                           -- open in new tab
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_next,       -- add to selection and move
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous, -- add to selection and move up
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,                 -- send to quickfix list and open
            ["<C-s>Q"] = actions.send_selected_to_qflist + actions.open_qflist,       -- send selected to quickfix
            ["j"] = actions.move_selection_next,                                      -- move down
            ["k"] = actions.move_selection_previous,                                  -- move up
            ["H"] = actions.move_to_top,                                              -- move to top of list
            ["M"] = actions.move_to_middle,                                           -- move to middle
            ["L"] = actions.move_to_bottom,                                           -- move to bottom
            ["?"] = actions.which_key,                                                -- show mappings
          },
        },
        -- Better sorting performance
        file_sorter = require("telescope.sorters").get_fuzzy_file,
        generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
        -- Better highlighting
        color_devicons = true,
        winblend = 0, -- background transparency
        border = {},
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        use_less = true,
        set_env = { ["COLORTERM"] = "truecolor" }, -- ensure terminal colors
        history = {
          path = vim.fn.stdpath("data") .. "/telescope_history.sqlite3",
          limit = 500,
        },
      },
      -- Extension configurations
      extensions = {
        fzf = {
          fuzzy = true,                   -- fuzzy matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true,    -- override the file sorter
          case_mode = "smart_case",       -- "smart_case" or "ignore_case" or "respect_case"
        },
        ["ui-select"] = {
          themes.get_dropdown({
            borderchars = {
              { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
              prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
              results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
              preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
            },
          }),
        },
        file_browser = {
          theme = "dropdown",
          -- disables netrw and use telescope-file-browser in its place
          hijack_netrw = true,
          mappings = {
            -- your custom insert mode mappings
            ["i"] = {
              ["<C-w>"] = function() vim.cmd('normal vbd') end,
            },
            ["n"] = {
              -- your custom normal mode mappings
              ["N"] = require("telescope").extensions.file_browser.actions.create,
              ["h"] = require("telescope").extensions.file_browser.actions.goto_parent_dir,
              ["/"] = function() vim.cmd('startinsert') end,
            },
          },
        },
        undo = {
          side_by_side = true,
          layout_strategy = "vertical",
          layout_config = {
            preview_height = 0.8,
          },
          mappings = {
            i = {
              ["<cr>"] = require("telescope-undo.actions").yank_additions,
              ["<S-cr>"] = require("telescope-undo.actions").yank_deletions,
              ["<C-cr>"] = require("telescope-undo.actions").restore,
            },
          },
        },
        frecency = {
          show_scores = true,
          show_unindexed = true,
          ignore_patterns = { "*.git/*", "*/tmp/*", "*/node_modules/*" },
          workspaces = {
            ["conf"] = vim.fn.expand("~/.config"),
            ["project"] = vim.fn.expand("~/projects"),
            ["docs"] = vim.fn.expand("~/Documents"),
          },
        },
      },
      pickers = {
        find_files = {
          hidden = true,     -- include hidden files but respect .gitignore
          no_ignore = false, -- respect .gitignore by default
        },
        buffers = {
          show_all_buffers = true, -- show all buffers
          sort_lastused = true,    -- sort by last used
          theme = "dropdown",      -- use dropdown theme
          previewer = false,       -- no previewer
          mappings = {
            i = {
              ["<C-d>"] = actions.delete_buffer, -- delete buffer directly
            },
            n = {
              ["dd"] = actions.delete_buffer, -- delete buffer in normal mode
            },
          },
        },
        -- Configure commands for other common pickers
        live_grep = {
          only_sort_text = true,       -- only sort by text
          additional_args = function() -- ignore binary files
            return { "--binary-files=without-match" }
          end,
        },
        grep_string = {
          only_sort_text = true, -- only sort by text
          word_match = "-w",     -- match whole words
        },
        current_buffer_fuzzy_find = {
          skip_empty_lines = true, -- skip empty lines when searching
          theme = "dropdown",      -- dropdown for this one
        },
      },
    })

    -- Load extensions
    telescope.load_extension("fzf")
    telescope.load_extension("ui-select")
    telescope.load_extension("file_browser")
    telescope.load_extension("undo")

    -- Try to load the frecency extension (requires sqlite)
    pcall(function() telescope.load_extension("frecency") end)

    -- Helper function for current buffer fuzzy find with different case sensitivity
    local function find_in_current_buffer_case_sensitive()
      builtin.current_buffer_fuzzy_find({
        case_mode = "respect_case",
        prompt_title = "Search in buffer (case sensitive)"
      })
    end

    local function find_in_current_buffer_ignore_case()
      builtin.current_buffer_fuzzy_find({
        case_mode = "ignore_case",
        prompt_title = "Search in buffer (ignore case)"
      })
    end

    -- Resume last picker
    local function resume_last_telescope()
      builtin.resume({ cache_index = 0 })
    end

    -- Search in multiple files at once (current buffer and visible buffers)
    local function multi_buffer_search()
      local buffers = {}
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_name(buf) ~= "" then
          table.insert(buffers, vim.api.nvim_buf_get_name(buf))
        end
      end
      builtin.live_grep({
        prompt_title = "Search in visible buffers",
        search_dirs = buffers,
      })
    end

    -- Find dotfiles
    local function find_dotfiles()
      builtin.find_files({
        prompt_title = "Find in dotfiles",
        cwd = vim.fn.expand("~/.config"),
        hidden = true
      })
    end

    -- Find in neovim config
    local function find_neovim_config()
      builtin.find_files({
        prompt_title = "Find in Neovim config",
        cwd = vim.fn.stdpath("config"),
        hidden = true
      })
    end

    -- Find notes
    local function find_notes()
      builtin.find_files({
        prompt_title = "Find in notes",
        cwd = vim.fn.expand("~/notes"),
      })
    end

    -- Find project files
    local function project_files()
      local opts = {} -- define here if you want to define something
      local ok = pcall(builtin.git_files, opts)
      if not ok then builtin.find_files(opts) end
    end

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    -- Core search mappings
    keymap.set("n", "<C-p>", project_files, { desc = "Find Git/Project Files" })
    keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
    keymap.set("n", "<leader>fr", function() telescope.extensions.frecency.frecency() end,
      { desc = "Find Recent Files (Frecency)" })
    keymap.set("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", { desc = "Find Recent Files" })
    keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find Open Buffers" })
    keymap.set("n", "<leader>fs", resume_last_telescope, { desc = "Resume Last Search" })

    -- Text search mappings
    keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Find Text in Project" })
    keymap.set("n", "<leader>fw", "<cmd>Telescope grep_string<cr>", { desc = "Find Word Under Cursor" })
    keymap.set("n", "<leader>f/", "<cmd>Telescope current_buffer_fuzzy_find<cr>",
      { desc = "Find Text in Current Buffer" })
    keymap.set("n", "<leader>f?", find_in_current_buffer_case_sensitive,
      { desc = "Find Text in Buffer (Case Sensitive)" })
    keymap.set("n", "<leader>fi", find_in_current_buffer_ignore_case, { desc = "Find Text in Buffer (Ignore Case)" })
    keymap.set("n", "<leader>fm", multi_buffer_search, { desc = "Find Text in Visible Buffers" })

    -- Special searches
    keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find TODOs" })
    keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Find Help" })
    keymap.set("n", "<leader>fc", "<cmd>Telescope commands<cr>", { desc = "Find Commands" })
    keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Find Keymaps" })
    keymap.set("n", "<leader>fu", "<cmd>Telescope undo<cr>", { desc = "Find in Undo Tree" })

    -- Git related
    keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", { desc = "Find Git Commits" })
    keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", { desc = "Find Git Branches" })
    keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>", { desc = "Find Git Status" })

    -- Location specific searches
    keymap.set("n", "<leader>fd", find_dotfiles, { desc = "Find in Dotfiles" })
    keymap.set("n", "<leader>fn", find_neovim_config, { desc = "Find in Neovim Config" })
    keymap.set("n", "<leader>fN", find_notes, { desc = "Find in Notes" })

    -- File browser
    keymap.set("n", "<leader>fe", "<cmd>Telescope file_browser<cr>", { desc = "File Browser" })
    keymap.set("n", "<leader>fE", function()
      telescope.extensions.file_browser.file_browser({ path = "%:p:h" })
    end, { desc = "File Browser (Current Dir)" })

    -- LSP related
    keymap.set("n", "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Document Symbols" })
    keymap.set("n", "<leader>lS", "<cmd>Telescope lsp_workspace_symbols<cr>", { desc = "Workspace Symbols" })
    keymap.set("n", "<leader>lr", "<cmd>Telescope lsp_references<cr>", { desc = "References" })
    keymap.set("n", "<leader>ld", "<cmd>Telescope diagnostics bufnr=0<cr>", { desc = "Buffer Diagnostics" })
    keymap.set("n", "<leader>lD", "<cmd>Telescope diagnostics<cr>", { desc = "Workspace Diagnostics" })

    -- Create a custom command to search selection
    vim.api.nvim_create_user_command("TelescopeSelection", function()
      local visual_selection = function()
        local save_previous = vim.fn.getreg("a")
        vim.api.nvim_command('silent! normal! "ay')
        local selection = vim.fn.getreg("a")
        vim.fn.setreg("a", save_previous)
        return selection
      end

      -- Get the current visual selection
      local selection = visual_selection()
      -- Escape any special characters in the selection
      selection = selection:gsub("([^%w])", "\\%1")

      -- Use the selection in live_grep
      builtin.grep_string({ search = selection })
    end, { range = true })

    -- Map the command to a key in visual mode
    keymap.set("v", "<leader>fs", ":TelescopeSelection<cr>", { desc = "Search Selection" })
  end,
}
