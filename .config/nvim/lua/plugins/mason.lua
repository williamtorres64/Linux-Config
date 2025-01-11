return {
	{"williamboman/mason.nvim", lazy=false},

	{"williamboman/mason-lspconfig.nvim",
	opts = {ensure_installed = { "lua_ls", "harper_ls"}},
	lazy=false},

	{"neovim/nvim-lspconfig", lazy=false},
}
