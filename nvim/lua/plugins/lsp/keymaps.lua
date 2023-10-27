local M = {}

function M.on_attach(client, buffer)
    local self = M.new(client, buffer)

    self:map("<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
    self:map("<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action", mode = { "n", "v" }, has = "codeAction" })
    self:map("<C-.>", vim.lsp.buf.code_action, { desc = "Code Action", mode = { "n", "v" }, has = "codeAction" })

    -- self:map("<leader>cl", "LspInfo", { desc = "Lsp Info" })
    self:map("<leader>xd", "Telescope diagnostics", { desc = "Telescope Diagnostics" })
    self:map("gd", "Telescope lsp_definitions", { desc = "[G]oto [D]efinition" })
    self:map("gr", "Telescope lsp_references", { desc = "[G]oto [R]eferences" })
    self:map("gD", "Telescope lsp_declarations", { desc = "[G]oto [D]eclaration" })
    self:map("gI", "Telescope lsp_implementations", { desc = "[G]oto [I]mplementation" })
    self:map("gt", "Telescope lsp_type_definitions", { desc = "[G]oto [T]ype Definition" })
    self:map("K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
    self:map("gK", vim.lsp.buf.signature_help, { desc = "Signature Help", has = "signatureHelp" })
    self:map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    self:map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
    self:map("<leader>dn", M.diagnostic_goto(true), { desc = "[D]iagnostic [N]ext" })
    -- self:map("]d", M.diagnostic_goto(false), { desc = "Prev Diagnostic" })
    -- self:map("]e", M.diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
    -- self:map("[e", M.diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
    -- self:map("]w", M.diagnostic_goto(true, "WARNING"), { desc = "Next Warning" })
    -- self:map("[w", M.diagnostic_goto(false, "WARNING"), { desc = "Prev Warning" })

    local format = require("plugins.lsp.format").format
    self:map("<leader>f", format, { desc = "Format Document", has = "documentFormatting" })
    self:map("<leader>rn", vim.lsp.buf.rename, { expr = true, desc = "Rename", has = "rename" })
    self:map("<F2>", vim.lsp.buf.rename, { expr = true, desc = "Rename", has = "rename" })
    -- self:map("<leader>cf", format, { desc = "Format Range", mode = "v", has = "documentRangeFormatting" })
end

function M.new(client, buffer)
    return setmetatable({ client = client, buffer = buffer }, { __index = M })
end

function M:has(cap)
    return self.client.server_capabilities[cap .. "Provider"]
end

function M:map(lhs, rhs, opts)
    opts = opts or {}
    if opts.has and not self:has(opts.has) then
        return
    end
    vim.keymap.set(
        opts.mode or "n",
        lhs,
        type(rhs) == "string" and ("<cmd>%s<cr>"):format(rhs) or rhs,
        ---@diagnostic disable-next-line: no-unknown
        -- { silent = true, buffer = self.buffer, expr = opts.expr, desc = opts.desc }
        { silent = true, buffer = self.buffer, desc = opts.desc }
    )
end

-- function M.rename()
--   if pcall(require, "inc_rename") then
--     return ":IncRename " .. vim.fn.expand("<cword>")
--   else
--     vim.lsp.buf.rename()
--   end
-- end

function M.diagnostic_goto(next, severity)
    local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function()
        go({ severity = severity })
    end
end

return M
