if vim.fn.has('linux') then
  local fnm_alias = vim.fs.normalize('$HOME/.local/share/fnm/aliases/lts')
  local node_dir = fnm_alias .. '/bin/'
  if (vim.fn.isdirectory(node_dir)) then
    vim.env.PATH = node_dir .. ':' .. vim.env.PATH
  end
end

if vim.fn.has('mac') then
  local fnm_alias = vim.fs.normalize('~/Library/Application Support/fnm/aliases/lts')
  local node_dir = fnm_alias .. '/bin/'
  if (vim.fn.isdirectory(node_dir)) then
    vim.env.PATH = node_dir .. ':' .. vim.env.PATH
  end
end


local languages = {
  'lua_ls',
  'angularls',
  'bashls',
  'cssls',
  'dockerls',
  'html',
  'jsonls',
  'marksman',
  'pyright',
  'ts_ls',
  'yamlls',
  'hls'
}

require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = languages,
  automatic_installation = false
}
require("mason-nvim-dap").setup({
  ensure_installed = { "js-debug-adapter" },
  handlers = {
    function(config)
      -- This magic function auto-configures every adapter
      -- installed via Mason for use with nvim-dap
      require('mason-nvim-dap').default_setup(config)
    end,
  },
  automatic_installation = false
})

vim.o.winborder = 'rounded'
vim.opt.completeopt = { 'menu', 'menuone', 'noinsert' }

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
        end,
      })
    end
  end,
})

local capabilities = {
  textDocument = {
    foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true
    },
    completion = {
      completionItem = {
        snippetSupport = true,
      }
    }
  }
}

vim.lsp.config(
  "*",
  {
    capabilities = require('blink.cmp').get_lsp_capabilities(capabilities),
    root_markers = { '.git' },
  })

vim.lsp.config('hls', {
  filetypes = { 'haskell', 'lhaskell', 'cabal' },
})

vim.lsp.enable(languages)
