local Job = require 'plenary.job'

local hls = require 'nvpunk.internals.highlights'

local icons = require 'nvpunk.internals.icons'

--- Test if a system command is callable
---@param cmd string
---@param on_success function
---@param on_fail function
local function test_command(cmd, on_success, on_fail)
    Job:new({
        command = 'which',
        args = { cmd },
        on_exit = function(_, ret)
            if ret == 0 then
                vim.schedule(on_success)
            else
                vim.schedule(on_fail)
            end
        end,
    }):start()
end

---test command and set nui text
---@param cmd string | function
---@param message string
---@param text NuiText
---@param redraw function
---@return nil
local function test_and_set_text(cmd, message, text, redraw)
    text:set('    ' .. icons.ellipsis .. '  ' .. message)

    local function good()
        text:set('    ' .. icons.tick .. '  ' .. message, hls.HC_GOOD)
        redraw()
    end

    local function bad()
        text:set('    ' .. icons.x .. '  ' .. message, hls.HC_BAD)
        redraw()
    end

    if type(cmd) == 'string' then
        test_command(cmd, good, bad)
    elseif type(cmd) == 'function' then
        cmd(good, bad)
    end
end

---draws lines in window
---@param win NuiPopup
---@param lines NuiLine[]
---@return nil
local function draw_lines(win, lines)
    for i, line in ipairs(lines) do
        line:render(win.bufnr, win.ns_id, i)
    end
end

return function()
    local NuiPopup = require 'nui.popup'
    local NuiText = require 'nui.text'
    local NuiLine = require 'nui.line'
    local event = require('nui.utils.autocmd').event

    local win = NuiPopup {
        enter = true,
        focusable = true,
        border = {
            style = require('nvpunk.preferences').get_window_border(),
        },
        position = '50%',
        size = {
            width = '80%',
            height = '60%',
        },
    }

    win:mount()

    local heading = {
        NuiLine(),
        NuiLine { NuiText(string.rep(' ', 35), hls.HC_HEADER) },
        NuiLine { NuiText('            Nvpunk Health Check    ', hls.HC_HEADER) },
        NuiLine { NuiText(string.rep(' ', 35), hls.HC_HEADER) },
        NuiLine(),
        NuiLine { NuiText('    q, <esc>  -  Quit', 'Comment') },
        NuiLine { NuiText('    <cr>      -  Open help page', 'Comment') },
        NuiLine(),
    }

    local sections = {
        {
            test = 'git',
            text_obj = NuiText '',
            icon = icons.git,
            label = '[git] Git Version Control',
            help = 'nvpunk-deps-git',
        },
        {
            test = 'npm',
            icon = icons.npm,
            text_obj = NuiText '',
            label = '[npm] Node Package Manager',
            help = 'nvpunk-deps-npm',
        },
        {
            test = 'gcc',
            text_obj = NuiText '',
            icon = icons.c_language,
            label = '[gcc] GNU Compiler Collection',
            help = 'nvpunk-deps-gcc',
        },
        {
            test = 'g++',
            icon = icons.cpp_language,
            text_obj = NuiText '',
            label = '[gcc] GNU Compiler Collection (C++)',
            help = 'nvpunk-deps-g++',
        },
        {
            test = 'python3',
            icon = icons.python,
            text_obj = NuiText '',
            label = '[python] Python',
            help = 'nvpunk-deps-python',
        },
        {
            test = 'rg',
            icon = icons.search,
            text_obj = NuiText '',
            label = '[rg] Ripgrep Search Tool',
            help = 'nvpunk-deps-rg',
        },
        {
            test = 'lldb',
            icon = icons.bug,
            text_obj = NuiText '',
            label = '[lldb] LLVM debugger',
            help = 'nvpunk-deps-lldb',
        },
        {
            test = function(good, bad)
                require('nvpunk.internals.find_jdtls_java')(function(data)
                    if data == nil then return bad() end
                    return good()
                end, false)
            end,
            icon = icons.java,
            text_obj = NuiText '',
            label = '[java17] Java 17+',
            help = 'nvpunk-deps-java17',
        },
    }

    local function get_section_line()
        local line = vim.api.nvim__buf_stats(vim.api.nvim_get_current_buf()).current_lnum
            - #heading
        if line < 1 or line > #sections then return nil end
        return line
    end

    win:on(event.BufLeave, function() win:unmount() end)

    win:map('n', '<cr>', function()
        local line = get_section_line()
        if line == nil then return end
        vim.cmd('h ' .. sections[line].help)
    end, {})

    win:map('n', { 'q', '<esc>' }, function() win:unmount() end, {})

    local lines = {}
    vim.list_extend(lines, heading)
    for _, section in ipairs(sections) do
        table.insert(lines, NuiLine { section.text_obj })
    end

    local function redraw() draw_lines(win, lines) end

    redraw()

    for _, section in ipairs(sections) do
        test_and_set_text(
            section.test,
            section.icon .. ' ' .. section.label,
            section.text_obj,
            redraw
        )
    end
end
