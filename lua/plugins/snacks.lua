local base_opts = {
  bigfile = { enabled = true },
  input = { enabled = true },
  picker = {
    enabled = true,
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
  gh = { enabled = true },
  -- Image backends start terminal probes and placement work after opening a
  -- buffer. Keep the editor path lightweight; re-enable if image previews are
  -- a regular part of your workflow.
  image = { enabled = false },
  quickfile = { enabled = true },
  scope = { enabled = true },
  statuscolumn = { enabled = true },
  bufdelete = { enabled = true },
}

local function snacks_opts(_, opts)
  return vim.tbl_deep_extend("force", base_opts, opts or {})
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
    "<C-x>",
    function()
      Snacks.bufdelete()
    end,
    desc = "Delete buffer",
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

return {
  "folke/snacks.nvim",
  priority = 1000,
  event = "VeryLazy",
  opts = snacks_opts,
  keys = keys_full,
}
