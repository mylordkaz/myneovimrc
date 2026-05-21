-- lsp.lua - Complete replacement

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		-- JavaScript/TypeScript
		"ts_ls",
		"eslint",
		"tailwindcss",

		-- PHP
		"intelephense",

		-- Docker
		"dockerls",
		"docker_compose_language_service",

		-- CSS/SCSS
		"cssls",

		-- Others
		"jsonls",
		"lua_ls",
		"efm",
	},
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Shared on_attach function
local on_attach = function(client, bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, opts)
	vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
	vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
end

-- Completion configuration
local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = cmp.mapping.select_next_item(),
		["<S-Tab>"] = cmp.mapping.select_prev_item(),
	}),
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
	},
})

local function setup_server(name, config)
	vim.lsp.config(name, config)
	vim.lsp.enable(name)
end

-- TypeScript/JavaScript configuration
setup_server("ts_ls", {
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		typescript = {
			inlayHints = {
				includeInlayParameterNameHints = "all",
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
			},
		},
		javascript = {
			inlayHints = {
				includeInlayParameterNameHints = "all",
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
			},
		},
	},
})

-- PHP configuration
setup_server("intelephense", {
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		intelephense = {
			filetypes = { "php", "blade", "php_only" },
			files = {
				maxSize = 1000000,
			},
			stubs = {
				-- Add Laravel stubs (this is the key part)
				"apache",
				"bcmath",
				"bz2",
				"calendar",
				"Core",
				"ctype",
				"curl",
				"date",
				"dba",
				"dom",
				"enchant",
				"exif",
				"fileinfo",
				"filter",
				"fpm",
				"ftp",
				"gd",
				"gettext",
				"gmp",
				"hash",
				"iconv",
				"imap",
				"intl",
				"json",
				"ldap",
				"libxml",
				"mbstring",
				"mysqli",
				"oci8",
				"odbc",
				"openssl",
				"pcntl",
				"pcre",
				"PDO",
				"pdo_mysql",
				"pdo_pgsql",
				"pdo_sqlite",
				"pgsql",
				"Phar",
				"posix",
				"pspell",
				"readline",
				"Reflection",
				"session",
				"shmop",
				"SimpleXML",
				"soap",
				"sockets",
				"sodium",
				"SPL",
				"sqlite3",
				"standard",
				"superglobals",
				"sysvmsg",
				"sysvsem",
				"sysvshm",
				"tidy",
				"tokenizer",
				"xml",
				"xmlreader",
				"xmlrpc",
				"xmlwriter",
				"xsl",
				"Zend OPcache",
				"zip",
				"zlib",
				"laravel",
				"phpunit",
			},
			environment = {
				-- Include Laravel framework
				includePaths = {
					"/vendor/laravel/framework/src",
				},
			},
			diagnostics = {
				-- Optionally, ignore undefined class errors if needed
				undefinedClassConstants = false,
				undefinedConstants = false,
				undefinedFunctions = false,
				undefinedMethods = false,
				undefinedProperties = false,
				undefinedTypes = false,
			},
		},
	},
})

-- CSS/SCSS configuration
setup_server("cssls", {
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		css = {
			validate = true,
		},
		scss = {
			validate = true,
		},
	},
})

-- Tailwind CSS configuration
setup_server("tailwindcss", {
	capabilities = capabilities,
	on_attach = on_attach,
})

-- Docker configuration
setup_server("dockerls", {
	capabilities = capabilities,
	on_attach = on_attach,
})

setup_server("docker_compose_language_service", {
	capabilities = capabilities,
	on_attach = on_attach,
})

-- Lua configuration
setup_server("lua_ls", {
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim", "it", "describe", "before_each", "after_each" },
				disable = { "missing-fields" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			telemetry = {
				enable = false,
			},
		},
	},
})

-- Define languages for efm
local languages = {
	lua = {
		{
			formatCommand = "stylua --stdin-filepath ${INPUT} -",
			formatStdin = true,
		},
	},
	javascript = {
		{
			formatCommand = "prettier --stdin-filepath ${INPUT} --single-quote false",
			formatStdin = true,
		},
		{
			lintCommand = "eslint_d --format unix --stdin --stdin-filename ${INPUT}",
			lintStdin = true,
			lintFormats = { "%f:%l:%c: %m" },
			lintIgnoreExitCode = true,
		},
	},
	typescript = {
		{
			formatCommand = "prettier --stdin-filepath ${INPUT} --single-quote false",
			formatStdin = true,
		},
		{
			lintCommand = "eslint_d --format unix --stdin --stdin-filename ${INPUT}",
			lintStdin = true,
			lintFormats = { "%f:%l:%c: %m" },
			lintIgnoreExitCode = true,
		},
	},
	typescriptreact = {
		{
			formatCommand = "prettier --stdin-filepath ${INPUT} --single-quote false",
			formatStdin = true,
		},
		{
			lintCommand = "eslint_d --format unix --stdin --stdin-filename ${INPUT}",
			lintStdin = true,
			lintFormats = { "%f:%l:%c: %m" },
			lintIgnoreExitCode = true,
		},
	},
	javascriptreact = {
		{
			formatCommand = "prettier --stdin-filepath ${INPUT} --single-quote false",
			formatStdin = true,
		},
		{
			lintCommand = "eslint_d --format unix --stdin --stdin-filename ${INPUT}",
			lintStdin = true,
			lintFormats = { "%f:%l:%c: %m" },
			lintIgnoreExitCode = true,
		},
	},
	php = {
		{
			formatCommand = "pint --stdin",
			formatStdin = true,
		},
	},
	blade = {
		{
			formatCommand = "blade-formatter --stdin --indent-size 2",
			formatStdin = true,
		},
	},
	css = {
		{
			formatCommand = "prettier --stdin-filepath ${INPUT} --single-quote false",
			formatStdin = true,
		},
		{
			lintCommand = "stylelint --formatter unix --stdin-filename ${INPUT} --stdin",
			lintStdin = true,
			lintFormats = { "%f:%l:%c: %m" },
			lintIgnoreExitCode = true,
		},
	},
	scss = {
		{
			formatCommand = "prettier --stdin-filepath ${INPUT} --single-quote false",
			formatStdin = true,
		},
		{
			lintCommand = "stylelint --formatter unix --stdin-filename ${INPUT} --stdin",
			lintStdin = true,
			lintFormats = { "%f:%l:%c: %m" },
			lintIgnoreExitCode = true,
		},
	},
	json = {
		{
			formatCommand = "prettier --stdin-filepath ${INPUT} --single-quote false",
			formatStdin = true,
		},
	},
	yaml = {
		{
			formatCommand = "prettier --stdin-filepath ${INPUT} --single-quote false",
			formatStdin = true,
		},
	},
}

-- Configure efm with formatters and linters
setup_server("efm", {
	capabilities = capabilities,
	on_attach = on_attach,
	init_options = { documentFormatting = true },
	filetypes = {
		"javascript",
		"typescript",
		"typescriptreact",
		"javascriptreact",
		"php",
		"lua",
		"blade",
		"css",
		"scss",
		"json",
		"yaml",
	},
	settings = {
		rootMarkers = { ".git/" },
		languages = languages,
	},
})

local function select_formatter(bufnr)
	local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
	for _, client in ipairs(clients) do
		if client.name == "efm" and client.supports_method("textDocument/formatting") then
			return "efm"
		end
	end

	for _, client in ipairs(clients) do
		if client.name ~= "efm" and client.supports_method("textDocument/formatting") then
			return client.name
		end
	end
end

-- Format on save
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = {
		"*.lua",
		"*.js",
		"*.ts",
		"*.tsx",
		"*.jsx",
		"*.php",
		"*.blade.php",
		"*.css",
		"*.scss",
		"*.json",
		"*.yaml",
		"*.yml",
	},
	callback = function(args)
		local target = select_formatter(args.buf)
		if not target then
			return
		end

		vim.lsp.buf.format({
			bufnr = args.buf,
			timeout_ms = 3000,
			filter = function(client)
				return client.name == target
			end,
		})
	end,
})

-- Load snippets
require("luasnip.loaders.from_vscode").lazy_load()

-- SQL completion with vim-dadbod
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "sql", "mysql", "plsql" },
	callback = function()
		cmp.setup.buffer({ sources = { { name = "vim-dadbod-completion" }, { name = "buffer" } } })
	end,
})
