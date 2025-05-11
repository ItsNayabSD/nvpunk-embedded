local icons = require 'nvpunk.internals.icons'

---@type vim.diagnostic.Opts
local diagnostic_conf = {
    -- inline errors
    virtual_text = true,
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
        focusable = false,
        style = 'minimal',
        border = require('nvpunk.preferences').get_small_window_border(),
        source = true,
        header = '',
        prefix = '',
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = icons.diag_error,
            [vim.diagnostic.severity.WARN] = icons.diag_warn,
            [vim.diagnostic.severity.INFO] = icons.diag_info,
            [vim.diagnostic.severity.HINT] = icons.diag_hint,
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
            [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
            [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
            [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
        },
    },
}
vim.diagnostic.config(diagnostic_conf)

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = require('nvpunk.preferences').get_small_window_border(),
})

vim.lsp.handlers['textDocument/signatureHelp'] =
    vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = require('nvpunk.preferences').get_small_window_border(),
    })

vim.g.rustaceanvim = {
    tools = {},
    server = {
        default_settings = {
            ['rust-analyzer'] = {
                telemetry = { enable = false },
            },
        },
    },
    dap = {},
}
