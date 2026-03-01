--- Run an installer script in a terminal
--- @param cmd string
---@param reinstall? boolean
---@param cb? function
return function(cmd, reinstall, cb)
    local env_reinstall = '0'
    if reinstall then env_reinstall = '1' end

    vim.cmd 'new'
    local buf = vim.api.nvim_get_current_buf()
    local win = vim.api.nvim_get_current_win()
    vim.fn.jobstart(cmd, {
        term = true,
        env = {
            NVPUNK_REINSTALL = env_reinstall,
        },
        on_exit = function(_, ret, _)
            if ret == 0 then
                -- only close buf+win on success
                vim.api.nvim_buf_delete(buf, {})
                vim.api.nvim_win_close(win, false)
            end
            if cb ~= nil then vim.schedule(function() cb(ret == 0) end) end
        end,
    })
    vim.schedule(function() vim.cmd 'norm G' end)
end
