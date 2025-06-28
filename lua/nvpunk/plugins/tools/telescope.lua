-- Telescope: modular, powerful, extensible fuzzy finder
local icons = require 'nvpunk.internals.icons'
return {
    'nvim-telescope/telescope.nvim',
    lazy = true,
    init = function()
        require('which-key').add {
            { '<leader>t', group = 'Telescope', icon = icons.telescope },
        }
    end,
    config = function()
        local telescope = require 'telescope'
        -- local actions = require'telescope.actions'

        telescope.setup {
            defaults = {
                prompt_prefix = icons.telescope .. ' ',
                selection_caret = icons.telescope_caret .. ' ',
                path_display = { 'smart' },
            },
            extensions = {
                ['ui-select'] = {
                    require('telescope.themes').get_dropdown {},
                },
            },
        }
    end,
    keys = {
        {
            '<leader>tt',
            function()
                require('nvpunk.internals.telescope_pickers').resume()
            end,
            desc = 'Last search',
        },
        {
            '<leader>tf',
            function()
                require('nvpunk.internals.telescope_pickers').find_files()
            end,
            desc = 'Open file',
        },
        {
            '<leader>tg',
            function()
                require('nvpunk.internals.telescope_pickers').live_grep()
            end,
            desc = 'Live grep',
        },
        {
            '<leader>tr',
            function() require('telescope.builtin').lsp_references() end,
            desc = 'Browse references',
        },
        {
            '<leader>th',
            function() require('telescope.builtin').oldfiles() end,
            desc = 'Recent files',
        },
        {
            '<leader>tH',
            '<cmd>h nvpunk-shortcuts-telescope<cr>',
            desc = 'Show Shortcuts',
        },
    },
    cmd = {
        'Telescope',
    },
}
