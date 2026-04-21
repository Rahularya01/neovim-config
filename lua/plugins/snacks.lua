return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    input = { enabled = true },
    picker = {
      enabled = true,
      actions = {
        sidekick_send = function(...)
          return require("sidekick.cli.picker.snacks").send(...)
        end,
      },
      win = {
        input = {
          keys = {
            ["<a-a>"] = {
              "sidekick_send",
              mode = { "n", "i" },
            },
          },
        },
      },
      sources = {
        gh_issue = {},
        gh_pr = {},
      },
    },
    dashboard = { enabled = true },
    terminal = { enabled = true },
    notifier = { enabled = true },
    indent = { enabled = true },
    lazygit = { enabled = true },
    gh = {
      enabled = true,
    },
    image = {
      enabled = true,
      doc = {
        enabled = false,
        max_width = 30,
        max_height = 15,
      },
    },
    quickfile = { enabled = true },
    scope = { enabled = true },
    statuscolumn = { enabled = true },
    bufdelete = { enabled = true },
  },

  keys = {
    {
      "<leader>gi",
      function()
        Snacks.picker.gh_issue()
      end,
      desc = "GitHub Issues (open)",
    },
    {
      "<leader>gI",
      function()
        Snacks.picker.gh_issue({ state = "all" })
      end,
      desc = "GitHub Issues (all)",
    },
    {
      "<leader>gp",
      function()
        Snacks.picker.gh_pr()
      end,
      desc = "GitHub Pull Requests (open)",
    },
    {
      "<leader>gP",
      function()
        Snacks.picker.gh_pr({ state = "all" })
      end,
      desc = "GitHub Pull Requests (all)",
    },
    -- Image hover
    {
      "<S-j>",
      function()
        Snacks.image.hover()
      end,
      mode = { "n", "v" },
      desc = "Image Hover",
    },
    -- Top Pickers
    {
      "<leader>.",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Switch buffer",
    },
    {
      "<leader>ff",
      function()
        Snacks.picker.files()
      end,
      desc = "Find Files",
    },
    {
      "<leader>sg",
      function()
        Snacks.picker.grep()
      end,
      desc = "Grep",
    },

    {
      "<leader>sw",
      function()
        Snacks.picker.grep_word()
      end,
      desc = "Search current word",
    },

    -- Terminal
    {
      "<C-\\>",
      function()
        Snacks.terminal.toggle()
      end,
      desc = "Toggle terminal",
    },
    {
      "<C-\\>",
      function()
        Snacks.terminal.toggle()
      end,
      mode = "t",
      desc = "Toggle terminal",
    },
    {
      "<leader>tt",
      function()
        Snacks.terminal.toggle(nil, { count = vim.v.count1 })
      end,
      desc = "Toggle terminal (count)",
    },
    {
      "<leader>tl",
      function()
        local terms = Snacks.terminal.list()
        if #terms == 0 then
          Snacks.terminal.toggle()
          return
        end
        local items = {}
        for _, term in ipairs(terms) do
          local count = term.opts.count or 1
          table.insert(items, {
            text = "Terminal " .. count,
            count = count,
          })
        end
        Snacks.picker.pick({
          source = "terminals",
          items = items,
          format = function(item)
            return { { item.text, "SnacksPickerLabel" } }
          end,
          confirm = function(picker, item)
            picker:close()
            if item then
              Snacks.terminal.toggle(nil, { count = item.count })
            end
          end,
        })
      end,
      desc = "List terminals",
    },
    -- Buffer delete
    {
      "<leader>bd",
      function()
        Snacks.bufdelete()
      end,
      desc = "Delete buffer",
    },
    {
      "<leader>bD",
      function()
        Snacks.bufdelete({ force = true })
      end,
      desc = "Delete buffer (force)",
    },
    -- LSP Word references
    {
      "]r",
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      desc = "Next reference",
    },
    {
      "[r",
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      desc = "Prev reference",
    },
    -- Other Snacks Utilities
    {
      "<leader>lg",
      function()
        Snacks.lazygit()
      end,
      desc = "LazyGit",
    },
    {
      "<leader>un",
      function()
        Snacks.notifier.show_history()
      end,
      desc = "Notification History",
    },
  },
}
