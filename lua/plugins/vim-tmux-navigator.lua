return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
  },
  keys = {
    { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>", desc = "Go to left window" },
    { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>", desc = "Go to lower window" },
    { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>", desc = "Go to upper window" },
    { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>", desc = "Go to right window" },
  },
}
