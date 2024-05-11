return {

	{
		"mfussenegger/nvim-lint",

		event = { "BufReadPre", "BufNewFile" },

		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				dockerfile = { "hadolint" },
				--python = { "pylint" },
				sh = { "shellcheck" },
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

	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",

		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					-- linters
					"shellcheck",
					"hadolint",
					-- formatters
					"stylua",
					"yamlfmt",
					"shfmt",
				},
			})
		end,
	},
}
