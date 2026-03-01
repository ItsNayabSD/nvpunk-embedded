local PFX = 'nvpunk.plugins.dap.'
local plugins = {
    'dap',
    'mason_dap',
    'dap_ui',
    'dap_virtual_text',
    'csharp',
}

return vim.tbl_map(function(plugin) return require(PFX .. plugin) end, plugins)
