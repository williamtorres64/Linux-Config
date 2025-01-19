return {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
      dependencies = { 'nvim-lua/plenary.nvim' },
	  keys = {
		{"<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Fuzzy finder"},
		{"<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Fuzzy find with grep"}		
	  },
}
