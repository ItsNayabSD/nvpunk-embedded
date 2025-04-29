local M = {}

--- Send notification with jdtls context
---@param msg string
---@param type? number from vim.log.levels
local function this_notif(msg, type)
    if type == nil then type = vim.log.levels.INFO end
    vim.notify(msg, type, { title = 'nvpunk.lsp.jdtls' })
end

local function this_err(msg) this_notif(msg, vim.log.levels.ERROR) end

local jdtls = require 'jdtls'
local jdtls_setup = require 'jdtls.setup'
local jdtls_dap = require 'jdtls.dap'

local data_dir = vim.fn.stdpath 'data'
local jdtls_install = data_dir .. '/mason/packages/jdtls'

local vscode_java_test_path = data_dir .. '/vscode-java-test'
local java_debug_path = data_dir .. '/java-debug'

-- replace with a specific java version (newer is better)
local java_home = ''
local java_exec = 'java'

M.has_java_debug = function()
    return vim.fn.filereadable(
        vim.fn.glob(
            java_debug_path
                .. '/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar'
        )
    ) ~= 0
end

M.has_vscode_java_test = function()
    return vim.fn.filereadable(
        vim.fn.glob(
            vscode_java_test_path
                .. '/server/com.microsoft.java.test.plugin-*.jar'
        )
    ) ~= 0
end

M.start_jdtls = function()
    local bundles = {}
    if M.has_java_debug() then
        table.insert(
            bundles,
            vim.fn.glob(
                java_debug_path
                    .. '/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar'
            )
        )
    end
    if M.has_vscode_java_test() then
        vim.list_extend(
            bundles,
            vim.split(
                vim.fn.glob(vscode_java_test_path .. '/server/*.jar'),
                '\n'
            )
        )
    end

    local extendedClientCapabilities = jdtls.extendedClientCapabilities
    extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

    local workspace = vim.fn.stdpath 'data' .. '/nvpunk_jdtls_workspace'

    -- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
    local config = {
        -- The command that starts the language server
        -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
        cmd = {

            java_exec, -- or '/path/to/java11_or_newer/bin/java'
            -- depends on if `java` is in your $PATH env variable and if it points to the right version.

            '-Declipse.application=org.eclipse.jdt.ls.core.id1',
            '-Dosgi.bundles.defaultStartLevel=4',
            '-Declipse.product=org.eclipse.jdt.ls.core.product',
            '-Dlog.protocol=true',
            '-Dlog.level=ALL',
            '-javaagent:' .. jdtls_install .. '/lombok.jar',
            '-Xms1g',
            '-Xmx2G',

            '-jar',
            vim.fn.glob(
                jdtls_install .. '/plugins/org.eclipse.equinox.launcher_*.jar'
            ),

            '-configuration',
            jdtls_install .. '/config_linux',
            '-data',
            workspace,

            '--add-modules=ALL-SYSTEM',
            '--add-opens',
            'java.base/java.util=ALL-UNNAMED',
            '--add-opens',
            'java.base/java.lang=ALL-UNNAMED',

            -- See `data directory configuration` section in the README
        },

        -- 💀
        -- This is the default if not provided, you can remove it. Or adjust as needed.
        -- One dedicated LSP server & client will be started per unique root_dir
        root_dir = jdtls_setup.find_root { 'pom.xml', '.git', 'mvnw', 'gradlew' },

        -- Here you can configure eclipse.jdt.ls specific settings
        -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
        -- for a list of options
        settings = {
            java = {
                eclipse = { downloadSources = true },
                maven = { downloadSources = true },
                configuration = { updateBuildConfiguration = 'interactive' },
                implementationCodeLens = { enabled = true },
                referencesCodeLens = { enabled = true },
                references = { includeDecompiledSources = true },
                inlayHints = { parameterNames = { enabled = true } },
                format = { enabled = false },
            },
            signatureHelp = { enabled = true },
            extendedClientCapabilities = extendedClientCapabilities,
        },

        -- Language server `initializationOptions`
        -- You need to extend the `bundles` with paths to jar files
        -- if you want to use additional eclipse.jdt.ls plugins.
        --
        -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
        --
        -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
        flags = { allow_incremental_sync = true },
        init_options = {
            bundles = bundles,
        },

        on_attach = function(client, bufnr)
            local function extra_keymaps(bm)
                bm.nkeymap(
                    '<leader>bjr',
                    '<cmd>JdtRefreshDebugConfigs<cr>',
                    'Refresh Java Debugger Conf'
                )
                bm.nkeymap(
                    '<leader>bjc',
                    '<cmd>lua require"jdtls".test_class()<cr>',
                    'Test Class'
                )
                bm.nkeymap(
                    '<leader>bjn',
                    '<cmd>lua require"jdtls".test_nearest_method()<cr>',
                    'Test Nearest Method'
                )
            end
            require('nvpunk.lsp.keymaps').set_lsp_keymaps(
                client,
                bufnr,
                extra_keymaps
            )
            if M.has_java_debug() then
                jdtls_dap.setup_dap_main_class_configs()
                jdtls.setup_dap { hotcodereplace = 'auto' }
            end
        end,
        capabilities = require('nvpunk.lsp.capabilities').capabilities,
    }

    -- This starts a new client & server,
    -- or attaches to an existing client & server depending on the `root_dir`.
    jdtls.start_or_attach(config)
end

M.setup = function()
    require 'nvpunk.internals.find_jdtls_java'(function(home)
        if home == nil then
            return
        end
        java_exec = (home .. '/bin/java') or java_exec
        java_home = home
        M.start_jdtls()
    end, true)
end

return M
