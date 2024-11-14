---
-- LSP configuration
---
if vim.fn.has('linux') then
    local fnm_alias = vim.fs.normalize('$HOME/.local/share/fnm/aliases/lts')
    local node_dir = fnm_alias .. '/bin/'
    if (vim.fn.isdirectory(node_dir)) then
        vim.env.PATH = node_dir .. ':' .. vim.env.PATH
    end
end

local lsp_zero = require('lsp-zero')

local lsp_attach = function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.default_keymaps({ buffer = bufnr })
end

lsp_zero.extend_lspconfig({
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
    lsp_attach = lsp_attach,
    float_border = 'rounded',
    sign_text = true,
})

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {
        'lua_ls',
        'bashls',
        'dockerls',
        'marksman',
        'pyright',
        'tsserver',
        'yamlls'
    },
    handlers = {
        function(server_name)
            require('lspconfig')[server_name].setup({})
        end,
    },
})
