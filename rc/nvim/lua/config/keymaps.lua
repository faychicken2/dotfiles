-- Leader key and custom keyboard mappings.

vim.g.mapleader = " "

-- Make Ctrl+c leave Insert mode like Esc.
vim.keymap.set("i", "<C-c>", "<Esc>", {
    desc = "Exit Insert mode",
})

-- Space, p, m: toggle rendered Markdown.
vim.keymap.set("n", "<leader>pm", "<cmd>RenderMarkdown toggle<CR>", {
    desc = "Toggle Markdown rendering",
})

-- Space, p, v: open the directory explorer.
vim.keymap.set("n", "<leader>pv", "<cmd>Explore<CR>", {
    desc = "Open the directory explorer",
})

-- Space, p, w: save, then open the directory explorer.
vim.keymap.set("n", "<leader>pw", function()
    vim.cmd.write()
    vim.cmd.Explore()
end, {
    desc = "Save and open the directory explorer",
})

-- Telescope fuzzy finders.
local telescope = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", telescope.find_files, {
    desc = "Find files",
})
vim.keymap.set("n", "<leader>fg", telescope.live_grep, {
    desc = "Search text in files",
})
vim.keymap.set("n", "<leader>fb", telescope.buffers, {
    desc = "Find open buffers",
})
vim.keymap.set("n", "<leader>fh", telescope.help_tags, {
    desc = "Search Neovim help",
})

-- Space, u: open or close the undo history tree.
vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<CR>", {
    desc = "Toggle UndoTree",
})

-- Harpoon: quickly revisit a small list of important files.
local harpoon = require("harpoon")

-- Space, h, a: add the current file to Harpoon.
vim.keymap.set("n", "<leader>ha", function()
    harpoon:list():add()
end, {
    desc = "Add file to Harpoon",
})

-- Space, h, m: open the Harpoon file list.
vim.keymap.set("n", "<leader>hm", function()
    harpoon.ui:toggle_quick_menu(harpoon:list())
end, {
    desc = "Open Harpoon menu",
})

-- Space, h, 1-4: jump to a Harpoon file.
for index = 1, 4 do
    vim.keymap.set("n", "<leader>h" .. index, function()
        harpoon:list():select(index)
    end, {
        desc = "Select Harpoon file " .. index,
    })
end

-- Cloak: hide or show secret-looking values in supported files.
vim.keymap.set("n", "<leader>ct", "<cmd>CloakToggle<CR>", {
    desc = "Toggle secret value masking",
})

-- Colorizer: show or hide inline color previews.
vim.keymap.set("n", "<leader>cc", "<cmd>ColorizerToggle<CR>", {
    desc = "Toggle color previews",
})

-- Fugitive: common Git views inside Neovim.
vim.keymap.set("n", "<leader>gs", "<cmd>Git<CR>", {
    desc = "Open Git status",
})
vim.keymap.set("n", "<leader>gd", "<cmd>Gdiffsplit<CR>", {
    desc = "Show Git diff",
})
vim.keymap.set("n", "<leader>gb", "<cmd>Git blame<CR>", {
    desc = "Show Git blame",
})

-- Trouble: open diagnostic and quickfix lists.
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", {
    desc = "Toggle diagnostics list",
})
vim.keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<CR>", {
    desc = "Toggle quickfix list",
})

-- Refactoring: extract code from Visual mode or inline a variable.
vim.keymap.set("x", "<leader>re", ":Refactor extract<CR>", {
    desc = "Extract selected code",
})
vim.keymap.set("x", "<leader>rf", ":Refactor extract_to_file<CR>", {
    desc = "Extract selection to file",
})
vim.keymap.set("x", "<leader>rv", ":Refactor extract_var<CR>", {
    desc = "Extract selection to variable",
})
vim.keymap.set("n", "<leader>ri", ":Refactor inline_var<CR>", {
    desc = "Inline variable",
})

-- Zen Mode: focus on the current buffer.
vim.keymap.set("n", "<leader>zz", "<cmd>ZenMode<CR>", {
    desc = "Toggle Zen Mode",
})

-- Clipboard mappings inspired by the reference configuration.
-- Normal yanks use Neovim's registers. Leader-y uses the system clipboard.
vim.keymap.set({ "n", "x" }, "<leader>y", '"+y', {
    desc = "Yank to system clipboard",
})
vim.keymap.set("n", "<leader>Y", '"+Y', {
    desc = "Yank line to system clipboard",
})
vim.keymap.set({ "n", "x" }, "<leader>p", '"_dP', {
    desc = "Paste without replacing clipboard",
})
vim.keymap.set({ "n", "x" }, "<leader>d", '"_d', {
    desc = "Delete without replacing clipboard",
})
