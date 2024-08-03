-- lua/core/nvimtree.lua

require('nvim-tree').setup({
    sort_by = 'name',
    view = {
        width = 30,
        side = 'left',
    },
    filters = {
        dotfiles = false,
    },
})

