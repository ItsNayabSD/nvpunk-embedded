local icons = require 'nvpunk.internals.icons'

local filename_widget = {
    'filename',
    file_status = true,
    newfile_staus = true,
    path = 0,
    symbols = {
        modified = icons.pencil,
        readonly = icons.lock,
        unnamed = '[No Name]',
        newfile = icons.badge_new,
    },
    on_click = function()
        local p = vim.fn.expand '%'
        if p == nil or p == '' then return end
        vim.fn.setreg('+"', p)
        vim.notify 'Copied file path to system clipboard'
    end,
}

local diagnostics_widget = {
    'diagnostics',
    sources = { 'nvim_diagnostic' },
    sections = { 'error', 'warn', 'info', 'hint' },
    symbols = {
        error = icons.diag_error .. ' ',
        warn = icons.diag_warn .. ' ',
        info = icons.diag_info .. ' ',
    },
    on_click = function(_num, btn, _mods)
        if btn == 'l' then
            vim.diagnostic.jump { count = 1, float = true }
        elseif btn == 'r' then
            vim.diagnostic.jump { count = -1, float = true }
        end
    end,
}

-- local vsplit_widget = {
--     function() return icons.win_hsplit end,
--     on_click = function() vim.cmd 'vs' end,
-- }
--
-- local hsplit_widget = {
--     function() return icons.win_vsplit end,
--     on_click = function() vim.cmd 'sp' end,
-- }
--
-- local term_widget = {
--     function() return icons.shell end,
--     on_click = function() vim.cmd 'ToggleTerm' end,
-- }

-------- part of noice, disabled
-- local macro_widget = {
--     require('noice').api.status.mode.get,
--     cond = require('noice').api.status.mode.has,
-- }
--
-- local search_widget = {
--     require('noice').api.status.search.get,
--     cond = require('noice').api.status.search.has,
--     on_click = function(_num, btn, _mods)
--         if btn == 'l' then
--             vim.cmd 'norm n'
--         elseif btn == 'r' then
--             vim.cmd 'norm N'
--         end
--     end
-- }

local styles = {
    powerline = {
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
    },
    plain = {
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
    },
    plain_separators = {
        section_separators = { left = '', right = '' },
        component_separators = { left = '│', right = '│' },
    },
    slant_low = {
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
    },
    slant_high = {
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
    },
    round = {
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
    },
    pixel = {
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
    },
}

local function navic_widget(style)
    return {
        'navic',
        color_correction = 'static',
        padding = {
            left = 1,
            right = 0,
        },
        navic_opts = {
            icons = {
                File = icons.file .. ' ',
                Module = icons.puzzle .. ' ',
                Namespace = icons.curlybraces .. ' ',
                Package = icons.package .. ' ',
                Class = icons.struct .. ' ',
                Method = icons.method .. ' ',
                Property = icons.property .. ' ',
                Field = icons.field .. ' ',
                Constructor = icons.crane .. ' ',
                Enum = icons.enum .. ' ',
                Interface = icons.interface .. ' ',
                Function = icons.function_ .. ' ',
                Variable = icons.variable .. ' ',
                Constant = icons.constant .. ' ',
                String = icons.string .. ' ',
                Number = icons.number .. ' ',
                Boolean = icons.boolean .. ' ',
                Array = icons.array .. ' ',
                Object = icons.curlybraces .. ' ',
                Key = icons.key .. ' ',
                Null = icons.null .. ' ',
                EnumMember = icons.enum_member .. ' ',
                Struct = icons.struct .. ' ',
                Event = icons.event .. ' ',
                Operator = icons.operator .. ' ',
                TypeParameter = icons.big_t .. ' ',
            },
            highlight = true,
            separator = ' ' .. style.component_separators.left .. ' ',
            depth_limit = 0,
            depth_limit_indicator = '…',
            safe_output = true,
        },
    }
end

local file_icon_widget =
    { 'filetype', icon_only = true, icon = { align = 'right' } }

local nonfile = require 'nvpunk.internals.nonfile'

return function(theme)
    local preferences = require 'nvpunk.preferences'
    local style = styles[preferences.get_statusline_style()]
    require('lualine').setup {
        options = {
            theme = theme,
            section_separators = style.section_separators,
            component_separators = style.component_separators,
            globalstatus = preferences.get_global_statusbar(),
            disabled_filetypes = {
                winbar = nonfile.filetypes,
            },
        },
        sections = {
            lualine_a = {
                '"' .. icons.neovim .. '"',
                'mode',
                -- macro_widget
            },
            lualine_b = { 'branch' },
            lualine_c = { filename_widget, diagnostics_widget },
            lualine_x = {
                -- search_widget,
                'encoding',
            },
            lualine_y = { 'fileformat', 'filetype' },
            lualine_z = { 'progress' },
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { filename_widget, diagnostics_widget },
            lualine_x = { 'filetype' },
            lualine_y = {},
            lualine_z = {},
        },
        winbar = {
            lualine_a = { filename_widget },
            lualine_b = { file_icon_widget },
            lualine_c = { navic_widget(style) },
            lualine_x = { '" "' },
            lualine_y = {},
            lualine_z = {},
        },
        inactive_winbar = {
            lualine_b = { filename_widget },
            lualine_c = { file_icon_widget },
        },
        tabline = {},
        extensions = {
            'aerial',
            'neo-tree',
            'nvim-dap-ui',
            'toggleterm',
            'trouble',
        },
    }
end
