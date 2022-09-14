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
                print(w)
                vim.highlight.create(name, { ctermbg = 0, guifg = w })
                fn.sign_define(name, { text = "■", texthl = name })
                fn.sign_place(lineNumber, group, name, bufnr, { lnum = lineNumber, priority = 10 })
            else
                fn.sign_unplace(group)
            end
        end
    end
end

M.attach_to_buffer = function()
    local bufnr = nvim_get_current_buf() or 0
    local lines = nvim_buf_get_lines(bufnr, 0, -1, true)
    for lineNumber, line in ipairs(lines) do
        M.highlight_line(line, lineNumber, bufnr)
    end
end

M.setup = function()

    function GUTTER_COLOR_SETUP_HOOK()
        M.attach_to_buffer()

        local bufnr = nvim_get_current_buf() or 0
        vim.api.nvim_buf_attach(bufnr, true, {
            on_lines = function()
                local bufnr = nvim_get_current_buf() or 0
                local lines = nvim_buf_get_lines(bufnr, 0, -1, true)
                for lineNumber, line in ipairs(lines) do
                    M.highlight_line(line, lineNumber, bufnr)
                end
            end;
            on_detach = function()
            end;
        })
    end

    vim.api.nvim_command(":augroup GutterColorSetup")
    vim.api.nvim_command(":autocmd FileType * lua GUTTER_COLOR_SETUP_HOOK()")
    vim.api.nvim_command(":augroup END")

end

return {
    setup = M.setup
}
