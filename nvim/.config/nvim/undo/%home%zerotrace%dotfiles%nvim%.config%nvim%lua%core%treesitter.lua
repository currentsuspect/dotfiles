Vim�UnDo� W�b���} g��Guꖥ��~xG�J�   b                                  fⷈ    _�                             ����                                                                                                                                                                                                                                                                                                                                                V       fⷄ     �                 -- lua/core/treesitter.lua       *require('nvim-treesitter.configs').setup({   ~    ensure_installed = { "bash", "python", "javascript", "html", "css", "lua", "go", "rust" }, -- Add more languages as needed       highlight = {           enable = true,   2        additional_vim_regex_highlighting = false,       },       indent = {           enable = true,       },       context_commentstring = {           enable = true,           config = {   !            javascript = "// %s",               python = "# %s",   
        },       },   })5��                                  �             5�_�                             ����                                                                                                                                                                                                                                                                                                                                                V       f⷇    �                   �               5��                    a                       �      5��