
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.api.nvim_set_keymap('n', 'F', '<cmd>lua vim.lsp.buf.format()<CR>', { noremap = true, silent = true })

