return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  opts = {
    dir = vim.fn.stdpath("state") .. "/sessions/",
    need = 1,
    branch = true,
  },
  config = function(_, opts)
    require("persistence").setup(opts)

    -- Auto-restore session on startup (skip if file args passed)
    vim.api.nvim_create_autocmd("VimEnter", {
      group = vim.api.nvim_create_augroup("persistence_auto_restore", { clear = true }),
      callback = function()
        if vim.fn.argc() == 0 then
          require("persistence").load()
        end
      end,
      nested = true,
    })
  end,
  keys = {
    {
      "<leader>wr",
      function()
        require("persistence").load()
      end,
      desc = "Restore session (current dir)",
    },
    {
      "<leader>wR",
      function()
        require("persistence").load({ last = true })
      end,
      desc = "Restore last session",
    },
    {
      "<leader>ws",
      function()
        require("persistence").select()
      end,
      desc = "Select session",
    },
    {
      "<leader>wd",
      function()
        require("persistence").stop()
      end,
      desc = "Stop persistence (no save)",
    },
  },
}
