                                                 -- lua/core/lualine.lua

local lualine = require('lualine')

lualine.setup({
  options = {
    theme = 'gruvbox',  -- Change this to your preferred theme
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    icons_enabled = true,
    globalstatus = true,  -- Use global status line if you have multiple windows
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = {
      {
        'filename',
        path = 1,  -- Relative path
        shorting_target = 40,
        symbols = {
          modified = '[+]',      -- Text to show when a buffer is modified
          readonly = '[-]',     -- Text to show when a buffer is readonly
          unnamed = '[No Name]', -- Text to show for unnamed buffers
        }
      },
      {
        'diagnostics',
        sources = { 'nvim_lsp' },
        symbols = { error = 'E:', warn = 'W:', info = 'I:', hint = 'H:' },
      }
    },
    lualine_x = {
      'encoding',
      'fileformat',
      'filetype',
      {
        'progress',
        separator = { left = '', right = '' }, -- Add separators around progress
      }
    },
    lualine_y = { 'location' },
    lualine_z = { 'progress' },
  },
  extensions = { 'fugitive', 'nvim-tree' }, -- Extensions to integrate with
})

