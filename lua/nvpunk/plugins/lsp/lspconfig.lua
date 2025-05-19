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

        vim.lsp.config('*', require('nvpunk.lsp.default_conf').default_opts)
        -- lang specific configuration in lsp dir

        -- LSP on attach autocmd
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('nvpunk.lsp', {}),
            callback = function(args)
                require('nvpunk.lsp.default_conf').on_attach(
                    vim.lsp.get_client_by_id(args.data.client_id),
                    args.buf
                )
            end,
        })
        require('mason-lspconfig').setup {
            ensure_installed = packages,
        }
    end,
}
