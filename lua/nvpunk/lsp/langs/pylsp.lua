return require('nvpunk.lsp.langs.default').add_to_default {
    settings = {
        pylsp = {
            plugins = {
                rope = {
                    extensionModules = { 'gi' },
                },
                jedi = {
                    extra_paths = {},
                },
            },
        },
    },
}
