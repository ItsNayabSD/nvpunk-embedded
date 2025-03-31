local function get_scripts_from_package_json()
    local package_json_path = vim.fn.getcwd() .. '/package.json'
    if vim.fn.filereadable(package_json_path) == 0 then return {} end
    local package_json = nil
    pcall(
        function()
            package_json = vim.json.decode(
                table.concat(vim.fn.readfile(package_json_path), '\n')
            )
        end
    )
    if package_json == nil then
        vim.notify('Failed to parse package.json', 'error', {
            title = 'DAP',
        })
        return {}
    end
    local res = {}
    for script, _ in pairs(package_json.scripts) do
        table.insert(res, {
            type = 'pwa-node',
            request = 'launch',
            name = 'npm run ' .. script,
            cwd = vim.fn.getcwd(),
            runtimeArgs = { 'run', script },
            runtimeExecutable = 'npm',
            args = {},
            sourceMaps = true,
            protocol = 'inspector',
            skipFiles = { '<node_internals>/**', 'node_modules/**' },
            console = 'integratedTerminal',
            resolveSourceMapLocations = {
                '${workspaceFolder}/**',
                '!**/node_modules/**',
            },
        })
    end
    return res
end

return {
    'jay-babu/mason-nvim-dap.nvim',
    config = function()
        local dap = require 'dap'
        local mason_dap = require 'mason-nvim-dap'
        mason_dap.setup {
            ensure_installed = {},
            automatic_installation = true,
            automatic_setup = {
                configurations = function(default) return default end,
            },
        }

        local config = {
            {
                type = 'pwa-node',
                request = 'launch',
                name = 'VscodeJS: Launch file',
                program = '${file}',
                cwd = '${workspaceFolder}',
            },
            {
                type = 'pwa-node',
                request = 'launch',
                name = 'Launch File (ts-node)',
                cwd = vim.fn.getcwd(),
                runtimeArgs = { '--loader', 'ts-node/esm' },
                runtimeExecutable = 'node',
                args = { '${file}' },
                sourceMaps = true,
                protocol = 'inspector',
                skipFiles = { '<node_internals>/**', 'node_modules/**' },
                console = 'integratedTerminal',
                resolveSourceMapLocations = {
                    '${workspaceFolder}/**',
                    '!**/node_modules/**',
                },
            },
            {
                type = 'pwa-node',
                request = 'attach',
                name = 'VscodeJS: Attach',
                processId = require('dap.utils').pick_process,
                cwd = '${workspaceFolder}',
            },
        }
        vim.list_extend(config, get_scripts_from_package_json())
        for _, lang in ipairs { 'typescript', 'javascript' } do
            local dap_conf = dap.configurations[lang] or {}
            vim.list_extend(dap_conf, config)
            dap.configurations[lang] = dap_conf
        end
    end,
}
