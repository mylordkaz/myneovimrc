require("nvim-tree").setup({
	sort_by = "case_sensitive",
	view = {
		width = 30,
	},
	renderer = {
		group_empty = true,
	},
	filters = {
		dotfiles = false,
	},
	git = {
		enable = true,
	},
	actions = {
		open_file = {
			quit_on_open = false,
		},
	},
})
