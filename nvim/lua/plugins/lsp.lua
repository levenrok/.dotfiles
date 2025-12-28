return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"pearofducks/ansible-vim",
		},
		config = function()
			local servers = {
				nixd = true,
				lua_ls = true,
				bashls = true,

				yamlls = {
					settings = {
						schemas = {
							["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*compose.{yml,yaml}",
							["https://kubernetesjsonschema.dev/v1.28.0-standalone/all.json"] = "*.k8s.yaml",
						},
					},
				},
				taplo = true,
				jsonls = true,

				cmake = true,
				docker_language_server = true,
				nginx_language_server = true,
				hyprls = true,

				clangd = { offsetEncoding = { "utf-16" } },
				rust_analyzer = true,
				gopls = true,
			}

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			for name, config in pairs(servers) do
				if config == true then
					config = {}
				end

				if next(config) ~= nil then
					local lsp_config = vim.tbl_deep_extend("force", { capabilities = capabilities }, config)
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
					vim.keymap.set("n", "<F24>", builtin.lsp_references, { buffer = 0 })
					-- vim.keymap.set("n", "", vim.lsp.buf.declaration, { buffer = 0 })
					-- vim.keymap.set("n", "", vim.lsp.buf.type_definition, { buffer = 0 })
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
		"NoahTheDuke/vim-just",
		ft = { "just" },
	},
	{
		"nvimtools/none-ls.nvim",
		event = "VeryLazy",
		config = function()
			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
			local null_ls = require("null-ls")

			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.nixpkgs_fmt,
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.shfmt,
					null_ls.builtins.formatting.clang_format,
					null_ls.builtins.formatting.rustfmt,
					null_ls.builtins.formatting.gofmt,
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
	},
}
