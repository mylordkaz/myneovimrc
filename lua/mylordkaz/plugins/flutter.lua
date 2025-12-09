require("flutter-tools").setup({
	ui = {
		border = "rounded",
	},
	decorations = {
		statusline = {
			app_version = false,
			device = true,
			project_config = false,
		},
	},
	debugger = {
		enabled = false,
		run_via_dap = false,
	},
	flutter_lookup_cmd = nil, -- Use flutter from PATH
	fvm = false,             -- takes priority over path, uses <workspace>/.fvm/flutter_sdk if enabled
	widget_guides = {
		enabled = false,
	},
	closing_tags = {
		highlight = "Comment",
		prefix = "// ",
		enabled = false,
	},
	dev_log = {
		enabled = true,
		notify_errors = false,
		open_cmd = "tabedit",
	},
	dev_tools = {
		autostart = false,
		auto_open_browser = false,
	},
	outline = {
		open_cmd = "30vnew",
		auto_open = false,
	},
	lsp = {
		color = {
			enabled = false,
			background = false,
			background_color = nil,
			foreground = false,
			virtual_text = true,
			virtual_text_str = "■",
		},

		capabilities = require("cmp_nvim_lsp").default_capabilities(),
	},
})
