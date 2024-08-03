-- lua/core/telescope.lua

local telescope = require('telescope')

telescope.setup({
    defaults = {
        file_ignore_patterns = {"node_modules", ".git"},
        mappings = {
            i = {
                ["<C-u>"] = false,
                ["<C-d>"] = false,
            },
        },
    },
})

