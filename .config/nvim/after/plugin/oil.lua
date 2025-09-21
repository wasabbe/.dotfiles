vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
require("oil").setup({
  columns = {
    "icon",
    "size",
  },
  keymaps = {
    ["<C-s>"] = false,
    ["<C-h>"] = false,
    ["<C-t>"] = false,
    ["<C-l>"] = false,
    ["<C-p>"] = {
      "actions.preview",
      opts = {
        vertical = true,
        split = "botright"
      }
    },
  },
  view_options = {
    show_hidden = true,
  },
  watch_for_changes = true
})
