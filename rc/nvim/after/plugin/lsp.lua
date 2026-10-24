-- Language-server setup and installation prompts.
require("mason").setup()

vim.lsp.config("*", {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
        },
    },
})

local servers = require("mason-lspconfig")
local registry = require("mason-registry")
local prompted = {}

servers.setup({
    automatic_enable = true,
})

local function check_server()
    local buffer = vim.api.nvim_get_current_buf()
    local filetype = vim.bo[buffer].filetype

    if vim.bo[buffer].buftype ~= "" then
        return
    end

    if filetype == "" or prompted[filetype] then
        return
    end

    if #vim.lsp.get_clients({ bufnr = buffer }) > 0 then
        return
    end

    local available = servers.get_available_servers({
        filetype = filetype,
    })
    local installed = servers.get_installed_servers()

    for _, server in ipairs(available) do
        if vim.tbl_contains(installed, server) then
            return
        end
    end

    if #available == 0 then
        return
    end

    prompted[filetype] = true
    table.sort(available)

    vim.ui.select(available, {
        prompt = "Install a language server for " .. filetype .. "?",
    }, function(choice)
        if choice then
            vim.cmd("LspInstall " .. choice)
        end
    end)
end

registry.refresh(vim.schedule_wrap(function(success)
    if not success then
        vim.notify("Could not refresh Mason's package list.")
        return
    end

    local group = vim.api.nvim_create_augroup("LspInstallPrompt", {
        clear = true,
    })

    vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
        group = group,
        callback = function()
            vim.schedule(check_server)
        end,
    })

    check_server()
end))
