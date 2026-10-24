-- Plugin manager setup and plugin declarations will go here.

  -- Download and load plugins.
  vim.pack.add({
      { src = "https://github.com/mason-org/mason.nvim" },
      { src = "https://github.com/neovim/nvim-lspconfig" },
      { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
      { src = "https://github.com/hrsh7th/nvim-cmp" },
      { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
      { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
      { src = "https://github.com/nvim-lua/plenary.nvim" },
      { src = "https://github.com/nvim-telescope/telescope.nvim" },
      { src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2",}, 
      { src = "https://github.com/nvim-treesitter/nvim-treesitter",},
      { src = "https://github.com/mbbill/undotree",},
      { src = "https://github.com/laytan/cloak.nvim",},
      { src = "https://github.com/norcalli/nvim-colorizer.lua",},
      { src = "https://github.com/tpope/vim-fugitive",},
      -- Refactoring.nvim needs this async library on Neovim 0.12.
      { src = "https://github.com/lewis6991/async.nvim",},
      { src = "https://github.com/ThePrimeagen/refactoring.nvim",},
      { src = "https://github.com/folke/trouble.nvim",},
      { src = "https://github.com/folke/zen-mode.nvim",},
  }, {
      -- Allow rc/nvim/setup.sh to bootstrap plugins without an interactive prompt.
      confirm = false,
  })
