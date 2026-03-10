return {
  'nvim-telescope/telescope.nvim',
  version = '*',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = "project find" })
    vim.keymap.set('n', '<leader>pg', builtin.git_files, { desc = "git find" })
    vim.keymap.set('n', '<leader>ps', builtin.live_grep, { desc = "grep search" })
    vim.keymap.set('n', '<leader>ds', builtin.lsp_document_symbols, { desc = "document symbols" })
    vim.keymap.set('n', '<leader>vh', builtin.help_tags, { desc = "get vim help" })
    vim.keymap.set('n', '<leader>vk', builtin.keymaps, { desc = "list keymaps" })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "list buffers" })
    vim.keymap.set('n', '<leader>z', builtin.spell_suggest, { desc = "spelling suggestion" })
  end,
}
