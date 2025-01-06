require('nvim-treesitter.configs').setup {
	ensure_installed = {
		-- JavaScript/TypeScript
		"javascript",
		"typescript",
		"tsx",

		-- PHP related
		"php",
		"phpdoc",


		-- Styling
		"css",
		"scss",

		-- Docker
		"dockerfile",

		-- Configuration
		"json",
		"yaml",
		"toml",

		-- Others
		"html",
		"markdown",
		"bash",
		"lua",
	},
	sync_install = false,
	auto_install = true,

	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},

	indent = {
		enable = true
	},

}
