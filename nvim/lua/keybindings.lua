local builtin = require("telescope.builtin")

vim.keymap.set("n", "<C-b>", "<Cmd>Neotree toggle<CR>", { desc = "Open Filetree" })
vim.keymap.set("n", "<leader>e", "<Cmd>Neotree<CR>", { desc = "Focus Filetree" })

vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Find Files" })
vim.keymap.set("n", "<leader>p", builtin.buffers, { desc = "File Buffers" })

vim.keymap.set("n", "<leader>t", ":<C-u>tabnew<Space>", { desc = "Edit a File in a Tab" })
vim.keymap.set("n", "<leader><Tab>", "<Cmd>tabnext<CR>", { desc = "Switch between Open Tabs" })
vim.keymap.set("n", "<Bar>", ":<C-u>vnew<Space>", { desc = "Edit a File in a Vertical Split" })

vim.keymap.set("n", "<C-f>", builtin.live_grep, { desc = "Find" })

vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll Up" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll Down" })

-- For older terminals emulators
-- vim.keymap.set("n", "<C-_>", "gcc", { remap = true, desc = "Comment Line" })
-- vim.keymap.set("v", "<C-_>", "gc", { remap = true, desc = "Comment Selected Lines" })

vim.keymap.set("n", "<C-/>", "gcc", { remap = true, desc = "Comment Line" })
vim.keymap.set("v", "<C-/>", "gc", { remap = true, desc = "Comment Selected Lines" })

vim.keymap.set("n", "<leader><F1>", builtin.help_tags, { desc = "Help" })
