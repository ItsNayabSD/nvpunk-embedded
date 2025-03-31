local M = {}

local icons = require 'nvpunk.internals.icons'

M.dap_signs = {
    {
        name = 'DapBreakpoint',
        text = icons.debug_breakpoint,
        texthl = 'DiagnosticSignError',
    },
    {
        name = 'DapBreakpointRejected',
        text = icons.debug_rejected,
        texthl = 'DiagnosticSignWarn',
    },
    {
        name = 'DapStopped',
        text = icons.debug_stopped,
        texthl = 'GitSignsDelete',
        linehl = 'GitSignsDeleteLn',
    },
}

M.setup = function()
    for _, sign in ipairs(M.dap_signs) do
        vim.fn.sign_define(sign.name, {
            texthl = sign.texthl or sign.name,
            text = sign.text,
            numhl = sign.numl or '',
            linehl = sign.linehl or '',
        })
    end
end

return M
