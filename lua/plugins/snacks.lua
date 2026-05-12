local base_opts = {
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
}

local function snacks_opts(_, opts)
  local merged = vim.tbl_deep_extend("force", base_opts, opts or {})
  if vim.g.vscode then
    merged = vim.tbl_deep_extend("force", merged, {
      picker = { enabled = false },
      dashboard = { enabled = false },
      terminal = { enabled = false },
      lazygit = { enabled = false },
      gh = { enabled = false },
      quickfile = { enabled = false },
    })
  end
  return merged
end

local keys_full = {
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
  {
    "<S-j>",
    function()
      Snacks.image.hover()
    end,
    mode = { "n", "v" },
    desc = "Image Hover",
  },
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
}

local keys_vscode = {
  {
    "<S-j>",
    function()
      Snacks.image.hover()
    end,
    mode = { "n", "v" },
    desc = "Image Hover",
  },
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
  {
    "<leader>un",
    function()
      Snacks.notifier.show_history()
    end,
    desc = "Notification History",
  },
}

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = snacks_opts,
  keys = vim.g.vscode and keys_vscode or keys_full,
}
