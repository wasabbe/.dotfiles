---@brief
---
--- [cspell language server](https://github.com/vlabo/cspell-lsp)
---
return {
  cmd = { 'cspell-lsp', '--config', ' ~/.config/cspell/cspell.json', '--stdio' },
  filetypes = {
    "lua",
    "python",
    "javascript",
    "typescript",
    "html",
    "css",
    "json",
    "yaml",
    "markdown",
    "gitcommit",
  },
  root_markers = {
    '.git',
  },
}
