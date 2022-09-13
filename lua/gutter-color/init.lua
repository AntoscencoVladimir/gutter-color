
local fn = vim.fn
local nvim_buf_get_lines = vim.api.nvim_buf_get_lines
local nvim_get_current_buf = vim.api.nvim_get_current_buf
local gmatch = string.gfind or string.gmatch

local M = {}

M.highlight_line = function(line, lineNumber, bufnr)
    if line then
        local name = 'gutterColor' .. lineNumber
        local group = 'gutterColorGroup' .. lineNumber
        fn.sign_unplace(group)
        for w in gmatch(line, "#?%x%x%x%x%x%x") do
            if w then
                vim.highlight.create(name, { ctermbg = 0, guifg = w })
                fn.sign_define(name, { text = "■", texthl = name })
                fn.sign_place(lineNumber, group, name, bufnr, { lnum = lineNumber, priority = 10 })
            else
                fn.sign_unplace(group)
            end
        end
    end
end

M.setup = function()
    local bufnr = vim.api.nvim_get_current_buf() or 0
    local lines = nvim_buf_get_lines(bufnr, 0, -1, true)
    for lineNumber, line in ipairs(lines) do
        M.highlight_line(line, lineNumber, bufnr)
    end

    vim.api.nvim_buf_attach(bufnr, false, {
        on_lines = function()
            local bufnr = vim.api.nvim_get_current_buf() or 0
            local lines = nvim_buf_get_lines(bufnr, 0, -1, true)
            for lineNumber, line in ipairs(lines) do
                M.highlight_line(line, lineNumber, bufnr)
            end
        end;
        on_detach = function()
        end;
    })
end

return {
    setup = M.setup
}
