local lsp_zero = require('lsp-zero')

if vim.fn.has('linux') then
    local fnm_alias = vim.fs.normalize('$HOME/.local/share/fnm/aliases/lts')
    local node_dir = fnm_alias .. '/bin/'
    if(vim.fn.isdirectory(node_dir)) then
        vim.env.PATH = node_dir .. ':' .. vim.env.PATH
    end
end

lsp_zero.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.default_keymaps({buffer = bufnr})
end)

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {},
    handlers = {
        lsp_zero.default_setup,
    },
})

lsp_zero.setup()
