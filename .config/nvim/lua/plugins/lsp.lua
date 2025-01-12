return { {
	"neovim/nvim-lspconfig",
	lazy = false,
	dependencies = {
		{
			'williamboman/mason-lspconfig.nvim',
			dependencies = { 'williamboman/mason.nvim' },

			config = function()
				require('mason-lspconfig').setup({
					ensure_installed = {
						'clangd',
						'lua_ls',
						'rust_analyzer',
						'marksman',
						'jdtls',
						'powershell_es',
						'ltex',
						'bashls',
					},
				})

				require("mason-lspconfig").setup_handlers {
					-- The first entry (without a key) will be the default handler
					-- and will be called for each installed server that doesn't have
					-- a dedicated handler.
					function(server_name) -- default handler (optional)
						require("lspconfig")[server_name].setup {}
					end,
				}
			end,
		},

	},

},

	{
		'williamboman/mason.nvim',
		config = function() require('mason').setup(opts) end,
	},

}
