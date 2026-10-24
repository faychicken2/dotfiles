-- Also find our Lua modules when testing with: nvim -u rc/nvim/init.lua
local config_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h")
vim.opt.runtimepath:prepend(config_dir)

require("config")

-- Keep local settings outside the managed nvim directory.
local local_config = vim.fn.expand("~/.config/nvim.local.lua")
if vim.fn.filereadable(local_config) == 1 then
    dofile(local_config)
end
