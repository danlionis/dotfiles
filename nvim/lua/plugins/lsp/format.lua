local Util = require("lazy.core.util")

local M = {}
M.autoformat = true

function M.toggle()
    M.autoformat = not M.autoformat
    if M.autoformat then
        Util.info("Enabled format on save")
    else
        Util.info("Disabled format on save")
    end
end

function M.format()
    local buf = vim.api.nvim_get_current_buf()

    vim.lsp.buf.format({
        bufnr = buf,
        async = true,
        filter = function(client)
            -- disable formatting, lsp setting does not seem to work
            if client.name == "html" then
                return false
            end
            return true
        end,
    })
end

function M.on_attach(client, buf)
    if client.supports_method("textDocument/formatting") then
        vim.keymap.set("n", "<leader>tf", M.toggle);
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("LspFormat." .. buf, {}),
            buffer = buf,
            callback = function()
                if M.autoformat then
                    M.format()
                end
            end,
        })
    end
end

return M
