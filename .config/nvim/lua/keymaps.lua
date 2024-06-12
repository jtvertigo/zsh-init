-- Keybindings
--
-- Copy/paste
vim.keymap.set("n", "<C-a>", "gg<S-v>G")
-- New tab
vim.keymap.set("n", "te", ":tabedit")
vim.keymap.set("n", "<tab>", ":tabnext<Return>", opts)
vim.keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)
-- Split window
vim.keymap.set("n", "ss", ":split<Return>", opts)
vim.keymap.set("n", "sv", ":vsplit<Return>", opts)
-- Move window
vim.keymap.set("n", "s<Left>", "<C-w>h")
vim.keymap.set("n", "s<Up>", "<C-w>k")
vim.keymap.set("n", "s<Down>", "<C-w>j")
vim.keymap.set("n", "s<Right>", "<C-w>l")
