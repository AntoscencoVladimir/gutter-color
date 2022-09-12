local fn = vim.fn
local nvim_buf_get_lines = vim.api.nvim_buf_get_lines
local nvim_get_current_buf = vim.api.nvim_get_current_buf

local M = {}

M.highlight_line = function(line, lineNumber, bufnr)
    if line then
        local color = nil
        local foundcolor = string.match(line, "^#?%x%x%x%x%x%x$")
        if foundcolor then
            color = foundcolor
        end

        if color then
            local groupName = 'gutterColor' .. lineNumber
            vim.highlight.create(groupName, { ctermbg = 0, guifg = color })
            fn.sign_define(groupName, { text = "■", texthl = groupName })
            fn.sign_place(lineNumber, 'gutterColorGroup', groupName, bufnr, { lnum = lineNumber, priority = 10 })
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
    setup = M.setup()
}
