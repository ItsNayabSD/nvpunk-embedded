local M = {}

local icons = require 'nvpunk.internals.icons'

--- Checks if current buf has LSPs attached
---@return boolean
M.buf_has_lsp = function()
    return not vim.tbl_isempty(vim.lsp.get_clients {
        bufnr = vim.api.nvim_get_current_buf(),
    })
end

local nonfile = require 'nvpunk.internals.nonfile'

--- Checks if current buf is a file
---@return boolean
M.buf_is_file = function()
    return not vim.tbl_contains(nonfile.filetypes, vim.bo.filetype)
        and not vim.tbl_contains(nonfile.buftypes, vim.bo.buftype)
end

--- Checks if current buf has DAP support
---@return boolean
M.buf_has_dap = function() return M.buf_is_file() end

--- Create a context menu
---@deprecated
---@param prompt string
---@param strings table[string]
---@param funcs table[function]
M.uiselect_context_menu = function(prompt, strings, funcs)
    vim.ui.select(
        strings,
        { prompt = prompt },
        function(_, idx) vim.schedule(funcs[idx]) end
    )
end

--- Clear all entries from the given menu
---@param menu string
M.clear_menu = function(menu)
    pcall(function() vim.cmd.aunmenu(menu) end)
end

--- Formats the label of a menu entry to avoid errors
---@param label string
---@return string
M.format_menu_label = function(label)
    local res = string.gsub(label, ' ', [[\ ]])
    res = string.gsub(res, '<', [[\<]])
    res = string.gsub(res, '>', [[\>]])
    return res
end

--- Create an entry for the right click menu
---@param menu string
---@param label string
---@param action string
M.rclick_context_menu = function(menu, label, action)
    vim.cmd.amenu(menu .. '.' .. M.format_menu_label(label) .. ' ' .. action)
end

--- Set up a right click submenu
---@param menu_name string
---@param submenu_label string
---@param items table[{string, string}]
---@param bindif function?
M.set_rclick_submenu = function(menu_name, submenu_label, items, bindif)
    M.clear_menu(menu_name)
    M.clear_menu('PopUp.' .. M.format_menu_label(submenu_label))
    if bindif ~= nil then
        if not bindif() then return end
    end
    for _, i in ipairs(items) do
        M.rclick_context_menu(menu_name, i[1], i[2])
    end
    M.rclick_context_menu(
        'PopUp',
        submenu_label,
        '<cmd>popup ' .. menu_name .. '<cr>'
    )
end

---pad string with spaces
---@param s string
---@param width number
---@return string
local function pad(s, width)
    local padding = width - #s
    if padding < 1 then -- no max function in lua?
        padding = 1
    end
    return s .. string.rep(' ', padding)
end

M.MENU_ITEM_WIDTH = 32

---create a table representing a menu item
---@param label string
---@param shortcut string
---@return table[string, string]
M.menu_item = function(label, shortcut)
    label = pad(label, M.MENU_ITEM_WIDTH - #shortcut)
    return {
        label .. shortcut,
        shortcut,
    }
end

M.L0_ITEM_WIDTH = 12

M.set_lsp_rclick_menu = function()
    M.set_rclick_submenu(
        'NvpunkLspMenu',
        pad('LSP', M.L0_ITEM_WIDTH) .. icons.double_arrow_right,
        {
            M.menu_item('Code actions', 'gra'),
            M.menu_item('Go to declaration', 'gD'),
            M.menu_item('Go to definition', 'gdt'),
            M.menu_item('Go to implementation', 'gri'),
            M.menu_item('Signature help', '<C-k>'),
            M.menu_item('Rename', 'grn'),
            M.menu_item('References', 'grr'),
            M.menu_item('Expand diagnostics', '<space>e'),
            M.menu_item('Auto format', '<space>f'),
        },
        M.buf_has_lsp
    )
end

M.set_java_rclick_menu = function()
    M.set_rclick_submenu(
        'NvpunkJavaMenu',
        pad('Java', M.L0_ITEM_WIDTH) .. icons.double_arrow_right,
        {
            M.menu_item('Test class', '<space>bjc'),
            M.menu_item('Test nearest method', '<space>bjn'),
            M.menu_item('Refresh debugger', '<space>bjr'),
        },
        function() return vim.bo.filetype == 'java' end
    )
end

M.set_dap_rclick_menu = function()
    M.set_rclick_submenu(
        'NvpunkDapMenu',
        pad('Debug', M.L0_ITEM_WIDTH) .. icons.double_arrow_right,
        {
            M.menu_item('Show DAP UI', '<space>bu'),
            M.menu_item('Toggle breakpoint', '<space>bb'),
            M.menu_item('Continue', '<space>bc'),
            M.menu_item('Terminate', '<space>bk'),
        },
        M.buf_has_dap
    )
end

M.set_neotree_rclick_menu = function()
    M.set_rclick_submenu(
        'NvpunkNeoTreeMenu',
        pad('File', M.L0_ITEM_WIDTH) .. icons.double_arrow_right,
        {
            M.menu_item('New file', '<space>fn'),
            M.menu_item('New folder', '<space>dn'),
            M.menu_item('Rename', '<F2>'),
            M.menu_item('Toggle hidden', '<C-h>'),
            M.menu_item('Split vertically', 'i'),
            M.menu_item('Split horizontally', 's'),
            M.menu_item('Open in new tab', 't'),
            M.menu_item('Open with system app', '<space>xo'),
            M.menu_item('Git add', '<space>ga'),
            M.menu_item('Git unstage', '<space>gu'),
        },
        function() return vim.bo.filetype == 'neo-tree' end
    )
end

M.set_telescope_rclick_menu = function()
    M.set_rclick_submenu(
        'NvpunkTelescopeMenu',
        pad('Telescope', M.L0_ITEM_WIDTH) .. icons.double_arrow_right,
        {
            M.menu_item('Find file', '<space>tf'),
            M.menu_item('Live grep', '<space>tg'),
            M.menu_item('Recent files', '<space>th'),
        }
    )
end

M.set_git_rclick_menu = function()
    M.set_rclick_submenu(
        'NvpunkGitMenu',
        pad('Git', M.L0_ITEM_WIDTH) .. icons.double_arrow_right,
        {
            M.menu_item('Preview changes', '<space>g?'),
            M.menu_item('Prev hunk', '<space>g['),
            M.menu_item('Next hunk', '<space>g]'),
            M.menu_item('Blame line', '<space>gb'),
        },
        M.buf_is_file
    )
end

M.set_view_rclick_menu = function()
    M.set_rclick_submenu(
        'NvpunkViewMenu',
        pad('View', M.L0_ITEM_WIDTH) .. icons.double_arrow_right,
        {
            M.menu_item('Code outline', 'go'),
            M.menu_item('Split term vertical', '<space>/i'),
            M.menu_item('Split term horizontal', '<space>/s'),
            M.menu_item('Floating term', '<C-\\>'),
        }
    )
end

M.setup_rclick_menu_autocommands = function()
    vim.api.nvim_create_autocmd({ 'BufEnter', 'LspAttach' }, {
        callback = function()
            M.clear_menu '*'
            M.set_lsp_rclick_menu()
            M.set_dap_rclick_menu()
            M.set_java_rclick_menu()
            M.set_neotree_rclick_menu()
            M.set_telescope_rclick_menu()
            M.set_git_rclick_menu()
            M.set_view_rclick_menu()
        end,
    })
end

M.set_keymap = function()
    require('nvpunk.internals.keymapper').nkeymap(
        '<A-m>',
        '<cmd>popup PopUp<cr>',
        'Open Context Menu'
    )
end

M.setup = function()
    for _, autocmd in
        ipairs(vim.api.nvim_get_autocmds {
            event = 'MenuPopup',
        })
    do
        vim.api.nvim_del_autocmd(autocmd.id)
    end
    M.setup_rclick_menu_autocommands()
    M.set_keymap()
end

return M
