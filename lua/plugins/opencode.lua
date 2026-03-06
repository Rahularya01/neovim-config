return {
  "nickjvandyke/opencode.nvim",
  dependencies = {
    {
      ---@module "snacks"
      "folke/snacks.nvim",
      optional = true,
      opts = {
        input = {},
        picker = {
          actions = {
            opencode_send = function(...) return require("opencode").snacks_picker_send(...) end,
          },
          win = {
            input = {
              keys = {
                ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
              },
            },
          },
        },
        terminal = {},
      },
    },
  },
  event = "VeryLazy",
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {}

    vim.o.autoread = true

    vim.keymap.set("n", "<leader>ac", function()
      require("opencode").toggle()
    end, { desc = "Toggle Opencode" })

    vim.keymap.set("n", "<leader>an", function()
      require("opencode").command("session.new")
    end, { desc = "Start New Opencode Session" })

    vim.keymap.set({ "n", "x" }, "<C-a>", function()
      require("opencode").ask("@buffer: ", { submit = true })
    end, { desc = "Ask Opencode about selection/buffer" })

    vim.keymap.set("n", "<leader>as", function()
      require("opencode").select()
    end, { desc = "Select Opencode Action" })

    vim.keymap.set({ "n", "x" }, "go", function()
      return require("opencode").operator("@this ")
    end, { expr = true, desc = "Add range to opencode" })

    vim.keymap.set("n", "goo", function()
      return require("opencode").operator("@this ") .. "_"
    end, { expr = true, desc = "Add line to opencode" })

    vim.keymap.set("n", "<S-C-u>", function()
      require("opencode").command("session.half.page.up")
    end, { desc = "Scroll AI Up" })

    vim.keymap.set("n", "<S-C-d>", function()
      require("opencode").command("session.half.page.down")
    end, { desc = "Scroll AI Down" })

    vim.keymap.set("n", "+", "<C-a>", { desc = "Increment Number", noremap = true })
    vim.keymap.set("n", "_", "<C-x>", { desc = "Decrement Number", noremap = true })
  end,
}
