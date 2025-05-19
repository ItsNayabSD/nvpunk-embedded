-- show which key does what in long key combos
local icons = require 'nvpunk.internals.icons'
return {
    'folke/which-key.nvim',
    dependencies = {
        { 'echasnovski/mini.icons', version = false },
    },
    config = function()
        require('which-key').setup {
            icons = {
                -- symbol used in the command line area that shows your active key combo
                breadcrumb = icons.small_double_arrow_right,
                -- symbol used between a key and it's label
                separator = icons.arrow_right,
                -- symbol prepended to a group
                group = icons.plus_square,
                ellipsis = icons.ellipsis,
            },
            spelling = { enabled = true, suggestions = 20 },
            filter = function(mapping)
                return not vim.startswith(mapping.lhs, '<Esc>')
            end,
        }
    end,
    priority = 9999,
}
