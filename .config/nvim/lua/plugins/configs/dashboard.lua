local config = {
  theme = 'hyper',
  disable_move = false,
  shortcut_type = 'letter',
  change_to_vcs_root = false,
  config = {
    week_header = {
      enable = true,
    },

    shortcut = {
      {
        desc = '󰊳 Update',
        -- group = '@property',
        group = 'Number',
        action = 'Lazy update',
        key = 'u'
      },
      {
        icon = ' ',
        icon_hl = '@variable',
        desc = 'Files',
        group = 'Label',
        action = 'Telescope find_files',
        key = 'f',
      },
      {
        desc = ' Apps',
        group = 'Apps',
        action = 'cd /home/vertigo/work/irlix',
        key = 'a',
      },
      {
        desc = ' dotfiles',
        group = 'DiagnosticHint',
        action = 'cd /home/vertigo/.config/nvim',
        key = 'd',
      },
    },

    footer = {
      '',
    }
  },

  hide = {
    statusline = true,
    tabline = true,
    winbar = true,
  },
}

return config
