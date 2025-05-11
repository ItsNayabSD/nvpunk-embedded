local M = {}

M.is_x86_64 = function() return vim.uv.os_uname().machine == 'x86_64' end

return M
