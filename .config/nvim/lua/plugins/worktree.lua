return {
  'polarmutex/git-worktree.nvim',
  version = '^2',
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    -- Set up git-worktree config options (before anything else)
    vim.g.git_worktree = {
      change_directory_command = 'cd',
      update_on_change_command = 'e .',
      clearjumps_on_change = true,
      confirm_telescope_deletions = true,
      autopush = false,
    }

    -- Builtin buffer update hook is still good to keep
    local Hooks = require("git-worktree.hooks")
    Hooks.register(Hooks.type.SWITCH, Hooks.builtins.update_current_buffer_on_switch)

    -- === OIL.NVIM INTEGRATION HOOK ===
    -- Open oil.nvim in new worktree path upon switch
    Hooks.register(Hooks.type.SWITCH, function(path, _)
      if path then
        -- This will open Oil in the path of the new worktree
        vim.cmd("Oil " .. vim.fn.fnameescape(path))
      end
    end)

    -- Load Telescope git_worktree extension
    pcall(function()
      require('telescope').load_extension('git_worktree')
    end)

    -- Keymap to open the worktree picker
    vim.keymap.set('n', '<leader>gw', function()
      require('telescope').extensions.git_worktree.git_worktree()
    end, { desc = "Open Telescope git worktree picker" })
  end,
}
