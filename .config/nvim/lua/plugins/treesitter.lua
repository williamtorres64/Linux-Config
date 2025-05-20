return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
		ensure_installed = { "c", "lua", "markdown", "markdown_inline", "cpp", "css", "html", "javascript", "typescript", "tsx", "rust", "bash", "php" },
      })
    end,
  },
}
