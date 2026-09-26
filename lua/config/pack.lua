-- vim.pack helpers: short GitHub sources, build hooks, and user commands.
local M = {}

function M.gh(repo)
  return "https://github.com/" .. repo
end

-- Build steps that must run after install/update. Registered before the first
-- vim.pack.add() so hooks also fire on fresh installs from the lockfile.
vim.api.nvim_create_autocmd("PackChanged", {
  group = vim.api.nvim_create_augroup("pack_hooks", { clear = true }),
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if kind ~= "install" and kind ~= "update" then
      return
    end
    if name == "blink.cmp" then
      vim.notify("blink.cmp: building fuzzy matcher from source…")
      vim.system({ "cargo", "build", "--release", "--locked" }, {
        cwd = ev.data.path,
        -- rustc's strip step yields a dylib macOS 27's dyld rejects
        -- ("mis-aligned LINKEDIT string pool"); keep symbols.
        env = { CARGO_PROFILE_RELEASE_STRIP = "false" },
      }, function(out)
        vim.schedule(function()
          if out.code == 0 then
            vim.notify("blink.cmp: build done — :restart to use it")
          else
            vim.notify("blink.cmp build failed:\n" .. (out.stderr or ""), vim.log.levels.ERROR)
          end
        end)
      end)
    end
    if name == "nvim-treesitter" then
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.schedule(function()
        pcall(vim.cmd, "TSUpdate")
      end)
    end
  end,
})

vim.api.nvim_create_user_command("PackUpdate", function(o)
  vim.pack.update(#o.fargs > 0 and o.fargs or nil)
end, { nargs = "*", desc = "Update plugins (review, then :w to confirm)" })

vim.api.nvim_create_user_command("PackClean", function()
  -- Deferred plugins (init.lua) aren't "active" until after startup; cleaning
  -- before then would delete them.
  if not vim.g.deferred_plugins_loaded then
    return vim.notify("PackClean: plugins still loading, try again in a moment", vim.log.levels.WARN)
  end
  local stale = vim
    .iter(vim.pack.get())
    :filter(function(p)
      return not p.active
    end)
    :map(function(p)
      return p.spec.name
    end)
    :totable()
  if #stale == 0 then
    return vim.notify("No unused plugins")
  end
  vim.pack.del(stale)
  vim.notify("Removed: " .. table.concat(stale, ", "))
end, { desc = "Delete plugins no longer in the config" })

vim.api.nvim_create_user_command("PackStatus", function()
  vim.pack.update(nil, { offline = true })
end, { desc = "Show installed plugins" })

return M
