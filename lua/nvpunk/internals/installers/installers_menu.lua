local menu = require('nvpunk.internals.menu').menu
local format_get_label = require('nvpunk.internals.menu').format_get_label
local notif_ctx = 'Nvpunk Installers'

local M = {}

local installers_menus = {
    {
        label = 'Java Debug',
        func = function()
            require 'nvpunk.internals.find_jdtls_java'(function(home)
                if home == nil then return end
                vim.notify('Installing Java Debug...', vim.log.levels.INFO, {
                    title = notif_ctx,
                })
                vim.notify('DO NOT CLOSE NEOVIM!', vim.log.levels.ERROR, {
                    title = notif_ctx,
                })
                require 'nvpunk.internals.installers.i_java_debug'(
                    home,
                    function(success)
                        if success then
                            vim.notify(
                                'Java Debug installed',
                                vim.log.levels.INFO,
                                {
                                    title = notif_ctx,
                                }
                            )
                        else
                            vim.notify(
                                'Failed to install Java Debug',
                                vim.log.levels.ERROR,
                                {
                                    title = notif_ctx,
                                }
                            )
                        end
                    end,
                    true
                )
            end, true)
        end,
    },
    {
        label = 'Vscode Java Test',
        func = function()
            require 'nvpunk.internals.find_jdtls_java'(function(home)
                vim.notify(
                    'Installing Vscode Java Test...',
                    vim.log.levels.INFO,
                    {
                        title = notif_ctx,
                    }
                )
                vim.notify('DO NOT CLOSE NEOVIM!', vim.log.levels.ERROR, {
                    title = notif_ctx,
                })
                require 'nvpunk.internals.installers.i_vscode_java_test'(
                    home,
                    function(success)
                        if success then
                            vim.notify(
                                'Vscode Java Test installed',
                                vim.log.levels.INFO,
                                {
                                    title = notif_ctx,
                                }
                            )
                        else
                            vim.notify(
                                'Failed to install Vscode Java Test',
                                vim.log.levels.ERROR,
                                {
                                    title = notif_ctx,
                                }
                            )
                        end
                    end,
                    true
                )
            end, true)
        end,
    },
}

M.installers_menu = function()
    menu(installers_menus, {
        prompt = 'Installers:',
        format_item = format_get_label,
    }, function(item, _) item.func() end)
end

M.setup = function()
    vim.api.nvim_create_user_command(
        'NvpunkInstallers',
        function(_) M.installers_menu() end,
        { nargs = 0 }
    )
end

return M
