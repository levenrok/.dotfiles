local builtin = require("telescope.builtin")

vim.keymap.set("n", "<C-b>", "<Cmd>Neotree toggle<CR>", { desc = "Open Filetree" })
vim.keymap.set("n", "<leader>e", "<Cmd>Neotree<CR>", { desc = "Focus Filetree" })

vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Find Files" })
vim.keymap.set("n", "<leader>p", builtin.buffers, { desc = "File Buffers" })

vim.keymap.set("n", "<leader>t", ":<C-u>edit<Space>", { desc = "Edit New File" })

vim.keymap.set("n", "<C-f>", builtin.live_grep, { desc = "Find" })

vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll Up" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll Down" })

vim.keymap.set("n", "<C-_>", "gcc", { remap = true, desc = "Comment Line" })
vim.keymap.set("v", "<C-_>", "gc", { remap = true, desc = "Comment Selected Lines" })

vim.keymap.set("n", "<leader>`", "<Cmd>terminal<CR>", { desc = "Open Terminal" })

vim.keymap.set("n", "<C-h>", builtin.help_tags, { desc = "Help" })
