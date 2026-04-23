return {
    "stevearc/conform.nvim",
    event = "VeryLazy",
    config = function()
        local conform = require("conform")

        conform.setup({
            formatters_by_ft = {
                nix = { "nixfmt" },
                python = { "ruff_organize_imports", "ruff_format" },
            },
            format_after_save = {
                lsp_format = "fallback",
            },
        })
    end,
}
