-- For `plugins/markview.lua` users.
return {
  "OXY2DEV/markview.nvim",
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },

  -- For `nvim-treesitter` users.
  priority = 49,

  config = function()
    require("markview").setup({
      icons = "devicons",
      preview = {
        filetypes = { "markdown", "quarto", "rmd", "typst", "octo" },
        ignore_buftypes = {},
      },
    })
  end,

  -- For blink.cmp's completion
  -- source
  -- dependencies = {
  --     "saghen/blink.cmp"
  -- },
};
