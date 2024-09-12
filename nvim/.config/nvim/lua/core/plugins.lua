-- lua/core/plugins.lua

require("lazy").setup({
    -- Core plugins
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-tree.lua",
    "nvim-lualine/lualine.nvim",
    "akinsho/bufferline.nvim",
    "neovim/nvim-lspconfig",
    "L3MON4D3/LuaSnip",
    "windwp/nvim-autopairs",
    "numToStr/Comment.nvim",
    "lewis6991/gitsigns.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest",
    "nvim-neotest/neotest-python",
    "nvim-neotest/nvim-nio",
    "goolord/alpha-nvim",
    "hrsh7th/nvim-cmp", -- Autocompletion plugin
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-nvim-lsp",
    "saadparwaiz1/cmp_luasnip",
    "wbthomason/packer.nvim",          -- Packer itself
    "neovim/nvim-lspconfig",           -- LSP configurations
    "hrsh7th/nvim-cmp",                -- Main completion plugin
    "hrsh7th/cmp-nvim-lsp",            -- LSP source for nvim-cmp
    "saadparwaiz1/cmp_luasnip",        -- Snippet source for nvim-cmp
    "L3MON4D3/LuaSnip",                -- Snippet engine
    "onsails/lspkind-nvim",            -- Icons for nvim-cmp

    -- Additional plugins
    "kyazdani42/nvim-web-devicons",   -- File icons
    "TimUntersberger/neogit",          -- Git integration
    "junegunn/fzf",                   -- Fuzzy finder
    "junegunn/fzf.vim",               -- FZF Vim plugin
    "ahmedkhalf/project.nvim",        -- Project management
    "ellisonleao/glow.nvim",          -- Markdown preview
    "famiu/feline.nvim",              -- Status line
    "akinsho/toggleterm.nvim",        -- Terminal integration
    "folke/trouble.nvim",             -- Troubleshooting
    "lukas-reineke/indent-blankline.nvim", -- Indentation guides
    "folke/zen-mode.nvim",            -- Zen mode
    "kylechui/nvim-surround",         -- Surround text
    "rmagatti/auto-session",          -- Session management
    "windwp/nvim-ts-autotag",         -- Auto close and rename tags
    "mhinz/vim-startify",             -- Start screen
}, {
    defaults = {
        lazy = true,
        version = "*",
    },
})

