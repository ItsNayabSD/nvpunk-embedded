-- diagnostics tray
return {
    'folke/trouble.nvim',
    lazy = true,
    config = function()
        require('trouble').setup {
            keys = {
                q = 'close', -- close the list
                ['<esc>'] = 'cancel', -- cancel the preview and get back to your last window / buffer / cursor
                r = 'refresh', -- manually refresh
                ['<cr>'] = 'jump', -- jump to the diagnostic or open / close folds
                ['<tab>'] = 'jump',
                ['<2-leftmouse>'] = 'jump',
                i = 'jump_split', -- open buffer in new split
                s = 'jump_vsplit', -- open buffer in new vsplit
                o = 'jump_close', -- jump to the diagnostic and close the list
            },
            modes = {
                diagnostics = {
                    position = 'bottom',
                },
            },
            open_no_results = true,
        }
    end,
    keys = {
        {
            '<leader>T',
            '<cmd>Trouble diagnostics toggle focus=true<cr>',
            mode = 'n',
            desc = 'Trouble',
        },
    },
    cmd = {
        'Trouble',
    },
}
