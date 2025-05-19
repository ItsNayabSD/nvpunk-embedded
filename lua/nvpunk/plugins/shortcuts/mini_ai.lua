-- despite the name this does not relate in any way to "artificial intelligence"
return {
    'echasnovski/mini.nvim',
    version = false,
    config = function()
        require('mini.ai').setup {
            silent = true,
        }
    end,
}
