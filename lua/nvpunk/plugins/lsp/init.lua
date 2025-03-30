local PFX = 'nvpunk.plugins.lsp.'
local plugins = {
    'lspconfig',
    'aerial',
    'cmp',
    'fidget',
    'lsp_colors',
    'lspkind',
    'mason',
    'nvim_jdtls',
    'trouble',
    'workspace_diagnostics',
}

return vim.tbl_map(function(plugin) return require(PFX .. plugin) end, plugins)
