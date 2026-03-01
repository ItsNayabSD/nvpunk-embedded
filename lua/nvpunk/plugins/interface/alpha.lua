-- greeter
return {
    'goolord/alpha-nvim',
    branch = 'main',
    config = function()
        local icons = require 'nvpunk.internals.icons'
        local dashboard = require 'alpha.themes.dashboard'

        local header =
            require('nvpunk.internals.greeter_headers').images[require(
                'nvpunk.preferences'
            ).get_greeter()]

        dashboard.section.header.val = header.content
        dashboard.section.header.opts.hl = header.hl

        local function button(sc, txt, cmd, hl)
            local b = dashboard.button(sc, txt, cmd)
            b.opts.hl = hl or 'Title'
            b.opts.hl_shortcut = 'Comment'
            return b
        end

        dashboard.section.buttons.val = {
            button(
                'fn',
                icons.new_file .. '  New file',
                ':NvpunkNewFileDialog<CR>'
            ),
            button(
                'ge',
                icons.folder .. '  Open explorer',
                ':NvpunkExplorerToggle<CR>'
            ),
            button('T', icons.shell .. '  Open terminal', ':terminal<CR>a'),
            button(
                'tf',
                icons.find .. '  Find file',
                ':lua require"nvpunk.internals.telescope_pickers".find_files()<CR>'
            ),
            button(
                'tg',
                icons.find_file .. '  Find word',
                ':lua require"nvpunk.internals.telescope_pickers".live_grep()<CR>'
            ),
            button(
                'th',
                icons.back_in_time .. '  Recent files',
                ':lua require"telescope.builtin".oldfiles()<CR>'
            ),
            { type = 'padding', val = 1 },
            button(
                'M',
                icons.library .. '  Mason Package Manager',
                ':Mason<CR>'
            ),
            button(
                'C',
                icons.tools .. '  Preferences',
                ':lua require"nvpunk.preferences".preferences_menu()<CR>'
            ),
            button(
                'cU',
                icons.package_down .. '  Update Nvpunk',
                ':lua require"nvpunk.punk_funcs".nvpunk_update()<CR>'
            ),
            button('uT', icons.tree .. '  Update TreeSitter', ':TSUpdate<CR>'),
            button(
                'nI',
                icons.cog .. '  Installers',
                ':lua require"nvpunk.internals.installers.installers_menu".installers_menu()<CR>'
            ),
            button(
                'ch',
                icons.stethoscope .. '  Health Check',
                ':lua require"nvpunk.internals.healthcheck"()<CR>'
            ),
            button(
                'H',
                icons.help .. '  Nvpunk Documentation',
                ':h nvpunk<CR>'
            ),
            { type = 'padding', val = 1 },
            button('q', icons.quit .. '  Quit', ':qa<CR>', 'NvpunkRed'),
        }

        local function get_nvpunk_version()
            return '#'
                .. vim.trim(
                    vim.split(
                        vim.api.nvim_exec2(
                            '!git -C "'
                                .. vim.fn.stdpath 'config'
                                .. '" describe --always',
                            { output = true }
                        ).output,
                        '\r'
                    )[2]
                )
        end

        local function get_neovim_version()
            local v = vim.version()
            return 'v'
                .. tostring(v.major)
                .. '.'
                .. tostring(v.minor)
                .. '.'
                .. tostring(v.patch)
        end

        dashboard.section.footer.val = icons.info
            .. ' Nvpunk '
            .. get_nvpunk_version()
            .. '   '
            .. icons.neovim
            .. ' Neovim '
            .. get_neovim_version()
        dashboard.section.footer.opts.hl = 'Comment'

        dashboard.config.layout = {
            { type = 'padding', val = 3 },
            dashboard.section.header,
            { type = 'padding', val = 2 },
            dashboard.section.buttons,
            { type = 'padding', val = 2 },
            dashboard.section.footer,
        }

        dashboard.section.buttons.opts.spacing = 0
        dashboard.config.opts.keymap = {
            press = { '<CR>', '<2-LeftMouse>' },
        }
        require('alpha').setup(dashboard.config)

        require('nvpunk.internals.keymapper').nkeymap(
            '<leader>A',
            '<CMD>Alpha<CR>',
            'Open Greeter',
            icons.home
        )
    end,
}
