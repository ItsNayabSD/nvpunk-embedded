local M = {}

local keymap_opts = { noremap = true, silent = true }

---runs a keymap and informs about it being deprecated
---@param cmd function | string
---@param new_kb string
M.deprecated_exec = function(cmd, new_kb)
    return function()
        vim.notify('Deprecated keybind, use this instead: ' .. new_kb, 'warn', {
            title = 'Nvpunk Keybinds',
        })
        if type(cmd) == 'function' then
            cmd()
        else
            vim.cmd(cmd)
        end
    end
end

--- Create keymap
---@param mode 'v' | 'x' | 'i' | 'n' | 't' | 's' | ''
---@param kb string
---@param cmd function | string
---@param desc? string
---@param icon? string
M.keymap = function(mode, kb, cmd, desc, icon)
    if icon ~= nil then
        -- if importing which-key fails, still set the keymap
        if
            not pcall(
                function()
                    require('which-key').add {
                        {
                            kb,
                            cmd,
                            mode = mode,
                            desc = desc,
                            icon = icon,
                            noremap = keymap_opts.noremap,
                            silent = keymap_opts.silent,
                        },
                    }
                end
            )
        then
            M.keymap(mode, kb, cmd, desc)
        end
    else
        local opts = keymap_opts
        if desc ~= nil then opts.desc = desc end
        vim.keymap.set(mode, kb, cmd, opts)
    end
end

--- Create visual mode keymap
---@param kb string
---@param cmd function | string
---@param desc? string
---@param icon? string
M.vkeymap = function(kb, cmd, desc, icon) M.keymap('v', kb, cmd, desc, icon) end

--- Create visual/select mode mode keymap
---@param kb string
---@param cmd function | string
---@param desc? string
---@param icon? string
M.xkeymap = function(kb, cmd, desc, icon) M.keymap('x', kb, cmd, desc, icon) end

--- Create insert mode keymap
---@param kb string
---@param cmd function | string
---@param desc? string
---@param icon? string
M.ikeymap = function(kb, cmd, desc, icon) M.keymap('i', kb, cmd, desc, icon) end

--- Create normal mode keymap
---@param kb string
---@param cmd function | string
---@param desc? string
---@param icon? string
M.nkeymap = function(kb, cmd, desc, icon) M.keymap('n', kb, cmd, desc, icon) end

--- Create terminal mode keymap
---@param kb string
---@param cmd function | string
---@param desc? string
---@param icon? string
M.tkeymap = function(kb, cmd, desc, icon) M.keymap('t', kb, cmd, desc, icon) end

--- Create insert/normal mode keymap
---@param kb string
---@param cmd function | string
---@param desc? string
---@param icon? string
M.inkeymap = function(kb, cmd, desc, icon)
    M.ikeymap(kb, cmd, desc)
    M.nkeymap(kb, cmd, desc)
end

--- Create a table of functions to create keymaps relative to the given buffer
---@param bufnr integer
---@return table[function]
M.create_bufkeymapper = function(bufnr)
    local bm = {}
    local buf_km_opts =
        vim.tbl_deep_extend('force', keymap_opts, { buffer = bufnr })

    --- Create keymap
    ---@param mode 'v' | 'x' | 'i' | 'n' | 't' | ''
    ---@param kb string
    ---@param cmd function | string
    ---@param desc? string
    ---@param icon? string
    bm.keymap = function(mode, kb, cmd, desc, icon)
        if icon ~= nil then
            -- if importing which-key fails, still set the keymap
            if
                not pcall(
                    function()
                        require('which-key').add {
                            {
                                kb,
                                cmd,
                                mode = mode,
                                desc = desc,
                                icon = icon,
                                buffer = bufnr,
                                noremap = buf_km_opts.noremap,
                                silent = buf_km_opts.silent,
                            },
                        }
                    end
                )
            then
                bm.keymap(mode, kb, cmd, desc)
            end
        else
            local opts = buf_km_opts
            if desc ~= nil then opts.desc = desc end
            vim.keymap.set(mode, kb, cmd, opts)
        end
    end

    --- Create visual mode keymap
    ---@param kb string
    ---@param cmd function | string
    ---@param desc? string
    ---@param icon? string
    bm.vkeymap = function(kb, cmd, desc, icon)
        bm.keymap('v', kb, cmd, desc, icon)
    end

    --- Create visual/select mode keymap
    ---@param kb string
    ---@param cmd function | string
    ---@param desc? string
    ---@param icon? string
    bm.xkeymap = function(kb, cmd, desc, icon)
        bm.keymap('x', kb, cmd, desc, icon)
    end

    --- Create insert mode keymap
    ---@param kb string
    ---@param cmd function | string
    ---@param desc? string
    ---@param icon? string
    bm.ikeymap = function(kb, cmd, desc, icon)
        bm.keymap('i', kb, cmd, desc, icon)
    end

    --- Create normal mode keymap
    ---@param kb string
    ---@param cmd function | string
    ---@param desc? string
    ---@param icon? string
    bm.nkeymap = function(kb, cmd, desc, icon)
        bm.keymap('n', kb, cmd, desc, icon)
    end

    --- Create terminal mode keymap
    ---@param kb string
    ---@param cmd function | string
    ---@param desc? string
    ---@param icon? string
    bm.tkeymap = function(kb, cmd, desc, icon)
        bm.keymap('t', kb, cmd, desc, icon)
    end

    --- Create insert/normal mode keymap
    ---@param kb string
    ---@param cmd function | string
    ---@param desc? string
    ---@param icon? string
    bm.inkeymap = function(kb, cmd, desc, icon)
        bm.ikeymap(kb, cmd, desc)
        bm.nkeymap(kb, cmd, desc)
    end
    return bm
end

return M
