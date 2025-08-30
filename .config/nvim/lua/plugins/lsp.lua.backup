return {
  -- nvim-lspconfig
  {
    "neovim/nvim-lspconfig",

	dependencies = {
			{
				'mason-org/mason-lspconfig.nvim',
				dependencies = { 'mason-org/mason.nvim' },

				config = function()
					require('mason-lspconfig').setup({
						ensure_installed = {
							'clangd',
							'lua_ls',
							'rust_analyzer',
							'bashls',
							'basedpyright',
                            'cssls',
                            'html',
						},
					})

					end,
			},

		},

    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      -- Replace <YOUR_LSP_SERVER> with each LSP server you've enabled.
      require('lspconfig')['clangd'].setup {
        capabilities = capabilities
      }

      require('lspconfig')['lua_ls'].setup {
        capabilities = capabilities
      }

      require('lspconfig')['bashls'].setup {
        capabilities = capabilities
      }

      require('lspconfig')['basedpyright'].setup {
        capabilities = capabilities
      }

      require('lspconfig')['intelephense'].setup {
        capabilities = capabilities
      }

      require('lspconfig')['cssls'].setup {
        capabilities = capabilities
      }

      require('lspconfig')['html'].setup {
        capabilities = capabilities
      }

	  require'lspconfig'.ts_ls.setup{}
    end,
  },

  -- nvim-cmp and related plugins (autocomplete)
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
	  "onsails/lspkind.nvim", --> VScode icons for cmp
    },
    config = function()
      local cmp = require('cmp')
	  local lspkind = require('lspkind')
      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
          end,
        },

		formatting = { --> lspkind config
			format = lspkind.cmp_format({
			  mode = 'symbol', -- show only symbol annotations
			  maxwidth = {
				-- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
				-- can also be a function to dynamically calculate max width such as
				-- menu = function() return math.floor(0.45 * vim.o.columns) end,
				menu = 50, -- leading text (labelDetails)
				abbr = 50, -- actual suggestion item
			  },
			  ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
			  show_labelDetails = true, -- show labelDetails in menu. Disabled by default

			  -- The function below will be called before any actual modifications from lspkind
			  -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
			})
	 	},

        mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<Tab>'] = cmp.mapping.confirm({ select = true }), -- Accept with Tab
        ['<S-Tab>'] = cmp.mapping.select_next_item(), -- Cycle backward with Shift+Tab
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          --{ name = 'vsnip' },
        }, {
          { name = 'buffer' },
        }),
      })

      -- Set up command-line completions
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        }),
      })
    end,
  },
	{
		'mason-org/mason.nvim',
		config = function() require('mason').setup(opts) end,
	},

}

