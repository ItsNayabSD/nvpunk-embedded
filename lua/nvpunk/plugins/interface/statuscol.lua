return {
    'luukvbaal/statuscol.nvim',
    dependencies = {
        'kevinhwang91/nvim-ufo',
        'lewis6991/gitsigns.nvim',
    },
    config = function()
        local builtin = require 'statuscol.builtin'

        local gitsigns_click = function(args)
            if args.button == 'l' then require('gitsigns').preview_hunk() end
        end

        local nonfile = require 'nvpunk.internals.nonfile'

        local conf = {
            setopt = true, -- false uses only the click handlers
            thousands = false, -- thousands separator
            relculright = true,
            ft_ignore = nonfile.filetypes,
            bt_ignore = nonfile.buftypes,
            segments = {
                {
                    text = { builtin.foldfunc, ' ' },
                    click = 'v:lua.ScFa',
                },
                {
                    sign = { name = { 'Dap' }, maxwidth = 1, auto = true },
                    click = 'v:lua.ScSa',
                },
                {
                    text = { builtin.lnumfunc, ' ' },
                    condition = { true, builtin.not_empty },
                    click = 'v:lua.ScLa',
                },
                {
                    sign = {
                        namespace = { 'gitsigns' },
                        maxwidth = 1,
                        colwidth = 1,
                        auto = false,
                    },
                    click = 'v:lua.ScSa',
                },
                {
                    sign = {
                        namespace = { 'diagnostic*' },
                        maxwidth = 1,
                        colwidth = 1,
                        auto = false,
                    },
                    click = 'v:lua.ScSa',
                },
                { text = { ' ' } },
                {
                    text = { '▏' },
                    hl = 'WinSeparator',
                },
            },
            clickhandlers = {
                -- builtin click handlers
                Lnum = builtin.lnum_click,
                FoldClose = builtin.foldclose_click,
                FoldOpen = builtin.foldopen_click,
                FoldOther = builtin.foldother_click,
                DapBreakpointRejected = builtin.toggle_breakpoint,
                DapBreakpoint = builtin.toggle_breakpoint,
                DapBreakpointCondition = builtin.toggle_breakpoint,
                ['diagnostic/signs'] = builtin.diagnostic_click,
                GitSignsTopdelete = gitsigns_click,
                GitSignsUntracked = false,
                GitSignsAdd = gitsigns_click,
                GitSignsChange = gitsigns_click,
                GitSignsChangedelete = gitsigns_click,
                GitSignsDelete = gitsigns_click,
            },
        }
        require('statuscol').setup(conf)
    end,
}
