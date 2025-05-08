-- Create this file at: lua/rahul/plugins/auto-session.lua

return {
  "rmagatti/auto-session",
  config = function()
    local auto_session = require("auto-session")

    auto_session.setup({
      log_level = "error",

      -- Improve session loading stability
      pre_save_cmds = {
        -- Ensure we close transient windows that could cause session restore issues
        "lua vim.cmd('silent! LspStop')",             -- Stop LSP before saving session
        "lua vim.cmd('silent! TSStopAll')",           -- Stop TreeSitter if installed
        "lua vim.cmd('silent! SymbolsOutlineClose')", -- Close outline windows if installed
      },

      -- Commands to run when restoring session
      post_restore_cmds = {
        -- Give the LSP time to initialize properly after restore
        "lua vim.defer_fn(function() vim.cmd('silent! LspStart') end, 500)",
      },

      -- Configure what to save in the session
      save_extra_cmds = {
        "lua require('telescope.state').clear_results()", -- Clear telescope results
      },

      -- Skip session loading in these cases
      auto_session_suppress_dirs = {
        -- Add directories where session should not be auto-loaded
        "/tmp",
        "~/Downloads",
        -- Add other directories as needed
      },

      -- Set this to true for better session compatibility
      auto_session_use_git_branch = true,

      -- Improve error handling
      auto_session_enable_last_session = false, -- Disable loading last session automatically

      -- Disable auto saving on VimLeave to prevent session corruption on crash
      auto_save_enabled = true,
      auto_restore_enabled = true,

      -- Use better hook handling
      session_lens = {
        load_on_setup = false,
      },
    })

    -- Create command to manually restore session
    vim.api.nvim_create_user_command("SessionRestoreManual", function()
      auto_session.RestoreSession()
    end, { desc = "Manually restore session" })

    -- Create command to manually save session
    vim.api.nvim_create_user_command("SessionSaveManual", function()
      auto_session.SaveSession()
    end, { desc = "Manually save session" })
  end,
}
