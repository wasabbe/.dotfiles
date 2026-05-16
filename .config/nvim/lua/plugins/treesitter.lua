return {
  "romus204/tree-sitter-manager.nvim",
  lazy = false,
  config = function()
    require("tree-sitter-manager").setup({
      ensure_installed = {
        'bash',
        'c_sharp',
        'css',
        'csv',
        'diff',
        'dockerfile',
        'go',
        'html',
        'http',
        'javascript',
        'jq',
        'jsdoc',
        'json',
        'lua',
        'markdown',
        'markdown_inline',
        'python',
        'sql',
        'typescript',
        'vim',
        'xml',
        'yaml',
      },
      auto_install = true,
      highlight = true,
    })

    vim.treesitter.language.register("markdown", "octo")
  end,
}
