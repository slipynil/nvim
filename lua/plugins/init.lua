return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- tinygo plugin
  {
    "pcolladosoto/tinygo.nvim",
    lazy = true,
    config = function() require("tinygo").setup({}) end
  },
  -- nvim-treesitter setup
  {
   	"nvim-treesitter/nvim-treesitter",
   	opts = {
   		ensure_installed = { "vim", "lua", "vimdoc", "html", "css", "go", "gomod" },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
   	},
  },
}
