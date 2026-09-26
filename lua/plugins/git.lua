local gh = require("config.pack").gh
vim.pack.add({
  gh("lewis6991/gitsigns.nvim"),
  gh("sindrets/diffview.nvim"),
  gh("akinsho/git-conflict.nvim"),
})

-- Signs + inline blame (Cursor: GitLens currentLine, delay 1000) ------------------
require("gitsigns").setup({
  signs = {
    add = { text = "▎" },
    change = { text = "▎" },
    delete = { text = "▁" },
    topdelete = { text = "▔" },
    changedelete = { text = "▎" },
    untracked = { text = "▎" },
  },
  current_line_blame = true,
  current_line_blame_opts = { virt_text_pos = "eol", delay = 1000, ignore_whitespace = false },
  current_line_blame_formatter = "<author>, <author_time:%R> • <summary>",
  on_attach = function(buf)
    local gs = require("gitsigns")
    local function map(mode, l, r, desc)
      vim.keymap.set(mode, l, r, { buffer = buf, desc = desc })
    end
    map("n", "]c", function()
      if vim.wo.diff then
        return vim.cmd.normal({ "]c", bang = true })
      end
      gs.nav_hunk("next")
    end, "Next hunk")
    map("n", "[c", function()
      if vim.wo.diff then
        return vim.cmd.normal({ "[c", bang = true })
      end
      gs.nav_hunk("prev")
    end, "Prev hunk")
    map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
    map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
    map("x", "<leader>hs", function()
      gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, "Stage selection")
    map("x", "<leader>hr", function()
      gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, "Reset selection")
    map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
    map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
    map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
    map("n", "<leader>hp", gs.preview_hunk_inline, "Preview hunk")
    map("n", "<leader>hb", function()
      gs.blame_line({ full = true })
    end, "Blame line")
    map("n", "<leader>hB", gs.blame, "Blame buffer")
    map("n", "<leader>hd", gs.diffthis, "Diff this")
    map("n", "<leader>hD", function()
      gs.diffthis("~")
    end, "Diff this ~")
    map("n", "<leader>tb", gs.toggle_current_line_blame, "Toggle line blame")
    map("n", "<leader>td", gs.toggle_deleted, "Toggle deleted lines")
    map({ "o", "x" }, "ih", gs.select_hunk, "Select hunk")
  end,
})

-- Diff / history (Cursor: git.openChange, GitLens file history) -------------------
require("diffview").setup({ enhanced_diff_hl = true })
vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Diffview open" })
vim.keymap.set("n", "<leader>gc", "<cmd>DiffviewClose<cr>", { desc = "Diffview close" })
vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", { desc = "File history" })
vim.keymap.set("n", "<leader>gH", "<cmd>DiffviewFileHistory<cr>", { desc = "Repo history" })

-- Merge conflicts (Cursor: <leader>ct incoming / <leader>co current) --------------
require("git-conflict").setup({ default_mappings = false, disable_diagnostics = true })
vim.keymap.set("n", "<leader>ct", "<Plug>(git-conflict-theirs)", { desc = "Conflict: accept incoming" })
vim.keymap.set("n", "<leader>co", "<Plug>(git-conflict-ours)", { desc = "Conflict: accept current" })
vim.keymap.set("n", "<leader>cb", "<Plug>(git-conflict-both)", { desc = "Conflict: accept both" })
vim.keymap.set("n", "<leader>c0", "<Plug>(git-conflict-none)", { desc = "Conflict: accept none" })
vim.keymap.set("n", "]x", "<Plug>(git-conflict-next-conflict)", { desc = "Next conflict" })
vim.keymap.set("n", "[x", "<Plug>(git-conflict-prev-conflict)", { desc = "Prev conflict" })
vim.keymap.set("n", "<leader>cq", "<cmd>GitConflictListQf<cr>", { desc = "Conflicts → quickfix" })
