require('telescope').setup{
	defaults = {
		mappings = {
			i = {
				["<C-j>"] = "move_selection_next",
				["<C-k>"] = "move_selection_previous",
				["<esc>"] = require('telescope.actions').close, -- exit in insert mode
				["<C-c>"] = require('telescope.actions').close, -- exit with Ctrl+c
			}
		}
	}
}
