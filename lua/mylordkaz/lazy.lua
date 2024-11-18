local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"http://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local opts = {
	install = {
		-- "missing" means just install missing plugins
		missing = true,
		-- "notify" means show a notification when changes are made
		notify = false,
	},
	change_detection = {
		-- automatically check for config file changes and reload them
		enabled = true,
		notify = false,
	},
}

return require("lazy").setup({
	'tpope/vim-fugitive',

	{
		'lewis6991/gitsigns.nvim',
		config = true -- Call setup() automatically
	},

	{
		'nvim-telescope/telescope.nvim',
		version = '0.1.8',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-tree/nvim-web-devicons'
		}
	},

	{
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate'
	},

	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
	},

	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v4.x',
		dependencies = {
			-- LSP Support
			'neovim/nvim-lspconfig',
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',
			-- Autocompletion
			'hrsh7th/nvim-cmp',
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'saadparwaiz1/cmp_luasnip',
			'hrsh7th/cmp-nvim-lua',
			-- Snippets
			'L3MON4D3/LuaSnip',
			'rafamadriz/friendly-snippets',
			-- Formatters and linters
			'jose-elias-alvarez/null-ls.nvim',
			'jayp0521/mason-null-ls.nvim',
		}
	},

	-- color schemes
	'sainnhe/sonokai',
	{ "catppuccin/nvim", name = "catppuccin" },
	'tiagovla/tokyodark.nvim',
	{
		'uloco/bluloco.nvim',
		dependencies = { 'rktjmp/lush.nvim' }
	}

}, opts)
