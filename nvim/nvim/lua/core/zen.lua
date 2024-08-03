-- lua/core/zen.lua

local zen = require("zen-mode")

-- Function to adjust window height
local function set_window_height()
  local lines_above = 3
  local lines_below = 3
  local total_lines = lines_above + lines_below + 1
  vim.cmd("resize " .. total_lines)
end

zen.setup {
  -- Configuration options
  window = {
    width = 80,        -- Width of the Zen mode window
    height = 0.9,      -- Height of the Zen mode window, will be adjusted dynamically
    options = {
      signcolumn = "no",  -- Disable sign column
      number = false,     -- Disable line numbers
      relativenumber = false,  -- Disable relative line numbers
      foldcolumn = "0",  -- Disable fold column
      list = false,      -- Disable list characters (e.g., tabs and trailing spaces)
    },
  },
  plugins = {
    options = {
      enabled = true,   -- Enable or disable additional options
      ruler = false,    -- Disable ruler
      showcmd = false,  -- Disable command line echo
    },
    tmux = {        -- tmux integration
      enabled = true, -- Enable tmux integration
      status_align = "left", -- Position of the status line in tmux
    },
    kitty = {       -- Kitty terminal integration
      enabled = true, -- Enable Kitty integration
      font = "+3",   -- Increase font size in Kitty terminal
    },
  },
  hooks = {
    on_open = function(win)
      -- Custom actions to perform when Zen mode is enabled
      vim.cmd("setlocal cursorline") -- Highlight the current line
      set_window_height() -- Adjust window height

      -- Add keymap for exiting Zen Mode
      vim.api.nvim_set_keymap('n', '<Esc>', ':ZenMode<CR>', { noremap = true, silent = true })
    end,
    on_close = function(win)
      -- Custom actions to perform when Zen mode is disabled
      vim.cmd("setlocal nocursorline") -- Remove highlight from the current line

      -- Remove keymap when exiting Zen Mode
      vim.api.nvim_del_keymap('n', '<Esc>')
      
      -- Reset window height when exiting Zen Mode
      vim.cmd("resize 10") -- or any default height you prefer
    end,
  },
}

