local lspconfig = require 'lspconfig'
local add_to_default = require('nvpunk.lsp.langs.default').add_to_default

return add_to_default {
    settings = {
        ltex = {
            language = 'auto',
        },
    },
}
