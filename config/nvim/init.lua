-- Ensure 'lazy.nvim' is installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugin setup
require("core.plugins")

-- Load additional configurations
require("core.settings")   -- General settings
require("core.keymaps")    -- Key mappings
require("core.alpha")      -- Alpha dashboard configuration
require("core.cmp")        -- Completion configuration
require("core.treesitter") -- Treesitter configuration
require("core.lsp")        -- LSP configuration
require("core.telescope")  -- Telescope configuration
require("core.nvimtree")   -- Nvim-tree configuration
require("core.bufferline") -- Bufferline configuration
require("core.lualine")    -- Lualine configuration
require("core.zen")        -- Zen configuration
