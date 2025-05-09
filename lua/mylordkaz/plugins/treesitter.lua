require("nvim-treesitter.configs").setup({
	build = ":TSUpdate",
	ensure_installed = {
		-- Web development
		"html",
		"css",
		"javascript",
		"typescript",

		-- Backend
		"go",

		-- Frameworks
		"tsx",
		"svelte",
		"astro",

		-- Extras that are good to have
		"json",
		"yaml",
		"markdown",
		"bash",
		"lua",
		"gitignore",
		"solidity",
	},

	auto_install = true,

	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},

	indent = {
		enable = true,
	},
})
