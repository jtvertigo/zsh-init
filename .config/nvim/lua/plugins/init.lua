-- All plugins have lazy=true by default,to load a plugin on startup just lazy=false
-- List of all default plugins & their definitions
local default_plugins = {

  "nvim-lua/plenary.nvim",

  {
    "NvChad/base46",
    branch = "v2.0",
    build = function()
      require("base46").load_all_highlights()
    end,
  },

  {
    "NvChad/ui",
    branch = "v2.0",
    lazy = false,
  },

  {
    "NvChad/nvterm",
    init = function()
      require("core.utils").load_mappings "nvterm"
    end,

    opts = function()
      return require "plugins.configs.nvterm"
    end,

    config = function(_, opts)
      require "base46.term"
      require("nvterm").setup(opts)
    end,
  },

  {
    "NvChad/nvim-colorizer.lua",
    event = "User FilePost",
    config = function(_, opts)
      require("colorizer").setup(opts)

      -- execute colorizer as soon as possible
      vim.defer_fn(function()
        require("colorizer").attach_to_buffer(0)
      end, 0)
    end,
  },

  {
    "nvim-tree/nvim-web-devicons",
    opts = function()
      return { override = require "nvchad.icons.devicons" }
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "devicons")
      require("nvim-web-devicons").setup(opts)
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    version = "2.20.7",
    event = "User FilePost",
    opts = function()
      return require("plugins.configs.others").blankline
    end,
    config = function(_, opts)
      require("core.utils").load_mappings "blankline"
      dofile(vim.g.base46_cache .. "blankline")
      require("indent_blankline").setup(opts)
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    tag = "v0.9.2",
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = function()
      return require "plugins.configs.treesitter"
    end,

    -- load gotmpl syntax support
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "syntax")

      vim.filetype.add ( {
        extension = {
          gotmpl = 'gotmpl',
          gohtml = 'gotmpl',
          gohtmltmpl = 'gotmpl',
          gohtxttmpl = 'gotmpl',
          gohtexttmpl = 'gotmpl',
        },
      } )

      local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()
      parser_configs['gotmpl'] = {
        install_info = {
          url = 'https://github.com/ngalaiko/tree-sitter-go-template',
          files = { 'src/parser.c' },
        },
        filetype = 'gotmpl',
        used_by = { 'gohtmltmpl', 'gotexttmpl', 'gotmpl', 'gotxttmpl', 'gohtml' },
      }

      require("nvim-treesitter.configs").setup(opts)
    end,

  },

  -- git stuff
  {
    "lewis6991/gitsigns.nvim",
    event = "User FilePost",
    opts = function()
      return require("plugins.configs.others").gitsigns
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "git")
      require("gitsigns").setup(opts)
    end,
  },

  -- lsp stuff
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    opts = function()
      return require "plugins.configs.mason"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "mason")
      require("mason").setup(opts)

      -- custom nvchad cmd to install all mason binaries listed
      vim.api.nvim_create_user_command("MasonInstallAll", function()
        if opts.ensure_installed and #opts.ensure_installed > 0 then
          vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
        end
      end, {})

      vim.g.mason_binaries_list = opts.ensure_installed
    end,
  },

  {
    "neovim/nvim-lspconfig",
    event = "User FilePost",
    config = function()
      require "plugins.configs.lspconfig"
    end,
  },

  -- A completion plugin for neovim coded in Lua. 
  -- load luasnips + cmp related in insert mode only
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("plugins.configs.others").luasnip(opts)
        end,
      },

      -- autopairing of (){}[] etc
      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)

          -- setup cmp for autopairs
          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },

      -- cmp sources plugins
      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
      },
    },
    opts = function()
      return require "plugins.configs.cmp"
    end,
    config = function(_, opts)
      require("cmp").setup(opts)
    end,
  },

  -- plugin for comments
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = "n",          desc = "Comment toggle current line" },
      { "gc",  mode = { "n", "o" }, desc = "Comment toggle linewise" },
      { "gc",  mode = "x",          desc = "Comment toggle linewise (visual)" },
      { "gbc", mode = "n",          desc = "Comment toggle current block" },
      { "gb",  mode = { "n", "o" }, desc = "Comment toggle blockwise" },
      { "gb",  mode = "x",          desc = "Comment toggle blockwise (visual)" },
    },
    init = function()
      require("core.utils").load_mappings "comment"
    end,
    config = function(_, opts)
      require("Comment").setup(opts)
    end,
  },

  -- file managing , picker etc
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    init = function()
      require("core.utils").load_mappings "nvimtree"
    end,
    opts = function()
      return require "plugins.configs.nvimtree"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "nvimtree")
      require("nvim-tree").setup(opts)
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = "Telescope",
    init = function()
      require("core.utils").load_mappings "telescope"
    end,
    opts = function()
      return require "plugins.configs.telescope"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "telescope")
      local telescope = require "telescope"
      telescope.setup(opts)

      -- load extensions
      for _, ext in ipairs(opts.extensions_list) do
        telescope.load_extension(ext)
      end
    end,
  },

  -- catppuccin colorscheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    -- config = function()
    --   vim.cmd.colorscheme "catppuccin"
    --   vim.cmd([[colorscheme catppuccin]])
    --   vim.cmd([[colorscheme nvchad]])
    -- end
  },

  -- tokyonight colorscheme
  -- {
	-- 	"folke/tokyonight.nvim",
	-- 	name = "tokyonight",
	-- 	priority = 1000,
	-- 	config = function()
	-- 		vim.cmd([[colorscheme tokyonight-night]])
	-- 	end,
	-- },

  -- rose-pine colorscheme
  -- {
	-- 	"rose-pine/neovim",
	-- 	name = "rose-pine",
	-- 	priority = 1000,
	-- },

  -- helm syntax support for gotemplate
  {
    "towolf/vim-helm",
    name = "vim-helm",
  },

  -- An asynchronous linter plugin
  {
    "mfussenegger/nvim-lint",

    event = { "BufReadPre", "BufNewFile" },

    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        dockerfile = { "hadolint" },
        --python = { "pylint" },
        sh = { "shellcheck" },
        yaml = { "yamllint" },
      }

      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })

      vim.keymap.set("n", "<leader>l", function()
        lint.try_lint()
      end, { desc = "Trigger linting for current file" })

      --vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      --  callback = function()
      --  require("lint").try_lint("hadolint")
      --  end,
      --})
    end,
  },

  -- tabline at the bottom
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = "VeryLazy",
    opts = {
      options = {
        icons_enabled = true,
        theme = 'catppuccin-mocha', -- horizon
        -- component_separators = '|',
        component_separators = '',
        section_separators = { left = '', right = '' },
      },
    },
  },

  -- show vertical line when characters in line more then 80
  {
    "m4xshen/smartcolumn.nvim",
    event = "VeryLazy",

    opts = function()
      return require "plugins.configs.smartcolumn"
    end,
    config = function(_, opts)
      require("smartcolumn").setup(opts)
    end,
  },

  -- show messages fom linters in special pane
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>tx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>tt",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>tL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>tQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },

  -- pluging for popup notify messages
  {
  "rcarriga/nvim-notify",
    opts = {
      timeout = 300,
    },
  },

  -- pluging for cmdline and messages
  {
    "folke/noice.nvim",
    event = "VeryLazy",

    dependencies = {
      "MunifTanjim/nui.nvim",
    },

    opts = function()
      return require "plugins.configs.noice"
    end,
    config = function(_, opts)
      require("noice").setup(opts)
    end,
  },

  -- dashboard plugin
  {
    "nvimdev/dashboard-nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },

    event = 'VimEnter',

    opts = function()
      return require "plugins.configs.dashboard"
    end,

    config = function(_, opts)
      require("dashboard").setup(opts)
    end,
  },

  -- Show binded keys on ui pane
  -- Only load whichkey after all the gui
  {
    "folke/which-key.nvim",
    keys = { "<leader>", "<c-r>", "<c-w>", '"', "'", "`", "c", "v", "g" },
    init = function()
      require("core.utils").load_mappings "whichkey"
    end,
    cmd = "WhichKey",
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "whichkey")
      require("which-key").setup(opts)
    end,
  },
}

local config = require("core.utils").load_config()

if #config.plugins > 0 then
  table.insert(default_plugins, { import = config.plugins })
end


require("lazy").setup(default_plugins, config.lazy_nvim)
require("plugins.neovide")

