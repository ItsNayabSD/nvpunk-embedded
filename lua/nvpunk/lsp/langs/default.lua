local M = {}

M.default_opts = {
    root_markers = { '.git' },
    root_dir = vim.uv.cwd,
    capabilities = require('nvpunk.lsp.capabilities').capabilities,
    settings = {
        telemetry = { enable = false },
    },
}
M.add_to_default = function(opts)
    return vim.tbl_deep_extend('force', M.default_opts, opts)
end

M.on_attach = function(client, bufnr)
    require('nvpunk.lsp.keymaps').set_lsp_keymaps(client, bufnr)
    if
        require('nvpunk.preferences').get_navic_enabled()
        and client.server_capabilities.documentSymbolProvider
    then
        local navic = require('nvim-navic')
        -- avoid multiple navic attach
        if not navic.is_available(bufnr) then
            navic.attach(client, bufnr)
            vim.wo.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
        end
    end
end

M.setup_on_attach_autocmd = function()
    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('nvpunk.lsp', {}),
        callback = function(args)
            M.on_attach(vim.lsp.get_client_by_id(args.data.client_id), args.buf)
        end,
    })
end

return M
