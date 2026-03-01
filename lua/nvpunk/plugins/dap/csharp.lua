return {
    'nicholasmata/nvim-dap-cs',
    dependencies = { 'mfussenegger/nvim-dap' },
    config = function()
        require('dap-cs').setup {
            netcoredbg = {
                path = vim.fn.stdpath 'data' .. '/mason/bin/netcoredbg',
            },
        }
    end,
}
