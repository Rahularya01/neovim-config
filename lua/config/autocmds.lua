local function augroup(name)
  return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end
local autocmd = vim.api.nvim_create_autocmd

-- vim.highlightedyank (duration 200)
autocmd("TextYankPost", {
  group = augroup("yank"),
  callback = function()
    vim.hl.on_yank({ timeout = 200 })
  end,
})

-- Restore cursor position
autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(ev)
    local exclude = { gitcommit = true }
    if exclude[vim.bo[ev.buf].filetype] or vim.b[ev.buf].last_loc_done then
      return
    end
    vim.b[ev.buf].last_loc_done = true
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(ev.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Reload files changed outside nvim
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd.checktime()
    end
  end,
})

-- Equalize splits on resize
autocmd("VimResized", {
  group = augroup("resize"),
  callback = function()
    local tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. tab)
  end,
})

-- Close utility windows with q
autocmd("FileType", {
  group = augroup("close_q"),
  pattern = { "help", "qf", "man", "checkhealth", "grug-far", "gitsigns-blame" },
  callback = function(ev)
    vim.bo[ev.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = ev.buf, silent = true, desc = "Close" })
  end,
})

-- Wrap + spell in prose
autocmd("FileType", {
  group = augroup("prose"),
  pattern = { "markdown", "gitcommit", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
    vim.opt_local.formatexpr = "" -- gq wraps text; <leader>cf / save still run conform
  end,
})

-- Create missing parent dirs on save
autocmd("BufWritePre", {
  group = augroup("mkdir"),
  callback = function(ev)
    if ev.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(ev.match) or ev.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})
