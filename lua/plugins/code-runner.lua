return {
  "CRAG666/code_runner.nvim",
  cmd = { "RunCode", "RunFile", "RunProject", "RunClose", "CRFiletype", "CRProjects" },
  keys = {
    { "<leader>rr", "<cmd>RunCode<cr>", desc = "Run code", silent = true },
    { "<leader>rf", "<cmd>RunFile<cr>", desc = "Run file", silent = true },
    { "<leader>rft", "<cmd>RunFile tab<cr>", desc = "Run file in tab", silent = true },
    { "<leader>rp", "<cmd>RunProject<cr>", desc = "Run project", silent = true },
    { "<leader>rq", "<cmd>RunClose<cr>", desc = "Close runner", silent = true },
  },
  config = function()
    require("code_runner").setup({
      mode = "term",
      focus = true,
      startinsert = false,
      term = {
        position = "bot",
        size = 15,
      },
      float = {
        border = "rounded",
        width = 0.8,
        height = 0.8,
        x = 0.5,
        y = 0.5,
      },
      filetype = {
        python = "python3 -u",
        javascript = "node",
        typescript = "ts-node",
        rust = "cargo run",
        go = "go run",
        c = "cd $dir && gcc $fileName -o /tmp/$fileNameWithoutExt && /tmp/$fileNameWithoutExt",
        cpp = "cd $dir && g++ $fileName -o /tmp/$fileNameWithoutExt && /tmp/$fileNameWithoutExt",
        java = {
          "cd $dir &&",
          "javac $fileName &&",
          "java $fileNameWithoutExt",
        },
        sh = "bash",
        lua = "lua",
      },
    })
  end,
}
