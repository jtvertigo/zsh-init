return {

	{
		"williamboman/mason.nvim",

		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✔",
						package_pending = "➜ ",
						package_uninstalled = "✘",
					},
				},
			})
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim",

		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"dockerls",
					-- "golangci_lint_ls",
					"gopls",
					-- "tsserver"
				},
			})
		end,
	},

	{
		"neovim/nvim-lspconfig",

		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities() -- for completion

			local lspconfig = require("lspconfig")
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})
			lspconfig.dockerls.setup({
				capabilities = capabilities,
			})
			-- lspconfig.golangci_lint_ls.setup({})
			lspconfig.gopls.setup({
				capabilities = capabilities,
			})
			-- lspconfig.tsserver.setup({})

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set({ "n" }, "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
}
