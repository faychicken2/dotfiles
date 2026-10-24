-- Editor options: line numbers, indentation, search, and scrolling.
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true
vim.opt.mouse = ""
vim.opt.scrolloff = 8

local undo_directory = vim.fn.stdpath("data") .. "/undo"

vim.fn.mkdir(undo_directory, "p")
vim.opt.undofile = true
vim.opt.undodir = undo_directory

vim.api.nvim_create_autocmd("FileType", {
    pattern = "netrw",
        callback = function()
          vim.opt_local.number = true
          vim.opt_local.relativenumber = true
    end,
}) 
