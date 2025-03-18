local M = {}

local icons = require 'nvpunk.internals.icons'

local PREFERENCES_FILE = vim.fn.expand(
    vim.fn.stdpath 'config' .. '/org.gabmus.nvpunk.preferences.json'
)

local DEFAULT_PREFERENCES = {
    theme = 'onedark_warmer',
    greeter = 'embedded',
    indent_blankline_enabled = true,
    tab_style = 'slant', -- 'slant' | 'padded_slant' | 'thin' | 'thick'
    navic_enabled = true,
    statusline_style = 'plain', -- 'powerline' | 'plain' | 'plain_separators'
    -- | 'slant_low' | 'slant_high' | 'round'
    -- | 'pixel'
    window_border = 'solid', -- 'solid' | 'none' | 'single' | 'rounded' | 'double'
    small_window_border = 'rounded', -- 'solid' | 'none' | 'single' | 'rounded' | 'double'
    popup_border = 'none', -- 'solid' | 'none' | 'single' | 'rounded' | 'double'
    column_mark_enabled = true,
    folding_guide_enabled = true,
    relative_numbers = true,
    global_statusbar = true,
    filetree_position = 'left',
}

--- Make sure that conf has all keys
---@param conf table
---@return table
local function replace_missing_confs(conf)
    for k, v in pairs(DEFAULT_PREFERENCES) do
        if vim.fn.has_key(conf, k) == 0 then conf[k] = v end
    end
    return conf
end

-- conf cache, avoids reading every time
local __conf = nil

--- Save conf to PREFERENCES_FILE
---@param conf table
local function save_conf(conf)
    vim.fn.writefile({ vim.json.encode(conf) }, PREFERENCES_FILE)
    __conf = nil
end

local function load_conf()
    if __conf ~= nil then return __conf end
    if vim.fn.filereadable(PREFERENCES_FILE) == 1 then
        __conf = vim.json.decode(
            table.concat(vim.fn.readfile(PREFERENCES_FILE), '\n')
        )
        return replace_missing_confs(__conf)
    end
    return DEFAULT_PREFERENCES
end

--- Save theme to PREFERENCES_FILE
---@param theme string
M.set_theme = function(theme)
    local conf = load_conf()
    conf.theme = theme
    save_conf(conf)
end

M.get_theme = function() return load_conf().theme end

M.set_greeter = function(greeter)
    local conf = load_conf()
    conf.greeter = greeter
    save_conf(conf)
end

M.get_greeter = function() return load_conf().greeter end

---@return boolean
M.get_indent_blankline_enabled = function()
    return load_conf().indent_blankline_enabled
end

---@param nval boolean
M.set_indent_blankline_enabled = function(nval)
    local conf = load_conf()
    conf.indent_blankline_enabled = nval
    save_conf(conf)
end

---@return boolean
M.get_navic_enabled = function() return load_conf().navic_enabled end

---@param nval boolean
M.set_navic_enabled = function(nval)
    local conf = load_conf()
    conf.navic_enabled = nval
    save_conf(conf)
    -- require('nvpunk.plugins.interface.navic').config()
end

---@return boolean
M.get_column_mark_enabled = function() return load_conf().column_mark_enabled end

---@param nval boolean
M.set_column_mark_enabled = function(nval)
    local conf = load_conf()
    conf.column_mark_enabled = nval
    save_conf(conf)
    vim.opt.colorcolumn = nval and { 80 } or {}
end

---@return boolean
M.get_folding_guide_enabled = function()
    return load_conf().folding_guide_enabled
end

---@param nval boolean
M.set_folding_guide_enabled = function(nval)
    local conf = load_conf()
    conf.folding_guide_enabled = nval
    save_conf(conf)
    vim.o.foldcolumn = nval and '1' or '0'
end

---@return boolean
M.get_relative_numbers_enabled = function() return load_conf().relative_numbers end

---@param nval boolean
M.set_relative_numbers_enabled = function(nval)
    local conf = load_conf()
    conf.relative_numbers = nval
    save_conf(conf)
    reload 'nvpunk.internals.numbertoggle_conf'
end

---@return 'slant' | 'padded_slant' | 'thin' | 'thick'
M.get_tab_style = function() return load_conf().tab_style end

---Set tab style
---@param style 'slant' | 'padded_slant' | 'thin' | 'thick'
M.set_tab_style = function(style)
    local conf = load_conf()
    conf.tab_style = style
    save_conf(conf)
    require('nvpunk.plugins.interface.bufferline').config()
end

---@return 'powerline' | 'plain' | 'plain_separators' | 'slant_low' |
---        'slant_high' | 'round' | 'pixel'
M.get_statusline_style = function() return load_conf().statusline_style end

---@param style 'powerline' | 'plain' | 'plain_separators' | 'slant_low' |
---             'slant_high' | 'round' | 'pixel'
M.set_statusline_style = function(style)
    local conf = load_conf()
    conf.statusline_style = style
    save_conf(conf)
    reload('nvpunk.theme_manager.themes.' .. M.get_theme())
end

---@param border 'solid' | 'none' | 'single' | 'rounded' | 'double'
---@return table | 'none' | 'single' | 'rounded' | 'double'
local function get_border_value(border)
    if border == 'solid' then -- make the border color the same as the window
        return {
            { ' ', 'NormalFloat' },
            { ' ', 'NormalFloat' },
            { ' ', 'NormalFloat' },
            { ' ', 'NormalFloat' },
            { ' ', 'NormalFloat' },
            { ' ', 'NormalFloat' },
            { ' ', 'NormalFloat' },
            { ' ', 'NormalFloat' },
        }
    end
    return border --[[@as table | 'none' | 'single' | 'rounded' | 'double']]
end

---@return table | 'none' | 'single' | 'rounded' | 'double'
M.get_window_border = function()
    return get_border_value(load_conf().window_border)
end

---@param border 'solid' | 'none' | 'single' | 'rounded' | 'double'
M.set_window_border = function(border)
    local conf = load_conf()
    conf.window_border = border
    save_conf(conf)
end

---@return table | 'none' | 'single' | 'rounded' | 'double'
M.get_small_window_border = function()
    return get_border_value(load_conf().small_window_border)
end

---@param border 'solid' | 'none' | 'single' | 'rounded' | 'double'
M.set_small_window_border = function(border)
    local conf = load_conf()
    conf.small_window_border = border
    save_conf(conf)
end

---@return table | 'none' | 'single' | 'rounded' | 'double'
M.get_popup_border = function()
    return get_border_value(load_conf().popup_border)
end

---@param border 'solid' | 'none' | 'single' | 'rounded' | 'double'
M.set_popup_border = function(border)
    local conf = load_conf()
    conf.popup_border = border
    save_conf(conf)
end

---@return boolean
M.get_global_statusbar = function() return load_conf().global_statusbar end

---@param val boolean
M.set_global_statusbar = function(val)
    local conf = load_conf()
    conf.global_statusbar = val
    save_conf(conf)
end

---@param val 'left' | 'right'
M.set_filetree_position = function(val)
    local conf = load_conf()
    conf.filetree_position = val
    save_conf(conf)
end

---@return 'left' | 'right'
M.get_filetree_position = function() return load_conf().filetree_position end

local BORDER_SELECT_OPTS = {
    { label = 'Padded', value = 'solid' },
    { label = 'None', value = 'none' },
    { label = 'Single Stroke', value = 'single' },
    { label = 'Double Stroke', value = 'double' },
    { label = 'Rounded', value = 'rounded' },
}

local select_format_get_label =
    require('nvpunk.internals.menu').format_get_label
-- local function select_format_get_label(item) return item.label end

local menu = require('nvpunk.internals.menu').menu

local preferences_menus = {
    {
        label = icons.theme .. '  Change Theme',
        func = function()
            require 'nvpunk.theme_manager.telescope_theme_chooser'()
        end,
    },
    {
        label = icons.greet .. '  Change Greeter Header',
        func = function()
            menu(require('nvpunk.internals.greeter_headers').headers, {
                prompt = 'Choose a header:',
            }, function(greeter, _)
                M.set_greeter(greeter)
                require('nvpunk.plugins.interface.alpha').config()
                vim.cmd 'AlphaRedraw'
            end)
        end,
    },
    {
        label = icons.tools .. '  Interface Preferences',
        func = function()
            local blankline_enabled = M.get_indent_blankline_enabled()
            local navic_enabled = M.get_navic_enabled()
            local column_mark_enabled = M.get_column_mark_enabled()
            local folding_guide_enabled = M.get_folding_guide_enabled()
            local relative_numbers_enabled = M.get_relative_numbers_enabled()
            local global_statusbar = M.get_global_statusbar()
            local filetree_position = M.get_filetree_position()
            menu({
                {
                    label = icons.indent
                        .. '  '
                        .. (blankline_enabled and 'Disable' or 'Enable')
                        .. ' Indent Guide',
                    func = function()
                        if blankline_enabled then
                            vim.g.snacks_indent = false
                            M.set_indent_blankline_enabled(false)
                        else
                            vim.g.snacks_indent = true
                            M.set_indent_blankline_enabled(true)
                        end
                    end,
                },
                {
                    label = icons.gps
                        .. '  '
                        .. (navic_enabled and 'Disable' or 'Enable')
                        .. ' Navic (breadcrumbs)',
                    func = function() M.set_navic_enabled(not navic_enabled) end,
                },
                {
                    label = icons.ui_column_mark
                        .. '  '
                        .. (column_mark_enabled and 'Disable' or 'Enable')
                        .. ' Column Mark',
                    func = function()
                        M.set_column_mark_enabled(not column_mark_enabled)
                    end,
                },
                {
                    label = icons.ui_numbered_list
                        .. '  '
                        .. (relative_numbers_enabled and 'Disable' or 'Enable')
                        .. ' Relative Numbers',
                    func = function()
                        M.set_relative_numbers_enabled(
                            not relative_numbers_enabled
                        )
                    end,
                },
                {
                    label = icons.ui_folding
                        .. '  '
                        .. (folding_guide_enabled and 'Disable' or 'Enable')
                        .. ' Folding Guide',
                    func = function()
                        M.set_folding_guide_enabled(not folding_guide_enabled)
                    end,
                },
                {
                    label = icons.ui_tab .. ' Tab Style',
                    func = function()
                        menu({
                            { label = 'Slant', value = 'slant' },
                            { label = 'Padded Slant', value = 'padded_slant' },
                            { label = 'Thin', value = 'thin' },
                            { label = 'Thick', value = 'thick' },
                        }, {
                            prompt = 'Tab Style:',
                            format_item = select_format_get_label,
                        }, function(item, _)
                            M.set_tab_style(item.value)
                        end)
                    end,
                },
                {
                    label = icons.shell .. '  Statusline Style',
                    func = function()
                        menu(
                            {
                                { label = 'Powerline', value = 'powerline' },
                                { label = 'Plain', value = 'plain' },
                                {
                                    label = 'Plain with Separators',
                                    value = 'plain_separators',
                                },
                                { label = 'Slant Low', value = 'slant_low' },
                                { label = 'Slant High', value = 'slant_high' },
                                { label = 'Round', value = 'round' },
                                { label = 'Pixel', value = 'pixel' },
                            },
                            {
                                prompt = 'Statusline Style:',
                                format_item = select_format_get_label,
                            },
                            function(item, _) M.set_statusline_style(item.value) end
                        )
                    end,
                },
                {
                    label = icons.globe
                        .. '  '
                        .. (global_statusbar and 'Disable' or 'Enable')
                        .. ' Global Statusbar',
                    func = function()
                        M.set_global_statusbar(not global_statusbar)
                        reload('nvpunk.theme_manager.themes.' .. M.get_theme())
                    end,
                },
                {
                    label = icons.ui_win_border .. '  Window Borders',
                    func = function()
                        menu(
                            BORDER_SELECT_OPTS,
                            {
                                prompt = 'Window Borders:',
                                format_item = select_format_get_label,
                            },
                            function(item, _) M.set_window_border(item.value) end
                        )
                    end,
                },
                {
                    label = icons.ui_multi_win .. '  Floating Window Borders',
                    func = function()
                        menu(
                            BORDER_SELECT_OPTS,
                            {
                                prompt = 'Floating Window Borders:',
                                format_item = select_format_get_label,
                            },
                            function(item, _)
                                M.set_small_window_border(item.value)
                            end
                        )
                    end,
                },
                {
                    label = icons.ui_unordered_list .. '  Popup Borders',
                    func = function()
                        menu(BORDER_SELECT_OPTS, {
                            prompt = 'Popup Borders:',
                            format_item = select_format_get_label,
                        }, function(item, _)
                            M.set_popup_border(item.value)
                        end)
                    end,
                },
                {
                    label = icons.filetree
                        .. '  Move filetree to the '
                        .. (filetree_position == 'left' and 'right' or 'left'),
                    func = function()
                        M.set_filetree_position(
                            M.get_filetree_position() == 'left' and 'right'
                                or 'left'
                        )
                        vim.notify 'Filetree position changed, restart Nvpunk to apply these changes'
                    end,
                },
            }, {
                prompt = 'Interface Preferences:',
                format_item = select_format_get_label,
            }, function(item, _) item.func() end)
        end,
    },
    {
        label = icons.cog .. '  Open Config',
        func = function()
            vim.cmd('cd ' .. vim.fn.stdpath 'config')
            vim.cmd 'NvpunkExplorerOpen'
        end,
    },
}

M.preferences_menu = function()
    menu(preferences_menus, {
        prompt = 'Preferences:',
        format_item = select_format_get_label,
    }, function(item, _) item.func() end)
end

vim.api.nvim_create_user_command(
    'NvpunkPreferences',
    function(_) M.preferences_menu() end,
    { nargs = 0 }
)

M.setup = function()
    -- initialize post-startup
    vim.g.snacks_indent = M.get_indent_blankline_enabled()
end

return M
