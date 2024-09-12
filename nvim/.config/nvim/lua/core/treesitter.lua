-- lua/core/treesitter.lua

-- Check if 'nvim-treesitter' is installed
local status_ok, configs = pcall(require, 'nvim-treesitter.configs')
if not status_ok then
    vim.notify("nvim-treesitter not found!")
    return
end

configs.setup({
    -- Languages to ensure are installed
    ensure_installed = {
        "bash", "python", "javascript", "html", "css", "lua", "go", "rust", "json",
        "yaml", "markdown", "typescript", "java", "c", "cpp", "ruby", "php", "dockerfile"
    }, 
    sync_install = false, -- Install languages synchronously (only applied to `ensure_installed`)
    auto_install = true, -- Automatically install missing parsers when entering buffer

    highlight = {
        enable = true, -- Highlight syntax using Treesitter
        additional_vim_regex_highlighting = false, -- Disable Vim's regex-based highlighting
    },
    indent = {
        enable = true, -- Enable Treesitter-based indentation
    },
    incremental_selection = {
        enable = true, -- Enable incremental selection
        keymaps = {
            init_selection = "gnn", -- Init selection in normal mode
            node_incremental = "grn", -- Increment to the upper node
            scope_incremental = "grc", -- Increment to the scope
            node_decremental = "grm", -- Decrement to the previous node
        },
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to text objects
            keymaps = {
                ["af"] = "@function.outer", -- Select outer part of a function
                ["if"] = "@function.inner", -- Select inner part of a function
                ["ac"] = "@class.outer", -- Select outer part of a class
                ["ic"] = "@class.inner", -- Select inner part of a class
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ["<leader>a"] = "@parameter.inner", -- Swap with next parameter
            },
            swap_previous = {
                ["<leader>A"] = "@parameter.inner", -- Swap with previous parameter
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- Set jumps in the jumplist
            goto_next_start = {
                ["]m"] = "@function.outer", -- Move to next function start
                ["]]"] = "@class.outer", -- Move to next class start
            },
            goto_next_end = {
                ["]M"] = "@function.outer", -- Move to next function end
                ["]["] = "@class.outer", -- Move to next class end
            },
            goto_previous_start = {
                ["[m"] = "@function.outer", -- Move to previous function start
                ["[["] = "@class.outer", -- Move to previous class start
            },
            goto_previous_end = {
                ["[M"] = "@function.outer", -- Move to previous function end
                ["[]"] = "@class.outer", -- Move to previous class end
            },
        },
    },
    context_commentstring = {
        enable = true,
        enable_autocmd = false,
        config = {
            javascript = "// %s",
            python = "# %s",
            lua = "-- %s",
            html = "<!-- %s -->",
            css = "/* %s */",
        },
    },
    playground = {
        enable = true, -- Enable Treesitter playground for testing
        updatetime = 25, -- Debounced time for highlighting nodes
        persist_queries = false, -- Whether queries should persist across vim sessions
    },
    rainbow = {
        enable = true, -- Enable rainbow parentheses
        extended_mode = true, -- Highlight also non-parentheses delimiters
        max_file_lines = 1000, -- Disable for files with more than 1000 lines
    },
})

