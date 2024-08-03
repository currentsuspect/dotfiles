-- lua/core/lsp.lua

local lspconfig = require('lspconfig')

-- Example LSP setup for Python using `pyright`
lspconfig.pyright.setup({})

-- Example LSP setup for JavaScript/TypeScript using `tsserver`
lspconfig.tsserver.setup({})

-- Keybindings for LSP
vim.api.nvim_set_keymap('n', '<Leader>ca', '<Cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>gr', '<Cmd>lua vim.lsp.buf.references()<CR>', { noremap = true, silent = true })

