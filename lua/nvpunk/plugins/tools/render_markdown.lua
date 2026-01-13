return {
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {
        heading = {
            enabled = true,
            -- Use circled numbers for clear, visible heading indicators
            icons = { '① ', '② ', '③ ', '④ ', '⑤ ', '⑥ ' },
            position = 'overlay',
            sign = true,
            signs = { '█ ' },
            width = 'full',
            left_margin = 0,
            left_pad = 0,
            right_pad = 0,
            min_width = 0,
            border = false,
            border_virtual = false,
            border_prefix = false,
            above = '▄',
            below = '▀',
            backgrounds = { 'DiffAdd', 'DiffChange', 'DiffDelete' },
            foregrounds = { '@markup.heading.1.markdown', '@markup.heading.2.markdown', '@markup.heading.3.markdown', '@markup.heading.4.markdown', '@markup.heading.5.markdown', '@markup.heading.6.markdown' },
        },
    },
    ft = { 'markdown', 'norg' },
}
