vim.g.mapleader = " "

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Bind <leader>f to vim.lsp.buf.format()
vim.api.nvim_set_keymap('n', '<Leader>f', '<Cmd>lua vim.lsp.buf.format()<CR>', { noremap = true, silent = true })
