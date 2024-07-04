return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",

  config = function()
    local config = require("nvim-treesitter.configs")
    config.setup({
      ensure_installed = {
        "lua",
        "vim",
        "vimdoc",
        "query",
        "elixir",
        "heex",
        "javascript",
        "html",
        "bash",
        "cue",
        "diff",
        "dockerfile",
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "go",
        "gomod",
        "gosum",
        "gotmpl",
        "gowork",
        "gpg",
        "groovy",
        "hcl",
        "helm",
        "ini",
        "jq",
        "json",
        "jsonnet",
        "make",
        "markdown",
        "php",
        "promql",
        "python",
        "terraform",
        "tmux",
        "yaml"
      },
      highlight = { enable = true },
      indent = { enable = true },
    })
  end
}
