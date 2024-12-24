require("nvim-tree").setup({
	sort_by = "case_sensitive",
	view = {
		width = 30,
	},
	renderer = {
		indent_markers = {
			enable = false,
		},
		icons = {
			show = {
				folder = true,
				file = true,
				git = true,
				folder_arrow = true,
			},
		},
		indent_width = 1,
		add_trailing = false,
		group_empty = false,
		special_files = {},
	},
	filters = {
		dotfiles = false,
		git_ignored = false,
		custom = {},
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
