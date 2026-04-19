return {
	"nvimtools/none-ls.nvim",
	event = "VeryLazy",
	config = function()
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
		local null_ls = require("null-ls")

		null_ls.setup({
			sources = {
				--- Web Development
				null_ls.builtins.formatting.prettier,

				--- Scripting
				null_ls.builtins.formatting.nixpkgs_fmt,
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.shfmt,
				null_ls.builtins.formatting.black,
				null_ls.builtins.formatting.rubocop,

				--- Systems Programming
				null_ls.builtins.formatting.clang_format,
				null_ls.builtins.formatting.gofmt,

				--- Configuration
				null_ls.builtins.formatting.just,
			},
			on_attach = function(client, bufnr)
				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({ async = false })
						end,
					})
				end
			end,
		})

		vim.keymap.set({ "n", "v" }, "<leader>i", vim.lsp.buf.format, {})
	end,
}
