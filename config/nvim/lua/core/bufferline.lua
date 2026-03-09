-- lua/core/bufferline.lua

require('bufferline').setup({
    options = {
        numbers = "none",
        close_command = "bdelete! %d",
        right_mouse_command = "bdelete! %d",
        left_mouse_command = "buffer %d",
        middle_mouse_command = nil,
        indicator_icon = '▎',
        buffer_close_icon = '',
        modified_icon = '●',
        close_icon = '',
        left_trunc_marker = '',
        right_trunc_marker = '',
        name_formatter = function(buf)  -- buf contains the buffer name
            return buf.name
        end,
    }
})

