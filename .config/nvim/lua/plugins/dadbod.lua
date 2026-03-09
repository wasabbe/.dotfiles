return {
  'kristijanhusak/vim-dadbod-ui',
  dependencies = {
    { 'tpope/vim-dadbod', lazy = true },
  },
  cmd = {
    'DBUI',
    'DBUIToggle',
    'DBUIAddConnection',
    'DBUIFindBuffer',
  },
  init = function()
    -- Your DBUI configuration
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_win_position = 'left'
    vim.g.db_ui_use_nvim_notify = 1
  end,
  keys = {
    {
      '<leader>db',
      function()
        -- Check if DBUI tab exists
        for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
          local wins = vim.api.nvim_tabpage_list_wins(tab)
          for _, win in ipairs(wins) do
            local buf = vim.api.nvim_win_get_buf(win)
            local bufname = vim.api.nvim_buf_get_name(buf)
            if bufname:match('dbui') then
              -- Switch to the DBUI tab
              vim.api.nvim_set_current_tabpage(tab)
              return
            end
          end
        end
        -- If not found, open DBUI in a new tab
        vim.cmd('tabnew')
        vim.cmd('DBUI')
      end,
      desc = 'Open/Switch to Database UI Tab'
    },
  },
}
