-- lua/core/settings.lua

-- General Settings
vim.opt.number = true                      -- Show line numbers
vim.opt.relativenumber = true              -- Show relative line numbers
vim.opt.wrap = false                       -- Disable line wrapping
vim.opt.scrolloff = 8                      -- Lines of context to keep above/below cursor
vim.opt.signcolumn = "yes"                 -- Always show the sign column
vim.opt.cmdheight = 2                      -- Height of the command line
vim.opt.cursorline = true                  -- Highlight the current line
vim.opt.termguicolors = true               -- Enable 24-bit RGB color in the TUI
vim.opt.background = "dark"                -- Set background color to dark
vim.opt.mouse = "a"                       -- Enable mouse support
vim.opt.clipboard = "unnamedplus"          -- Use the system clipboard
vim.opt.hidden = true                      -- Allow switching between buffers without saving

-- Search Settings
vim.opt.hlsearch = false                   -- Disable search highlighting
vim.opt.ignorecase = true                  -- Ignore case when searching
vim.opt.smartcase = true                   -- Override ignorecase if search pattern contains uppercase

-- Indentation and Formatting
vim.opt.tabstop = 4                        -- Number of spaces per tab
vim.opt.shiftwidth = 4                     -- Number of spaces for each indentation level
vim.opt.expandtab = true                   -- Use spaces instead of tabs
vim.opt.textwidth = 80                     -- Maximum width of text
vim.opt.breakindent = true                 -- Break lines with indentation
vim.opt.breakindentopt = "shift:2"         -- Indentation level for wrapped lines
vim.opt.smartindent = true                 -- Automatically indent new lines
vim.opt.fileformats = "unix,dos"           -- Recognize Unix and DOS file formats

-- Display Settings
vim.opt.colorcolumn = "80"                 -- Highlight the 80th column
vim.opt.list = true                        -- Show whitespace characters
vim.opt.listchars = "tab:» ,trail:·,eol:¬" -- Characters used for displaying whitespace
vim.opt.ruler = true                       -- Show the cursor position in the status line
vim.opt.sidescroll = 1                     -- Number of columns to scroll horizontally
vim.opt.sidescrolloff = 5                  -- Minimum number of columns to keep off screen horizontally
vim.opt.foldmethod = "indent"              -- Folding method based on indentation
vim.opt.foldlevel = 99                     -- Open all folds by default
vim.opt.foldenable = false                 -- Disable folding by default

-- Performance and UI
vim.opt.lazyredraw = true                  -- Redraw only when necessary
vim.opt.updatetime = 250                   -- Time in ms to wait before triggering CursorHold events
vim.opt.pumblend = 10                      -- Popup menu transparency
vim.opt.winblend = 10                      -- Window transparency
vim.opt.signcolumn = "yes:1"               -- Show the sign column with some space
vim.opt.winheight = 20                     -- Height of windows
vim.opt.winwidth = 30                      -- Width of windows
vim.opt.showcmd = true                     -- Show command in the status line
vim.opt.showtabline = 2                    -- Always show tab line
vim.opt.laststatus = 2                     -- Always show the status line
vim.opt.guifont = "FiraCode Nerd Font:h11" -- GUI font settings
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20" -- Cursor shapes

-- Undo and Backup
vim.opt.swapfile = false                   -- Disable swap files
vim.opt.backup = false                     -- Disable backup files
vim.opt.undofile = true                    -- Enable persistent undo
vim.opt.undodir = os.getenv("HOME") .. "/.config/nvim/undo" -- Directory for undo files
vim.opt.undolevels = 1000                  -- Number of undo levels
vim.opt.undoreload = 10000                 -- Size of undo history

-- Miscellaneous
vim.opt.completeopt = "menuone,noinsert,noselect" -- Autocompletion options
vim.opt.inccommand = "split"                -- Preview incremental changes
vim.opt.exrc = true                        -- Use .nvimrc files in current directory
vim.opt.backspace = "indent,eol,start"      -- Configure backspace behavior
vim.opt.virtualedit = "all"                 -- Enable virtual editing
vim.opt.fillchars = "eob: ,diff:╱"          -- Fill characters for end of buffer and diff mode
vim.opt.sidescrolloff = 5                   -- Minimum number of columns to keep off screen horizontally
vim.opt.foldtext = "v:lua.foldtext()"      -- Custom fold text function
vim.opt.breakindent = true                  -- Break indentation
vim.opt.textwidth = 80                      -- Wrap text at 80 columns
vim.opt.listchars:append("eol:¬")           -- Show end-of-line characters
vim.opt.fileformats = "unix,dos"            -- File formats to recognize
vim.opt.smartindent = true                  -- Smart auto-indenting
vim.opt.wrapscan = false                    -- Disable wrapping scan for searches
vim.opt.diffopt:append("vertical")          -- Vertical diff layout

-- Custom Commands and Functions
vim.cmd [[
  command! -nargs=* W w
  command! -nargs=* Q q
]]

