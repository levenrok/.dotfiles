return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "pearofducks/ansible-vim",
    },
    config = function()
        local servers = {
            -- Web Development
            html = true,
            cssls = true,
            ts_ls = {
                settings = {
                    javascript = {
                        inlayHints = {
                            includeInlayEnumMemberValueHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
                            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayVariableTypeHints = false,
                        },
                    },

                    typescript = {
                        inlayHints = {
                            includeInlayEnumMemberValueHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
                            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayVariableTypeHints = false,
                        },
                    },
                },
            },
            svelte = true,
            astro = true,
            tailwindcss = true,
            eslint = true,

            -- Systems Programming
            clangd = true,
            rust_analyzer = true,
            gopls = {
                settings = {
                    gopls = {
                        hints = {
                            assignVariableTypes = true,
                            compositeLiteralFields = true,
                            constantValues = true,
                            functionTypeParameters = true,
                            parameterNames = true,
                            rangeVariableTypes = true,
                        },
                        staticcheck = true,
                    },
                },
            },

            -- Scripting
            nixd = true,
            lua_ls = true,
            bashls = true,
            basedpyright = true,

            -- Configuration
            yamlls = {
                settings = {
                    schemas = {
                        ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] =
                        "*compose.{yml,yaml}",
                        ["https://kubernetesjsonschema.dev/v1.28.0-standalone/all.json"] = "*.k8s.yaml",
                    },
                },
            },
            taplo = true,
            jsonls = true,

            just = true,
            docker_language_server = true,
            nginx_language_server = true,
            hyprls = true,
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
                vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, { buffer = 0 })
                vim.keymap.set("n", "<leader>o", builtin.lsp_document_symbols, { buffer = 0 })
                vim.keymap.set("n", "<leader>i", function()
                    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                end)
                vim.keymap.set("n", "<C-m>", function()
                    builtin.diagnostics({ root_dir = true })
                end, { buffer = 0 })
            end,

            vim.lsp.inlay_hint.enable(true),
            vim.diagnostic.config({ virtual_text = true, virutal_lines = true }),
        })
    end,
}
