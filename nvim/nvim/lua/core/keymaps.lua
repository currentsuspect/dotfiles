-- Set the leader key to space
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Basic navigation and editing
vim.api.nvim_set_keymap('n', '<Leader>w', 'w', { noremap = true, silent = true }) -- Move to the next word
vim.api.nvim_set_keymap('n', '<Leader>b', 'b', { noremap = true, silent = true }) -- Move to the previous word
vim.api.nvim_set_keymap('n', '<Leader>j', 'j', { noremap = true, silent = true }) -- Move down a line
vim.api.nvim_set_keymap('n', '<Leader>k', 'k', { noremap = true, silent = true }) -- Move up a line
vim.api.nvim_set_keymap('n', '<Leader>}', '}', { noremap = true, silent = true }) -- Move to the next paragraph
vim.api.nvim_set_keymap('n', '<Leader>{', '{', { noremap = true, silent = true }) -- Move to the previous paragraph
vim.api.nvim_set_keymap('n', '<Leader>gg', 'gg', { noremap = true, silent = true }) -- Go to the first line
vim.api.nvim_set_keymap('n', '<Leader>G', 'G', { noremap = true, silent = true }) -- Go to the last line
vim.api.nvim_set_keymap('n', '<Leader>/', '/', { noremap = true, silent = true }) -- Start a search
vim.api.nvim_set_keymap('n', '<Leader>n', 'n', { noremap = true, silent = true }) -- Jump to the next search result
vim.api.nvim_set_keymap('n', '<Leader>N', 'N', { noremap = true, silent = true }) -- Jump to the previous search result
vim.api.nvim_set_keymap('n', '<Leader>r', ':%s/', { noremap = true, silent = false }) -- Replace current word (in command mode)

-- Undo and Redo
vim.api.nvim_set_keymap('n', '<Leader>u', 'u', { noremap = true, silent = true }) -- Undo last change
vim.api.nvim_set_keymap('n', '<Leader>U', '<C-r>', { noremap = true, silent = true }) -- Redo last undone change

-- Clipboard Operations
vim.api.nvim_set_keymap('v', '<Leader>y', '"+y', { noremap = true, silent = true }) -- Yank (copy) selected text to clipboard
vim.api.nvim_set_keymap('n', '<Leader>p', '"+p', { noremap = true, silent = true }) -- Paste text from clipboard
vim.api.nvim_set_keymap('v', '<Leader>d', '"_d', { noremap = true, silent = true }) -- Delete selected text without yanking

-- Visual Mode
vim.api.nvim_set_keymap('n', '<Leader>v', 'v', { noremap = true, silent = true }) -- Enter Visual Mode
vim.api.nvim_set_keymap('n', '<Leader>V', 'V', { noremap = true, silent = true }) -- Enter Visual Line Mode

-- File Navigation
vim.api.nvim_set_keymap('n', '<Leader>ff', ':Telescope find_files<CR>', { noremap = true, silent = true }) -- Find files with Telescope
vim.api.nvim_set_keymap('n', '<Leader>fg', ':Telescope live_grep<CR>', { noremap = true, silent = true }) -- Live grep with Telescope
vim.api.nvim_set_keymap('n', '<Leader>fb', ':Telescope buffers<CR>', { noremap = true, silent = true }) -- List buffers with Telescope
vim.api.nvim_set_keymap('n', '<Leader>fh', ':Telescope help_tags<CR>', { noremap = true, silent = true }) -- Help tags with Telescope

-- File Operations
vim.api.nvim_set_keymap('n', '<Leader>tt', ':NvimTreeToggle<CR>', { noremap = true, silent = true }) -- Toggle NvimTree
vim.api.nvim_set_keymap('n', '<Leader>tl', ':NvimTreeFindFile<CR>', { noremap = true, silent = true }) -- Locate file in NvimTree
vim.api.nvim_set_keymap('n', '<Leader>tn', ':tabnew<CR>', { noremap = true, silent = true }) -- Open new tab
vim.api.nvim_set_keymap('n', '<Leader>tc', ':tabclose<CR>', { noremap = true, silent = true }) -- Close current tab
vim.api.nvim_set_keymap('n', '<Leader>sp', ':split<CR>', { noremap = true, silent = true }) -- Split window horizontally
vim.api.nvim_set_keymap('n', '<Leader>sv', ':vsplit<CR>', { noremap = true, silent = true }) -- Split window vertically

-- Buffer Management
vim.api.nvim_set_keymap('n', '<Leader>bb', ':BufferLinePick<CR>', { noremap = true, silent = true }) -- Switch to buffer by number
vim.api.nvim_set_keymap('n', '<Leader>bc', ':BufferLinePickClose<CR>', { noremap = true, silent = true }) -- Close selected buffer

-- Plugin Management
vim.api.nvim_set_keymap('n', '<Leader>pm', ':PackerUpdate<CR>', { noremap = true, silent = true }) -- Update Packer
vim.api.nvim_set_keymap('n', '<Leader>ps', ':PackerSync<CR>', { noremap = true, silent = true }) -- Sync Packer

-- LSP and Diagnostics
vim.api.nvim_set_keymap('n', '<Leader>ca', ':lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true }) -- Code action
vim.api.nvim_set_keymap('n', '<Leader>rr', ':lua vim.lsp.stop_client()<CR>:lua vim.lsp.start_client()<CR>', { noremap = true, silent = true }) -- Restart LSP
vim.api.nvim_set_keymap('n', '<Leader>rn', ':lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true }) -- Rename symbol
vim.api.nvim_set_keymap('n', '<Leader>gd', ':lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true }) -- Go to definition
vim.api.nvim_set_keymap('n', '<Leader>gi', ':lua vim.lsp.buf.implementation()<CR>', { noremap = true, silent = true }) -- Go to implementation
vim.api.nvim_set_keymap('n', '<Leader>gr', ':lua vim.lsp.buf.references()<CR>', { noremap = true, silent = true }) -- References
vim.api.nvim_set_keymap('n', '<Leader>de', ':lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true }) -- Show diagnostics
vim.api.nvim_set_keymap('n', '<Leader>f', ':lua vim.lsp.buf.formatting()<CR>', { noremap = true, silent = true }) -- Format file

-- Miscellaneous
vim.api.nvim_set_keymap('n', '<Leader>sp', ':split<CR>', { noremap = true, silent = true }) -- Split window
vim.api.nvim_set_keymap('n', '<Leader>so', ':vsplit<CR>', { noremap = true, silent = true }) -- Split window vertically

-- Zen
vim.api.nvim_set_keymap('n', '<Leader>zm', ':ZenMode<CR>', { noremap = true, silent = true })

