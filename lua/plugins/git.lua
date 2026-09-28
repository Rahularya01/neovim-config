local gh = require("config.pack").gh
vim.pack.add({
  gh("lewis6991/gitsigns.nvim"),
  gh("sindrets/diffview.nvim"),
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
-- Merge conflicts (Cursor: <leader>ct incoming / <leader>co current) are resolved
-- in diffview's merge view: :DiffviewOpen during a merge/rebase. Its buffer-local
-- keys: <leader>co / ct ours / theirs, <leader>cO / cT for the whole file, ]x / [x.
local actions = require("diffview.actions")
require("diffview").setup({
  enhanced_diff_hl = true,
  keymaps = {
    view = {
      { "n", "<leader>cb", actions.conflict_choose("all"), { desc = "Conflict: accept both" } },
      { "n", "<leader>c0", actions.conflict_choose("none"), { desc = "Conflict: accept none" } },
      { "n", "<leader>ca", false }, -- keep LSP code action
    },
  },
})
vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Diffview open" })
vim.keymap.set("n", "<leader>gc", "<cmd>DiffviewClose<cr>", { desc = "Diffview close" })
vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", { desc = "File history" })
vim.keymap.set("n", "<leader>gH", "<cmd>DiffviewFileHistory<cr>", { desc = "Repo history" })

-- Conflict markers outside diffview (diffview's own ]x / [x win inside it).
vim.keymap.set("n", "]x", function()
  vim.fn.search("^<<<<<<< ", "W")
end, { desc = "Next conflict" })
vim.keymap.set("n", "[x", function()
  vim.fn.search("^<<<<<<< ", "bW")
end, { desc = "Prev conflict" })
vim.keymap.set("n", "<leader>cq", function()
  local files = vim.fn.systemlist({ "git", "diff", "--name-only", "--diff-filter=U", "--relative" })
  if vim.v.shell_error ~= 0 then
    return vim.notify("Not in a git repository", vim.log.levels.WARN)
  end
  local items = {}
  for _, file in ipairs(files) do
    for lnum, line in ipairs(vim.fn.readfile(file)) do
      if line:match("^<<<<<<< ") then
        table.insert(items, { filename = file, lnum = lnum, text = line })
      end
    end
  end
  if #items == 0 then
    return vim.notify("No conflicts")
  end
  vim.fn.setqflist({}, " ", { title = "Conflicts", items = items })
  vim.cmd("botright copen")
end, { desc = "Conflicts → quickfix" })
