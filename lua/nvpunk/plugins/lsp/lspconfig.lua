-- nvim built-in lsp additional stuff
-- easier lsp configuration
return {
    'neovim/nvim-lspconfig',
    dependencies = {
        -- neovim specific lua stuff
        {
            'folke/lazydev.nvim',
            ft = 'lua', -- only load on lua files
            opts = {
                library = {
                    -- See the configuration section for more details
                    -- Load luvit types when the `vim.uv` word is found
                    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
                },
            },
        },
    },
    config = function()
        require 'lspconfig'
        local packages = {
            'emmet_ls',
            'html',
            'lua_ls',
            'vimls',
        }

        for ls, config in ipairs {
            -- default for all language servers
            ['*'] = require('nvpunk.lsp.langs.default').default_opts,
            ['pyright'] = require 'nvpunk.lsp.langs.pyright',
            ['lua_ls'] = require 'nvpunk.lsp.langs.lua_ls',
            ['jdtls'] = {}, -- dummy, runs with filetype
            ['rust_analyzer'] = {}, -- dummy, use rustacean
            ['ltex'] = require 'nvpunk.lsp.langs.ltex',
            ['pylsp'] = require 'nvpunk.lsp.langs.pylsp',
        } do
            vim.lsp.config(ls, config)
        end

        require('nvpunk.lsp.langs.default').setup_on_attach_autocmd()
        require('mason-lspconfig').setup {
            ensure_installed = packages,
        }
    end,
}
