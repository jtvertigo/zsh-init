require "core"

local custom_init_path = vim.api.nvim_get_runtime_file("lua/custom/init.lua", false)[1]

if custom_init_path then
  dofile(custom_init_path)
end

require("core.utils").load_mappings()

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

-- bootstrap lazy.nvim!
if not vim.loop.fs_stat(lazypath) then
  require("core.bootstrap").gen_chadrc_template()
  require("core.bootstrap").lazy(lazypath)
end

-- vim.cmd("au BufRead,BufNewFile *.templ setfiletype templ")
-- local autocmd = vim.api.nvim_create_autocmd
--
-- vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile" }, {
--   pattern = { "*.templ" },
--   callback = function()
--     local buf = vim.api.nvim_get_current_buf()
--     vim.api.nvim_buf_set_option(buf, "filetype", "templ")
--   end,
-- })

-- Switch between opened tabs with <A+tabId>
for i = 1, 9, 1 do
  vim.keymap.set("n", string.format("<A-%s>", i), function()
    vim.api.nvim_set_current_buf(vim.t.bufs[i])
  end)
end

dofile(vim.g.base46_cache .. "defaults")
vim.opt.rtp:prepend(lazypath)
require "plugins"

-- custom sets
vim.opt.scrolloff = 8
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- golang code formatting
vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})

-- manually load themes
vim.cmd.colorscheme "catppuccin"
vim.cmd.colorscheme "nvchad"
