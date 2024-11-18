require('nvim-treesitter.configs').setup {
	ensure_installed = {
		-- Web development
		"html", "css", "javascript", "typescript",

		-- Backend
		"go",

		-- Frameworks
		"tsx", "svelte",

		-- Extras that are good to have
		"json", "yaml", "markdown", "bash", "lua",
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

	-- Optional: Enable code folding
	fold = {
		enable = true
	}
}
