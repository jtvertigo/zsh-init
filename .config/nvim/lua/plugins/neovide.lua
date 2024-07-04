if vim.g.neovide then
  vim.g.neovide_padding_top = 10
  vim.api.nvim_set_keymap(
    "n",
    "<C-+>",
    ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>",
    { silent = true }
  )
  vim.api.nvim_set_keymap(
    "n",
    "<C-->",
    ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>",
    { silent = true }
  )
  vim.api.nvim_set_keymap("n", "<C-0>", ":lua vim.g.neovide_scale_factor = 1<CR>", { silent = true })

  vim.g.neovide_cursor_vfx_mode = "railgun"

  vim.o.guifont = "JetBrainsMono Nerd Font:h15"

  vim.g.neovide_refresh_rate = 60

  -- vim.cmd.colorscheme "catppuccin"
  -- vim.cmd.colorscheme "nvchad"
end
