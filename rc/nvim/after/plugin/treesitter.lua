-- Plugin-specific setup for Tree-sitter.
require("nvim-treesitter").setup({
    install_dir = vim.fn.stdpath("data") .. "/site",
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "lua", "bash", "markdown" },
    callback = function(args)
        pcall(vim.treesitter.start, args.buf)
    end,
})
