local icons = require 'nvpunk.internals.icons'

require('which-key').add {
    {
        '<leader>f',
        group = 'File',
        icon = icons.file,
        cond = function() return vim.bo.filetype == 'neo-tree' end,
    },
}
