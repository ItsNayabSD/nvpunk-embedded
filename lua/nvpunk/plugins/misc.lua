return {
    -- utility functions; common dependency
    { 'nvim-lua/plenary.nvim', lazy = true },

    -- automatic mkdir on new file save if dir does not exist
    { 'jghauser/mkdir.nvim' },
    {
        'echasnovski/mini.trailspace',
        event = 'BufEnter',
        version = false,
        config = function() require('mini.trailspace').setup() end,
        keys = {
            {
                '<space>Wt',
                function() require('mini.trailspace').trim() end,
                desc = 'Trim all whitespace',
            },
        },
    },
    {
        'folke/snacks.nvim',
        priority = 1000,
        ---@type snacks.Config
        opts = {
            bigfile = { enabled = true },
            dashboard = { enabled = false },
            explorer = { enabled = false },
            indent = {
                enabled = true,
                animate = {
                    enabled = false,
                },
                scope = {
                    underline = true,
                },
            },
            input = { enabled = true, },
            picker = {
                enabled = true,
                ui_select = true,
            },
            notifier = {
                enabled = true,
                style = 'compact',
            },
            quickfile = { enabled = false },
            scope = { enabled = false },
            scroll = { enabled = false },
            statuscolumn = { enabled = false },
            words = { enabled = false },
        },
        lazy = false,
        keys = {
            -- notifier
            {
                '<leader>nd',
                function() Snacks.notifier.hide() end,
                desc = 'Dismiss Notifications',
            },
            {
                '<leader>nl',
                function() Snacks.notifier.show_history() end,
                desc = 'List Notifications',
            },
        },
    },
}
