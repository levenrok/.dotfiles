return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"saghen/blink.cmp",
			"pearofducks/ansible-vim",
		},
		config = function()
			local servers = {
				nixd = true,
				clangd = true,
				lua_ls = true,
				bashls = true,
                jedi_language_server = true,
				yamlls = true,
				taplo = true,
			}

			local capabilities = require("blink.cmp").get_lsp_capabilities()
			vim.lsp.config("*", {
				capabilities = capabilities,
			})

			for name, config in pairs(servers) do
				if config == true then
					config = {}
				end

				if next(config) ~= nil then
					local lsp_config = vim.tbl_deep_extend("force", {}, config)
					lsp_config.manual_install = nil
					vim.lsp.config(name, lsp_config)
				end

				vim.lsp.enable(name)
			end

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")

					local settings = servers[client.name]
					if type(settings) ~= "table" then
						settings = {}
					end

					local builtin = require("telescope.builtin")

					vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
					vim.keymap.set("n", "<F12>", builtin.lsp_definitions, { buffer = 0 })
					vim.keymap.set("n", "<S-F12>", builtin.lsp_references, { buffer = 0 })
					-- vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = 0 })
					-- vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { buffer = 0 })
					vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })

					vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { buffer = 0 })
					vim.keymap.set("n", "<leader>.", vim.lsp.buf.code_action, { buffer = 0 })
					vim.keymap.set("n", "<leader>o", builtin.lsp_document_symbols, { buffer = 0 })
					vim.keymap.set("n", "<C-m>", function()
						builtin.diagnostics({ root_dir = true })
					end, { buffer = 0 })
				end,

				vim.diagnostic.config({ virtual_text = true, virutal_lines = true }),
			})
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.nixpkgs_fmt,
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.shfmt,
					null_ls.builtins.formatting.black,
				},
			})

			vim.keymap.set({ "n", "v" }, "<leader>i", vim.lsp.buf.format, {})
		end,
	},
}
