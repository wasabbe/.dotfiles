return {
  'tamton-aquib/duck.nvim',
  opts = {
    character = "💩",
    blend = 50
  },
  config = function()
    vim.keymap.set('n', '<leader>dd', function() require("duck").hatch() end, { desc = "start ducks" })
    vim.keymap.set('n', '<leader>dk', function() require("duck").cook() end, { desc = "stop ducks" })
    vim.keymap.set('n', '<leader>da', function() require("duck").cook_all() end, { desc = "stop all ducks" })
  end
}
