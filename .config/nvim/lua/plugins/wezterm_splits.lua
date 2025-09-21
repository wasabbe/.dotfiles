return {
  "mrjones2014/smart-splits.nvim",
  config = function()
    local plugin = require("smart-splits")
    local keymap = vim.keymap
    -- resizing splits
    keymap.set("n", "<A-Up>", plugin.resize_up, { desc = "Resize split up" })
    keymap.set("n", "<A-Down>", plugin.resize_down, { desc = "Resize split down" })
    keymap.set("n", "<A-Left>", plugin.resize_left, { desc = "Resize split left" })
    keymap.set("n", "<A-Right>", plugin.resize_right, { desc = "Resize split right" })
    -- moving between splits
    keymap.set("n", "<A-h>", plugin.move_cursor_left, { desc = "Move to left split" })
    keymap.set("n", "<A-j>", plugin.move_cursor_down, { desc = "Move to below split" })
    keymap.set("n", "<A-k>", plugin.move_cursor_up, { desc = "Move to above split" })
    keymap.set("n", "<A-l>", plugin.move_cursor_right, { desc = "Move to right split" })
    -- swapping splits
    keymap.set('n', '<leader><leader>h', plugin.swap_buf_left, { desc = "Swap buffer with left split" })
    keymap.set('n', '<leader><leader>j', plugin.swap_buf_down, { desc = "Swap buffer with below split" })
    keymap.set('n', '<leader><leader>k', plugin.swap_buf_up, { desc = "Swap buffer with above split" })
    keymap.set('n', '<leader><leader>l', plugin.swap_buf_right, { desc = "Swap buffer with right split" })
  end
}
