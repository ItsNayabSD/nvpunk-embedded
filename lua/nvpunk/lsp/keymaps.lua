local M = {}
local km = require 'nvpunk.internals.keymapper'
local icons = require 'nvpunk.internals.icons'

---Set buffer keymaps for attaching language servers
---@param client vim.lsp.Client
---@param bufnr number
---@param extra_keymaps function
M.set_lsp_keymaps = function(client, bufnr, extra_keymaps)
    local wk = require 'which-key'
    local bm = km.create_bufkeymapper(bufnr)

    -- Set autocommands conditional on server_capabilities
    if client.server_capabilities.documentHighlightProvider then
        local group = 'lsp_document_highlight'
        vim.api.nvim_create_augroup(group, { clear = true })
        vim.api.nvim_create_autocmd('CursorHold', {
            callback = vim.lsp.buf.document_highlight,
            buffer = vim.api.nvim_get_current_buf(),
            group = group,
        })
        vim.api.nvim_create_autocmd('CursorMoved', {
            callback = vim.lsp.buf.clear_references,
            buffer = vim.api.nvim_get_current_buf(),
            group = group,
        })
    end

    vim.api.nvim_set_option_value('omnifunc', 'v:lua.vim.lsp.omnifunc', {
        buf = bufnr,
    })

    -- Mappings

    bm.nkeymap('gD', vim.lsp.buf.declaration, 'Declaration')
    wk.add {
        {
            'gd',
            group = 'Definition',
            mode = 'n',
            buffer = bufnr,
        },
    }
    bm.nkeymap('gdh', function() vim.lsp.buf.definition() end, 'Here')
    bm.nkeymap('gdt', function()
        vim.cmd 'tab split'
        vim.lsp.buf.definition()
    end, 'Tab')
    bm.nkeymap('gdi', function()
        vim.cmd 'split'
        vim.lsp.buf.definition()
    end, 'Hsplit')
    bm.nkeymap('gds', function()
        vim.cmd 'vsplit'
        vim.lsp.buf.definition()
    end, 'Vsplit')
    bm.nkeymap('K', vim.lsp.buf.hover)
    bm.nkeymap('gI', vim.lsp.buf.implementation, 'Implementation')
    bm.inkeymap('<C-k>', vim.lsp.buf.signature_help)
    wk.add {
        {
            '<leader>w',
            group = 'Workspace',
            mode = 'n',
            buffer = bufnr,
        },
    }
    bm.nkeymap('<leader>wa', vim.lsp.buf.add_workspace_folder, 'Add folder')
    bm.nkeymap(
        '<leader>wr',
        vim.lsp.buf.remove_workspace_folder,
        'Remove folder'
    )
    bm.nkeymap(
        '<leader>wl',
        function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
        'List folders'
    )
    -- bm.nkeymap('<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', 'Open definition')
    bm.nkeymap('<leader>rn', vim.lsp.buf.rename, 'Rename', icons.pencil)
    bm.nkeymap('gr', vim.lsp.buf.references, 'References')
    bm.nkeymap(
        '<leader>e',
        vim.diagnostic.open_float,
        'Show diagnostics',
        icons.diag_hint
    )
    bm.nkeymap('[d', vim.diagnostic.goto_prev, 'Prev diagnostic', icons.prev)
    bm.nkeymap(']d', vim.diagnostic.goto_next, 'Next diagnostic', icons.next)
    -- bm.nkeymap('<leader>q', vim.diagnostic.setloclist)
    bm.nkeymap(
        '<leader>ca',
        vim.lsp.buf.code_action,
        'Code actions',
        icons.lightning
    )

    wk.add {
        {
            '<leader>v',
            group = 'Diagnostics Virutal Text',
            mode = 'n',
            buffer = bufnr,
        },
    }
    bm.nkeymap(
        '<leader>vd',
        function() vim.diagnostic.config { virtual_text = false } end,
        'Disable'
    )
    bm.nkeymap(
        '<leader>ve',
        function() vim.diagnostic.config { virtual_text = true } end,
        'Enable'
    )

    local function set_fmt_keymap()
        local function set_km(opts)
            bm.nkeymap(
                '<leader>f',
                function()
                    vim.lsp.buf.format(opts)
                end,
                'Format',
                icons.sparkle
            )
        end

        if vim.bo.filetype == 'typescript' or vim.bo.filetype == 'javascript' then
            for _, folder in ipairs(vim.lsp.buf.list_workspace_folders()) do
                for fname, ftype in vim.fs.dir(folder) do
                    if ftype == 'file' and (fname == 'biome.json' or fname == 'biome.jsonc') then
                        if client.name == 'biome' then
                            set_km({ name = 'biome' })
                        end
                        return
                    end
                end
            end
        end
        set_km()
    end

    -- Set some keybinds conditional on server capabilities
    if client.server_capabilities.documentFormattingProvider or client.name == 'biome' then
        set_fmt_keymap()
    else
        bm.nkeymap('<leader>f', '<cmd>Neoformat<cr>', 'Format', icons.sparkle)
    end
    bm.nkeymap('<leader>F', '<cmd>Neoformat<cr>', 'Neoformat', icons.sparkle)

    if extra_keymaps ~= nil then extra_keymaps(bm) end
end

return M
