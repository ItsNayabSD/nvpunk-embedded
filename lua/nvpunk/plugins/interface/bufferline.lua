-- better tabline
return {
    'akinsho/bufferline.nvim',
    config = function()
        local nonfile = require 'nvpunk.internals.nonfile'

        require('bufferline').setup {
            options = {
                mode = 'tabs', -- 'buffers' | 'tabs'
                numbers = 'none',
                diagnostics = 'nvim_lsp',
                always_show_bufferline = true,
                -- 'slant' | 'padded_slant' | 'thin' | 'thick'
                separator_style = require('nvpunk.preferences').get_tab_style(),
                custom_filter = function(buf_number, _)
                    return not vim.tbl_contains(
                        nonfile.filetypes,
                        vim.bo[buf_number].filetype
                    ) and not vim.tbl_contains(
                        nonfile.buftypes,
                        vim.bo[buf_number].buftype
                    )
                end,
                close_command = function()
                    if vim.fn.tabpagenr('$') > 1 then
                        vim.cmd('tabclose')
                    end
                end,
                right_mouse_command = function()
                    if vim.fn.tabpagenr('$') > 1 then
                        vim.cmd('tabclose')
                    end
                end,
            },
        }
    end,
}