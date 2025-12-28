local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local opts = {
	install = {
		missing = true,
		notify = false,
	},
	change_detection = {
		enabled = true,
		notify = false,
	},
}

return require("lazy").setup({
	-- ========================================
	-- Git Integration
	-- ========================================
	"tpope/vim-fugitive",
	{
		"lewis6991/gitsigns.nvim",
		config = true,
	},

	-- ========================================
	-- File Navigation & Search
	-- ========================================
	{
		"nvim-telescope/telescope.nvim",
		version = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
		},
	},
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
	},

	-- ========================================
	-- Language Support & Syntax
	-- ========================================
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
	},
	"wuelnerdotexe/vim-astro",

	-- ========================================
	-- LSP & Completion
	-- ========================================
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
	},

	-- ========================================
	-- Editing Enhancements
	-- ========================================
	{
		"windwp/nvim-autopairs",
	},
	{
		"windwp/nvim-ts-autotag",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
	{
		"numToStr/Comment.nvim",
		config = true,
		lazy = false,
	},
	{
		"kylechui/nvim-surround",
		version = "^3.0.0",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({})
		end,
	},

	-- ========================================
	-- Color Schemes
	-- ========================================
	"sainnhe/sonokai",
	{
		"catppuccin/nvim",
		name = "catppuccin",
	},
	"tiagovla/tokyodark.nvim",
	{
		"uloco/bluloco.nvim",
		dependencies = { "rktjmp/lush.nvim" },
	},
	{
		"miikanissi/modus-themes.nvim",
		priority = 1000,
	},
	{
		"projekt0n/github-nvim-theme",
		name = "github-theme",
	},

	-- ========================================
	-- Mobile app development
	-- ========================================
	{
		"akinsho/flutter-tools.nvim",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
}, opts)
