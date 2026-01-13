local PFX = 'nvpunk.plugins.tools.'
local plugins = {
    'notify',
    'telescope',
    'toggleterm',
    'diffview',
    'render_markdown',
}

return vim.tbl_map(function(plugin) return require(PFX .. plugin) end, plugins)
