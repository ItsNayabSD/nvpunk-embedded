local PFX = 'nvpunk.plugins.interface.'
local plugins = {
    'devicons',
    'whichkey',
    'nui',
    'treesitter',
    'alpha',
    'bqf',
    'bufferline',
    'gitsigns',
    'highlight_colors',
    'lualine',
    'navic',
    'neotree',
    'noice',
    'ufo',
    'statuscol',
    'todo_comments',
}

return vim.tbl_map(function(plugin) return require(PFX .. plugin) end, plugins)
